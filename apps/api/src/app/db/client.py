from supabase import Client, create_client

from app.config import settings


def create_supabase_client() -> Client:
    return create_client(settings.supabase_url, settings.supabase_key)
