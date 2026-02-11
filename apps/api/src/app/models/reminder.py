from pydantic import BaseModel


class ReminderResponse(BaseModel):
    id: str
    invoice_id: str
    client_name: str
    channel: str
    status: str
    sent_at: str
