from pydantic import BaseModel


class InvoiceResponse(BaseModel):
    id: str
    client_id: str
    client_name: str
    amount: float
    currency: str
    status: str
    due_date: str
    days_overdue: int
    risk_level: str
