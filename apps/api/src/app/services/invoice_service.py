from typing import Any

from supabase import Client


class InvoiceService:
    def __init__(self, db: Client) -> None:
        self.db = db

    async def list_all(self) -> list[dict[str, Any]]:
        raise NotImplementedError

    async def list_overdue(self) -> list[dict[str, Any]]:
        raise NotImplementedError

    async def get_by_id(self, invoice_id: str) -> dict[str, Any] | None:
        raise NotImplementedError
