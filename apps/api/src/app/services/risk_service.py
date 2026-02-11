from typing import Any

from supabase import Client


class RiskService:
    def __init__(self, db: Client) -> None:
        self.db = db

    async def calculate_risk(self, client_id: str) -> str:
        """Calculate risk level for a client based on payment history."""
        raise NotImplementedError

    async def get_summary(self) -> dict[str, Any]:
        """Get risk summary: counts by level + total overdue amount."""
        raise NotImplementedError
