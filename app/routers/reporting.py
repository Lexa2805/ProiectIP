from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db import get_db
from app.models import RaportTransport
from pydantic import BaseModel
from datetime import datetime

router = APIRouter()

class RaportIn(BaseModel):
    actiune: str
    detalii: str | None = None

@router.post("/raport", tags=["rapoarte"])
def adauga_raport(raport: RaportIn, db: Session = Depends(get_db)):
    raport_nou = RaportTransport(
        actiune=raport.actiune,
        detalii=raport.detalii
    )
    db.add(raport_nou)
    db.commit()
    db.refresh(raport_nou)
    return {"message": "Raport salvat", "id": raport_nou.id}

@router.get("/robot/rapoarte", tags=["robot"])
def get_rapoarte(db: Session = Depends(get_db)):
    return db.query(RaportTransport).order_by(RaportTransport.timestamp.desc()).all()