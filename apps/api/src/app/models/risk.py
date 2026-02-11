from pydantic import BaseModel


class RiskSummaryResponse(BaseModel):
    low: int
    medium: int
    high: int
    total_overdue_amount: float
