from app.workers.celery_app import celery_app


@celery_app.task  # type: ignore[untyped-decorator]
def send_reminder(invoice_id: str, risk_level: str, channel: str = "EMAIL") -> None:
    """Generate and send a reminder for a specific invoice.

    Steps:
    1. Fetch invoice + client details from DB
    2. Determine message_type from risk_level (LOW->SOPAN, MEDIUM->TEGAS, HIGH->PERINGATAN)
    3. Generate message content
    4. Send via channel (EMAIL/WHATSAPP/SMS)
    5. Log to reminder_logs table with delivery_status
    """
    pass
