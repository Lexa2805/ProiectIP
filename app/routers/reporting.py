from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db import get_db
from app.models import RaportTransport
from app.schemas import RaportTransportOut
from pydantic import BaseModel
from datetime import datetime
from app.deps import get_current_active_user
from typing import List
router = APIRouter()

class RaportIn(BaseModel):
    actiune: str
    detalii: str | None = None

# @router.get("/robot/rapoarte", response_model=List[RaportTransportOut], tags=["robot"])
# def get_rapoarte_robot(db: Session = Depends(get_db)):
#     return db.query(RaportTransport).order_by(RaportTransport.timestamp.desc()).all()
