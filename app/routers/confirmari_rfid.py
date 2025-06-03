from app.models import ConfirmarePreluare
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime
from app.db import get_db
from app.models import ConfirmarePreluareRfid
from app.schemas import ConfirmareRfidCreate

router = APIRouter()

@router.post("/api/confirmari_rfid", tags=["robot"])
def primeste_confirmare_rfid(data: ConfirmareRfidCreate, db: Session = Depends(get_db)):
    """Primește un RFID de la robot și îl salvează în baza de date."""
    try:
        confirmare = ConfirmarePreluareRfid(
            rfid_medicament=data.rfid_medicament,
            timestamp=datetime.utcnow()
        )
        db.add(confirmare)
        db.commit()
        db.refresh(confirmare)
        return {"status": "Confirmare înregistrată"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Eroare la salvare în DB: {str(e)}")
        
@router.get("/api/confirmari_rfid/ultimul", tags=["robot"])
def ultimul_tag(db: Session = Depends(get_db)):
    ultima_confirmare = (
        db.query(ConfirmarePreluareRfid)
        .order_by(ConfirmarePreluareRfid.timestamp.desc())
        .first()
    )
    if ultima_confirmare:
        return {
            "rfid": ultima_confirmare.rfid_medicament,
            "timestamp": str(ultima_confirmare.timestamp)
        }
    raise HTTPException(status_code=404, detail="Nicio confirmare RFID găsită")

