"""Main module FastAPI.
Lithia Converter 1.0"""


from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.endpoints.root import ROUTER as router_root


app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(router_root)

if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="127.0.0.1", port=8000)
