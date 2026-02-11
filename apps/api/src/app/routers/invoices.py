from fastapi import APIRouter

router = APIRouter()


@router.get("/")
async def list_invoices() -> dict[str, str]:
    return {"message": "invoices endpoint placeholder"}


@router.get("/overdue")
async def list_overdue_invoices() -> dict[str, str]:
    return {"message": "overdue invoices endpoint placeholder"}


@router.get("/{invoice_id}")
async def get_invoice(invoice_id: str) -> dict[str, str]:
    return {"message": f"invoice {invoice_id} placeholder"}
