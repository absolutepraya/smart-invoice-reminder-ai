import httpx

from app.config import settings


class NL2SQLService:
    def __init__(self) -> None:
        self.base_url = settings.nl2sql_api_url

    async def query(self, natural_language: str) -> str:
        """Convert natural language to SQL via external inference server."""
        async with httpx.AsyncClient() as client:
            response = await client.post(
                f"{self.base_url}/generate",
                json={"prompt": natural_language},
                timeout=30.0,
            )
            response.raise_for_status()
            return response.json()["sql"]
