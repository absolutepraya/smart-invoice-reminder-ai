from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config import settings
from app.routers import auth, clients, invoices, reminders, risk

app = FastAPI(
    title="Smart Invoice Reminder AI",
    version="0.1.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/api/auth", tags=["auth"])
app.include_router(invoices.router, prefix="/api/invoices", tags=["invoices"])
app.include_router(clients.router, prefix="/api/clients", tags=["clients"])
app.include_router(reminders.router, prefix="/api/reminders", tags=["reminders"])
app.include_router(risk.router, prefix="/api/risk", tags=["risk"])


@app.get("/api/health")
async def health_check() -> dict[str, str]:
    return {"status": "ok"}
