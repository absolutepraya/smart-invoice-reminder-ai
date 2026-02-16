from datetime import datetime

from pydantic import BaseModel


class ClientResponse(BaseModel):
    id: str
    company_name: str
    email: str
    phone: str | None = None
    current_risk_category: str
    created_at: datetime
