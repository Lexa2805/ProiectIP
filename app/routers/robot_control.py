from fastapi import APIRouter, HTTPException
import requests
from datetime import datetime
from app.models import RaportTransport
from sqlalchemy.orm import Session
from app.db import get_db
from fastapi import Depends
from app.schemas import RaportTransportOut
from typing import List

router = APIRouter()

ROBOT_IP = "http://192.168.100.111"  # IP-ul ESP8266, actualizează-l la nevoie

@router.get("/robot/{comanda}", tags=["robot"])
def trimite_comanda_robot(comanda: str, db: Session = Depends(get_db)):
    comenzi_valide = ["Fata", "Spate", "Stanga", "Dreapta", "Stop"]

    if comanda not in comenzi_valide:
        raise HTTPException(status_code=400, detail="Comandă invalidă")

    try:
        response = requests.get(f"{ROBOT_IP}/{comanda}", timeout=3)

        # Salvare raport în tabel
        # raport = RaportTransport(
        #     timestamp=datetime.now(),
        #     actiune="Trimitere comanda robot",
        #     detalii=f"Comanda: {comanda}"
        # )
                # Salvare raport în baza de date
        raport = RaportTransport(
            timestamp=datetime.utcnow(),
            actiune=f"Comanda {comanda}",
            detalii=f"Comandă trimisă către robot, răspuns: {response.text}"
        )
        db.add(raport)
        db.commit()

        return {"status": "trimis", "raspuns_robot": response.text}

    except requests.RequestException as e:
        raise HTTPException(status_code=500, detail=f"Robotul nu a răspuns: {str(e)}")
    
@router.post("/robot/comanda", tags=["robot"])
def comanda_transport(data: dict):
    try:
        response = requests.post(f"{ROBOT_IP}/comanda", json=data, timeout=3)
        return {"status": "trimis", "raspuns_robot": response.json()}
    except requests.RequestException as e:
        raise HTTPException(status_code=500, detail=f"Robotul nu a răspuns: {str(e)}")

def salveaza_raport(db: Session, actiune: str, detalii: str):
    raport = RaportTransport(
        timestamp=datetime.now(),
        actiune=actiune,
        detalii=detalii
    )
    db.add(raport)
    db.commit()
    db.refresh(raport)
    return raport

@router.get("/rapoarte", response_model=List[RaportTransportOut], tags=["rapoarte"])
def get_rapoarte(db: Session = Depends(get_db)):
    return db.query(RaportTransport).order_by(RaportTransport.timestamp.desc()).all()

def salveaza_raport(db: Session, actiune: str, detalii: str = ""):
    raport = RaportTransport(
        timestamp=datetime.now(),
        actiune=actiune,
        detalii=detalii
    )
    db.add(raport)
    db.commit()
    
__all__ = ["router"]

