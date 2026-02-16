from fastapi import APIRouter

router = APIRouter()


@router.get("/summary")
async def get_risk_summary() -> dict[str, str]:
    """Get risk summary: client counts by level + total overdue amount."""
    return {"message": "risk summary endpoint placeholder"}
