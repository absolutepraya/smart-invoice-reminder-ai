from typing import Any

from supabase import Client


class RiskService:
    def __init__(self, db: Client) -> None:
        self.db = db

    async def calculate_risk(self, client_id: str) -> str:
        """Run ML model to predict payment risk for a client.

        Uses payment history (days_late from payments table) to produce
        a probability_score and risk_label. Results are logged to
        risk_scoring_logs for drift tracking.
        """
        raise NotImplementedError

    async def get_summary(self) -> dict[str, Any]:
        """Get risk summary: counts by level + total overdue amount."""
        raise NotImplementedError
