from supabase import Client


async def get_all_invoices(db: Client) -> list[dict]:
    response = db.table("invoices").select("*").execute()
    return response.data


async def get_overdue_invoices(db: Client) -> list[dict]:
    response = (
        db.table("invoices")
        .select("*")
        .eq("status", "overdue")
        .execute()
    )
    return response.data


async def get_invoice_by_id(db: Client, invoice_id: str) -> dict | None:
    response = db.table("invoices").select("*").eq("id", invoice_id).single().execute()
    return response.data
