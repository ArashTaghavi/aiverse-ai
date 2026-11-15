from datetime import datetime
from typing import Annotated, Literal

from click import File
from pydantic import BaseModel, Field


class ProductData(BaseModel):
    id: int
    title: str
    description: str
    price: int
    stock: int
    image: str


class ProductsBlock(BaseModel):
    type: Literal["products"] = "products"
    data: list[ProductData]


class OrderItemData(BaseModel):
    id: int
    order_id: int
    product_id: int
    quantity: int
    unit_price: int
    total_price: int


class PaymentData(BaseModel):
    id: int
    order_id: int
    amount: int
    status: str
    method: str
    transaction_id: str | None = None
    reference_id: str | None = None
    paid_at: datetime | None = None
    refunded_at: datetime | None = None
    failure_reason: str | None = None
    created_at: datetime | None = None
    updated_at: datetime | None = None


class OrderData(BaseModel):
    id: int
    user_id: int
    order_number: str
    total_amount: int
    order_status: str
    payment_status: str
    tracking_code: str | None = None
    shipping_address: str
    paid_at: datetime | None = None
    shipped_at: datetime | None = None
    delivered_at: datetime | None = None
    cancelled_at: datetime | None = None
    cancellation_reason: str | None = None
    created_at: datetime | None = None
    updated_at: datetime | None = None
    items: list[OrderItemData] = Field(default_factory=list)
    payments: list[PaymentData] = Field(default_factory=list)


class OrderBlock(BaseModel):
    type: Literal["order"] = "order"
    data: OrderData


class ChatResponse(BaseModel):
    message: str = Field(
        description=(
            "A brief, user-friendly response in the user's language. "
            "Summarize the result without repeating all structured data. "
            "For products, briefly introduce the matching products. "
            "For orders, briefly explain the order status. "
            "For general questions, answer directly."
        )
    )
    blocks: list[Annotated[ProductsBlock | OrderBlock, Field(discriminator="type")]] = Field(
        default_factory=list,
        description=(
            "Only products and order blocks are supported. For multiple complete "
            "orders, use one order block per order, never an orders block. "
            "For statistics or brief order summaries, return an empty list and "
            "answer in message. Never invent missing fields to populate a block."
        ),
    )
