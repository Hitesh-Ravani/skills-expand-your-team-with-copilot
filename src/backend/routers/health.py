"""
Health check endpoint for the High School Management System API
"""

from fastapi import APIRouter
from fastapi.responses import JSONResponse

from ..database import client

router = APIRouter(
    prefix="/health",
    tags=["health"]
)

@router.get("")
@router.get("/")
def health_check():
    """Returns the health status of the API and database connection"""
    try:
        client.admin.command('ping')
        db_status = "ok"
    except Exception:
        return JSONResponse(
            status_code=503,
            content={"status": "degraded", "database": "unreachable"}
        )

    return {"status": "ok", "database": db_status}
