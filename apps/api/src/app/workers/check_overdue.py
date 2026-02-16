from app.workers.celery_app import celery_app


@celery_app.task  # type: ignore[untyped-decorator]
def check_overdue_invoices() -> None:
    """Scan for overdue invoices and dispatch reminder tasks.

    Steps:
    1. Query invoices table where status = 'OVERDUE'
    2. For each overdue invoice, check reminder_logs for same-day duplicate
    3. Use client's current_risk_category (or re-evaluate via ML)
    4. Dispatch send_reminder task for each eligible invoice
    """
    pass
