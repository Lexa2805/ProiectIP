from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.models import RaportTransport
from app.db import get_db

router = APIRouter()

@router.post("/robot/raport", tags=["robot"])
def salveaza_raport(actiune: str, detalii: str, db: Session = Depends(get_db)):
    raport = RaportTransport(actiune=actiune, detalii=detalii)
    db.add(raport)
    db.commit()
    db.refresh(raport)
    return {"status": "salvat", "id": raport.id}
