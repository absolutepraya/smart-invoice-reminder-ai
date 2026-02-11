from app.workers.celery_app import celery_app


@celery_app.task  # type: ignore[untyped-decorator]
def check_overdue_invoices() -> None:
    """Scan for overdue invoices and dispatch reminder tasks."""
    # 1. Query overdue invoices from Supabase
    # 2. Calculate risk level for each
    # 3. Dispatch send_reminder task for each invoice
    pass
