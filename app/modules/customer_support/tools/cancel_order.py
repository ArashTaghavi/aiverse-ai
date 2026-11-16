from datetime import datetime, timedelta, timezone

from langchain.tools import ToolRuntime, tool
from langgraph.types import interrupt
from sqlalchemy import or_, select

from app.core.database import SessionLocal

from ..context import CustomerSupportContext
from ..models import Order
from ..schemas import ErrorResponse, NotFoundResponse, SuccessResponse


@tool
def cancel_order(
    order_identifier: str,
    runtime: ToolRuntime[CustomerSupportContext],
    cancellation_reason: str | None = None,
) -> dict:
    """Start the cancellation flow for the authenticated customer's order.

    Call this tool as soon as the customer requests cancellation and supplies
    an order number or tracking code. Do not ask the customer to confirm before
    calling it: the tool itself requests confirmation using a frontend dialog.
    Calling the tool does not immediately cancel the order.

    Only PENDING and PROCESSING orders can be cancelled. The tool requires
    explicit customer confirmation before changing the order. It pauses the graph
    with interrupt before making changes. The server must expose the interrupt
    to the customer and resume the same user-owned thread with Command(resume=...)
    containing confirmed (a boolean).
    A checkpointer and stable thread_id are required. The resume value must
    come from the customer's confirmation action, never from the model.
    Declining confirmation leaves the order unchanged. Eligibility and
    ownership are checked again after confirmation, under a database lock.

    This tool only cancels the order; it does not issue or promise refunds,
    change payment status, or restore inventory. A paid order may require
    a separate refund process. Do not report a refund as completed.

    Args:
        order_identifier: The order number or shipping tracking code.
        cancellation_reason: Optional reason provided by the customer.
    """
    order_identifier = order_identifier.strip()
    if not order_identifier:
        return ErrorResponse(message="invalid_order_identifier").model_dump()

    context = runtime.context
    user_id = context.get("user_id") if isinstance(context, dict) else None
    if type(user_id) is not int or user_id <= 0:
        return ErrorResponse(
            message="Invalid or missing user_id in agent context"
        ).model_dump()

    # Do not hold a database transaction or row lock while waiting for a user.
    with SessionLocal() as db:
        order = db.scalar(
            select(Order).where(
                Order.user_id == user_id,
                or_(
                    Order.order_number == order_identifier,
                    Order.tracking_code == order_identifier,
                ),
            )
        )
        if order is None:
            return NotFoundResponse(message="Order not found").model_dump()
        order_id = order.id
        if order.order_status == "CANCELLED":
            return SuccessResponse(
                message="order_already_cancelled",
                data={
                    "id": order.id,
                    "order_number": order.order_number,
                    "order_status": order.order_status,
                },
            ).model_dump()
        if order.order_status not in {"PENDING", "PROCESSING"} or (
            order.shipped_at is not None or order.delivered_at is not None
        ):
            return ErrorResponse(message="order_cannot_be_cancelled").model_dump()
        confirmation_request = {
            "type": "order_cancellation_confirmation",
            "message": f"سفارش شماره {order.order_number} در حال لغو شدن است. آیا تأیید می‌کنید؟",
        }

    confirmation = interrupt(confirmation_request)
    if (
        not isinstance(confirmation, dict)
        or type(confirmation.get("confirmed")) is not bool
    ):
        return ErrorResponse(message="invalid_cancellation_confirmation").model_dump()
    if not confirmation["confirmed"]:
        return {
            "status": "declined",
            "message": "order_cancellation_declined",
        }

    with SessionLocal() as db, db.begin():
        order = db.scalar(
            select(Order)
            .where(
                Order.user_id == user_id,
                Order.id == order_id,
            )
            .with_for_update()
        )
        if order is None:
            return NotFoundResponse(message="Order not found").model_dump()

        def summary() -> dict:
            return {
                "id": order.id,
                "order_number": order.order_number,
                "order_status": order.order_status,
                "payment_status": order.payment_status,
                "cancelled_at": order.cancelled_at,
                "cancellation_reason": order.cancellation_reason,
            }

        if order.order_status == "CANCELLED":
            return SuccessResponse(
                message="order_already_cancelled", data=summary()
            ).model_dump()
        if order.order_status not in {"PENDING", "PROCESSING"} or (
            order.shipped_at is not None or order.delivered_at is not None
        ):
            return ErrorResponse(message="order_cannot_be_cancelled").model_dump()

        # Store local naive timestamps consistently with the existing DateTime model.
        now = datetime.now(timezone(timedelta(hours=3, minutes=30))).replace(
            tzinfo=None
        )
        order.order_status = "CANCELLED"
        order.cancelled_at = now
        order.updated_at = now
        order.cancellation_reason = (
            cancellation_reason.strip() or None if cancellation_reason else None
        )
        db.flush()
        return SuccessResponse(message="order_cancelled", data=summary()).model_dump()
