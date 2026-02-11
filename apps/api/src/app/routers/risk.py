from fastapi import APIRouter

router = APIRouter()


@router.get("/summary")
async def get_risk_summary() -> dict[str, str]:
    return {"message": "risk summary endpoint placeholder"}
