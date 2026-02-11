from pydantic import BaseModel


class ClientResponse(BaseModel):
    id: str
    name: str
    email: str
    risk_level: str
