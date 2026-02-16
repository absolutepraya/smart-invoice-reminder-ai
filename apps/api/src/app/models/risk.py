from datetime import date

from pydantic import BaseModel


class RiskScoringLogResponse(BaseModel):
    id: str
    client_id: str
    evaluation_date: date
    probability_score: float
    risk_label: str
    model_version: str


class RiskSummaryResponse(BaseModel):
    low: int
    medium: int
    high: int
    total_overdue_amount: float
