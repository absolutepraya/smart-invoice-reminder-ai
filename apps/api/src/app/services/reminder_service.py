from typing import Any

from supabase import Client


class ReminderService:
    def __init__(self, db: Client) -> None:
        self.db = db

    async def generate_reminder(self, invoice_id: str, risk_level: str) -> str:
        """Generate reminder message with tone adapted to risk level.

        Mapping: LOW -> SOPAN, MEDIUM -> TEGAS, HIGH -> PERINGATAN.
        """
        raise NotImplementedError

    async def send_reminder(
        self,
        invoice_id: str,
        channel: str,
        message_type: str,
        content: str,
    ) -> dict[str, Any]:
        """Send reminder via channel and log to reminder_logs table.

        Before sending, check reminder_logs to prevent duplicate sends
        on the same day for the same invoice.
        """
        raise NotImplementedError

    async def list_all(self) -> list[dict[str, Any]]:
        """List all reminder logs."""
        raise NotImplementedError
