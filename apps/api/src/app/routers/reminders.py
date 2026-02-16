from fastapi import APIRouter

router = APIRouter()


@router.get("/")
async def list_reminders() -> dict[str, str]:
    """List all reminder logs with delivery status."""
    return {"message": "reminders endpoint placeholder"}
