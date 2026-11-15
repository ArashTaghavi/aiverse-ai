from langchain.tools import ToolRuntime, tool
from sqlalchemy import select

from app.core.database import SessionLocal

from ..models import Order, OrderItem, Payment, Product
from ..schemas import ErrorResponse, NotFoundResponse


@tool
def get_customer_order(tracking_code: str, runtime: ToolRuntime) -> dict:
    """Find the authenticated customer's order and its items by tracking code.

    Use when a customer provides a shipping tracking code and asks about
    their order, delivery status, payment status, or purchased items.

    Args:
        tracking_code: The order's shipping tracking code.
    """

    tracking_code = tracking_code.strip()
    if not tracking_code:
        return ErrorResponse(message="invalid_tracking_code").model_dump()

    context = runtime.context

    user_id = context.get("user_id") if isinstance(context, dict) else None

    if not isinstance(user_id, int) or user_id <= 0:
        return ErrorResponse(
            message="Invalid or missing user_id in agent context"
        ).model_dump()

    with SessionLocal() as db:
        order = db.scalar(
            select(Order).where(
                Order.tracking_code == tracking_code,
                Order.user_id == user_id,
            )
        )
        if order is None:
            return NotFoundResponse(message="Order not found").model_dump()

        items = db.execute(
            select(OrderItem, Product.title)
            .outerjoin(Product, Product.id == OrderItem.product_id)
            .where(OrderItem.order_id == order.id)
            .order_by(OrderItem.id)
        ).all()

        payments = db.scalars(
            select(Payment)
            .join(Order, Payment.order_id == Order.id)
            .where(Order.id == order.id, Order.user_id == user_id)
            .order_by(Payment.id.desc())
        ).all()

        return {
            "id": order.id,
            "user_id": order.user_id,
            "order_number": order.order_number,
            "tracking_code": order.tracking_code,
            "order_status": order.order_status,
            "payment_status": order.payment_status,
            "total_amount": order.total_amount,
            "shipping_address": order.shipping_address,
            "paid_at": order.paid_at,
            "shipped_at": order.shipped_at,
            "delivered_at": order.delivered_at,
            "cancelled_at": order.cancelled_at,
            "cancellation_reason": order.cancellation_reason,
            "created_at": order.created_at,
            "updated_at": order.updated_at,
            "items": [
                {
                    "id": item.id,
                    "order_id": item.order_id,
                    "product_id": item.product_id,
                    "quantity": item.quantity,
                    "unit_price": item.unit_price,
                    "total_price": item.total_price,
                }
                for item, title in items
            ],
            "payments": [
                {
                    "id": payment.id,
                    "order_id": payment.order_id,
                    "amount": payment.amount,
                    "status": payment.status,
                    "method": payment.method,
                    "transaction_id": payment.transaction_id,
                    "reference_id": payment.reference_id,
                    "paid_at": payment.paid_at,
                    "refunded_at": payment.refunded_at,
                    "failure_reason": payment.failure_reason,
                    "created_at": payment.created_at,
                    "updated_at": payment.updated_at,
                }
                for payment in payments
            ],
        }
