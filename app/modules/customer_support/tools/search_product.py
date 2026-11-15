from langchain_core.tools import tool
from sqlalchemy import or_, select

from app.core.database import SessionLocal

from .models import Product


@tool
def search_product(query: str) -> list[dict]:
    """Search store products by name or description.

    Use this tool when customers ask about products,
    prices, availability, or product specifications.

    Args:
        query: Product name or search keywords.
    """

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
                )
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
            }
            for product in products
        ]
