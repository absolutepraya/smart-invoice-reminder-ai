from app.workers.celery_app import celery_app


@celery_app.task  # type: ignore[untyped-decorator]
def send_reminder(invoice_id: str, risk_level: str) -> None:
    """Generate and send a reminder for a specific invoice."""
    # 1. Fetch invoice + client details
    # 2. Generate reminder message based on risk level
    # 3. Send via email (or other channel)
    # 4. Log the reminder in the database
    pass
