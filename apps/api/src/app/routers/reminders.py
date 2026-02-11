from fastapi import APIRouter

router = APIRouter()


@router.get("/")
async def list_reminders() -> dict[str, str]:
    return {"message": "reminders endpoint placeholder"}
