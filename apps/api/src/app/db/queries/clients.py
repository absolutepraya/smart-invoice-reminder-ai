from typing import Any, cast

from supabase import Client


async def get_all_clients(db: Client) -> list[dict[str, Any]]:
    response = db.table("clients").select("*").execute()
    return cast(list[dict[str, Any]], response.data)


async def get_client_by_id(db: Client, client_id: str) -> dict[str, Any] | None:
    response = db.table("clients").select("*").eq("id", client_id).single().execute()
    return cast(dict[str, Any] | None, response.data)
