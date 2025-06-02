from fastapi import APIRouter, HTTPException
import requests
from datetime import datetime
from app.models import RaportTransport
from sqlalchemy.orm import Session
from app.db import get_db
from fastapi import Depends
from app.schemas import RaportTransportOut
from typing import List
from app.schemas import TeleghidareRequest
router = APIRouter()

ROBOT_IP = "10.100.0.48"  # IP-ul ESP8266, actualizează-l la nevoie

@router.get("/robot/{comanda}", tags=["robot"])
def trimite_comanda_robot(comanda: str, db: Session = Depends(get_db), utilizator: str = "Necunoscut"):
    """
    Trimite o comandă către robot și salvează un raport cu utilizatorul care a teleghidat.
    """
    comenzi_valide = ["fata", "spate", "stanga", "dreapta", "stop"]
    comanda = comanda.lower()

    if comanda not in comenzi_valide:
        raise HTTPException(status_code=400, detail="Comandă invalidă")

    try:
        # Trimite comanda robotului
        r = requests.get(f"http://{ROBOT_IP}/{comanda}", timeout=3)

        # Salvează în rapoarte_transport
        raport = RaportTransport(
            actiune="teleghidare",
            detalii=f"comandă trimisă: {comanda}",
            nume_utilizator=utilizator  # Poți modifica să fie extras din JWT sau cerere
        )
        db.add(raport)
        db.commit()

        return {"status": "Comandă trimisă", "raspuns": r.text}

    except requests.exceptions.RequestException:
        raise HTTPException(status_code=500, detail="Robotul nu a răspuns")
    
# @router.post("/robot/comanda", tags=["robot"])
# def comanda_transport(data: dict):
#     try:
#         response = requests.post(f"{ROBOT_IP}/comanda", json=data, timeout=3)
#         return {"status": "trimis", "raspuns_robot": response.json()}
#     except requests.RequestException as e:
#         raise HTTPException(status_code=500, detail=f"Robotul nu a răspuns: {str(e)}")

def salveaza_raport(
    db: Session,
    actiune: str,
    username: str,
    status: str
):
    raport = RaportTransport(
        timestamp=datetime.now(),
        actiune=actiune,
        detalii=f"{username} a trimis comanda {status}",
        utilizator=username
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

# @router.post("/rc")
# def seteaza_rc(status: str):
#     if status not in ["rc-on", "rc-off"]:
#         raise HTTPException(status_code=400, detail="Status invalid. Folosește 'rc-on' sau 'rc-off'.")

#     try:
#         url = f"http://{ROBOT_IP}/{status}"
#         raspuns = requests.get(url)
#         return {"status": "trimis", "comanda": status, "raspuns_robot": raspuns.text}
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Eroare comunicare cu robotul: {str(e)}")

@router.post("/rc")
def seteaza_rc(request: TeleghidareRequest, db: Session = Depends(get_db)):
    if request.status not in ["rc-on", "rc-off"]:
        raise HTTPException(status_code=400, detail="Status invalid. Folosește 'rc-on' sau 'rc-off'.")

    # 1. Trimite comanda la robot
    try:
        url = f"http://{ROBOT_IP}/{request.status}"
        raspuns = requests.get(url)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Eroare la trimitere către robot: {str(e)}")

    # 2. Salvează în DB
    raport = RaportTransport(
        actiune="teleghidare",
        detalii=f"{request.username} a trimis comanda {request.status}",
        timestamp=datetime.utcnow()
    )
    db.add(raport)
    db.commit()
    db.refresh(raport)

    return {
        "status": "comanda trimisă",
        "comanda": request.status,
        "trimis_de": request.username,
        "raspuns_robot": raspuns.text
    }