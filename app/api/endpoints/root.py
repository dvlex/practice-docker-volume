"""Defines the router for the root path (/)."""
from fastapi import APIRouter
import os
import uuid
from datetime import datetime


ROUTER = APIRouter()


@ROUTER.get("/")
async def root():
    """Handles the root endpoint, providing information about the API."""

    if not os.path.exists("assets"):
        os.makedirs("assets")

    file_name = f"assets/current{uuid.uuid4()}.py"
    with open(file_name, "w", encoding="utf-8") as file:
        file.write(f"# Created at: {datetime.now()}\n")

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
