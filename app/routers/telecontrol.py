from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.models import RaportTransport
from app.schemas import AlarmaCreate
from app.db import get_db
from app.models import Alarme

router = APIRouter()

@router.post("/robot/raport", tags=["robot"])
def salveaza_raport(actiune: str, detalii: str, db: Session = Depends(get_db)):
    raport = RaportTransport(actiune=actiune, detalii=detalii)
    db.add(raport)
    db.commit()
    db.refresh(raport)
    return {"status": "salvat", "id": raport.id}

@router.post("/api/alarme", tags=["telecontrol"])
def primeste_alarma(data: AlarmaCreate, db: Session = Depends(get_db)):
    alarma = Alarme(**data.dict())
    db.add(alarma)
    db.commit()
    db.refresh(alarma)
    return {"status": "Alarma înregistrată"}

@router.get("/api/alarme", tags=["telecontrol"])
def vezi_alarmele(db: Session = Depends(get_db)):
    return db.query(Alarme).order_by(Alarme.data_ora.desc()).all()

