from fastapi import APIRouter

router = APIRouter()


@router.get("/")
async def list_clients() -> dict[str, str]:
    return {"message": "clients endpoint placeholder"}


@router.get("/{client_id}")
async def get_client(client_id: str) -> dict[str, str]:
    return {"message": f"client {client_id} placeholder"}
