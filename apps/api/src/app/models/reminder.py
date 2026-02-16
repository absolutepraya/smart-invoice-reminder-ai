from datetime import datetime

from pydantic import BaseModel


class ReminderResponse(BaseModel):
    id: str
    invoice_id: str
    channel: str
    message_type: str
    message_content: str
    delivery_status: str
    sent_at: datetime
