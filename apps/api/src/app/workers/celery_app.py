from celery import Celery  # type: ignore[import-untyped]
from celery.schedules import crontab  # type: ignore[import-untyped]

from app.config import settings

celery_app = Celery(
    "smart_invoice",
    broker=settings.redis_url,
    backend=settings.redis_url,
)

celery_app.conf.beat_schedule = {
    "check-overdue-invoices-daily": {
        "task": "app.workers.check_overdue.check_overdue_invoices",
        "schedule": crontab(hour=8, minute=0),  # Every day at 8 AM
    },
}

celery_app.conf.timezone = "Asia/Jakarta"
