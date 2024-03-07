"""Defines the router for the root path (/)."""
from fastapi import APIRouter


ROUTER = APIRouter()


@ROUTER.get("/")
async def root():
    """Handles the root endpoint, providing information about the API."""

    version = "0.0.0"
    return {
        "Name": "Docker test",
        "Info": "API RESTful with FastAPI and Python 3.11",
        "Version": version,
        "Company": "Lexdrel",
        "Repository": "https://github.com/dvlex/practice-docker-volume",
        "Endpoints": {
            "root":[
                {"method": "GET", "path": "/"}
            ]
        }
    }
