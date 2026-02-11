from supabase import Client


async def get_all_clients(db: Client) -> list[dict]:
    response = db.table("clients").select("*").execute()
    return response.data


async def get_client_by_id(db: Client, client_id: str) -> dict | None:
    response = db.table("clients").select("*").eq("id", client_id).single().execute()
    return response.data
