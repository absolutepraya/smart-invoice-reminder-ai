from fastapi import APIRouter

router = APIRouter()


@router.get("/")
async def list_clients() -> dict[str, str]:
    """List all clients with current risk category."""
    return {"message": "clients endpoint placeholder"}


@router.get("/{client_id}")
async def get_client(client_id: str) -> dict[str, str]:
    """Get a single client by ID."""
    return {"message": f"client {client_id} placeholder"}
