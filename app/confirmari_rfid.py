from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from app.db import get_db
from app.models import ConfirmarePreluare
from app.schemas import ConfirmareRfidCreate
from app.models import ConfirmarePreluareRfid
router = APIRouter()

@router.get("/api/confirmari_rfid/ultimul", tags=["asistente"])
def ultimul_tag(db: Session = Depends(get_db)):
    ultima_confirmare = (
        db.query(ConfirmarePreluare)
        .order_by(ConfirmarePreluare.timestamp.desc())
        .first()
    )
    if ultima_confirmare:
        return {
            "rfid": ultima_confirmare.rfid_medicament,
            "timestamp": str(ultima_confirmare.timestamp)
        }
    raise HTTPException(status_code=404, detail="Nicio confirmare RFID găsită")

@router.post("/api/confirmari_rfid", tags=["asistente"])
def primeste_confirmare_rfid(data: ConfirmareRfidCreate, db: Session = Depends(get_db)):
    confirmare = ConfirmarePreluareRfid(**data.dict())
    db.add(confirmare)
    db.commit()
    db.refresh(confirmare)
    print(f"[CONFIRMARE RFID] {data.rfid_medicament} la {data.timestamp}")
    return {"status": "Confirmare înregistrată"}
