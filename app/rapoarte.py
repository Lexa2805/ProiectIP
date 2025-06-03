from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from datetime import datetime

from app.db import get_db
from app.models import RaportTransport
from app.schemas import RaportTransportOut

router = APIRouter()

@router.get("/rapoarte", response_model=List[RaportTransportOut], tags=["robot"])
def get_rapoarte_robot(db: Session = Depends(get_db)):
    try:
        rapoarte = db.query(RaportTransport).order_by(RaportTransport.timestamp.desc()).all()
        return rapoarte
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Eroare la interogarea bazei de date: {str(e)}")
