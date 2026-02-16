from datetime import date

from pydantic import BaseModel


class InvoiceResponse(BaseModel):
    id: str
    client_id: str
    invoice_number: str
    amount: float
    issued_date: date
    due_date: date
    status: str
