from langchain_core.tools import tool
from sqlalchemy import or_, select

from app.core.database import SessionLocal

from ..models import Product


@tool
def search_product(query: str) -> list[dict]:
    """Search the store's product catalog by product name, brand, or model.

    Use this tool when customers ask about:
    - Available products, brands, or models.
    - Product prices and stock availability.
    - Product specifications and descriptions.
    - Product comparisons and recommendations.
    - Cheapest or most expensive products.

    Query construction:
    - Extract only meaningful product search keywords.
    - Remove conversational phrases and generic shopping words.
    - Preserve brand names, model numbers, and technical specifications.
    - Translate or normalize product names when appropriate.
    - Do not include price comparisons or sorting instructions in the query.

    Examples:
    - "گوشی iphone چی داری؟" -> "iphone"
    - "آیفون چنده؟" -> "iphone"
    - "قیمت آیفون ۱۶ پرو چنده؟" -> "iphone 16 pro"
    - "گرون‌ترین آیفون چنده؟" -> "iphone"
    - "ارزون‌ترین سامسونگ رو نشون بده" -> "samsung"
    - "لپ‌تاپ ایسوس داری؟" -> "asus"
    - "آیفون با حافظه ۲۵۶ گیگ می‌خوام" -> "iphone 256GB"

    Return matching products with their actual prices, stock,
    and specifications. Never invent product information.
    """
    print(f"query:{query}")

    query = query.strip()
    if not query:
        return []

    with SessionLocal() as db:
        products = db.scalars(
            select(Product)
            .where(
                Product.deleted_at.is_(None),
                or_(
                    Product.title.ilike(f"%{query}%"),
                    Product.description.ilike(f"%{query}%"),
                ),
            )
            .order_by(Product.id.desc())
            .limit(10)
        ).all()

        return [
            {
                "id": product.id,
                "title": product.title,
                "description": product.description,
                "price": product.price,
                "stock": product.stock,
                "image": product.image,
            }
            for product in products
        ]
