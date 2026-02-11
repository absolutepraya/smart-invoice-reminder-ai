from supabase import Client


class ReminderService:
    def __init__(self, db: Client) -> None:
        self.db = db

    async def generate_reminder(self, invoice_id: str, risk_level: str) -> str:
        """Generate reminder message adapted to risk level."""
        raise NotImplementedError

    async def send_email(self, to: str, subject: str, body: str) -> bool:
        """Send reminder via email."""
        raise NotImplementedError

    async def list_all(self) -> list[dict]:
        raise NotImplementedError
