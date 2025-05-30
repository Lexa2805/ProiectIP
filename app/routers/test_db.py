# app/routers/test_db.py
from fastapi import APIRouter, Depends
from app.db import get_db

router = APIRouter()

@router.get("/test-db")
def test_db_connection(db=Depends(get_db)):
    return {"status": "connected"}
