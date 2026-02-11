from typing import Any, cast

from supabase import Client


async def get_all_invoices(db: Client) -> list[dict[str, Any]]:
    response = db.table("invoices").select("*").execute()
    return cast(list[dict[str, Any]], response.data)


async def get_overdue_invoices(db: Client) -> list[dict[str, Any]]:
    response = db.table("invoices").select("*").eq("status", "overdue").execute()
    return cast(list[dict[str, Any]], response.data)


async def get_invoice_by_id(db: Client, invoice_id: str) -> dict[str, Any] | None:
    response = db.table("invoices").select("*").eq("id", invoice_id).single().execute()
    return cast(dict[str, Any] | None, response.data)
