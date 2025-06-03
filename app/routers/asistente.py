from fastapi import APIRouter, Depends,HTTPException
from sqlalchemy.orm import Session
from sqlalchemy import select
from typing import List
from app.db import get_db
from app.models import Pacient, Prescriptie, Medicament, PrescriptieMedicament,RaportTransport,ConfirmarePreluare,ConfirmarePreluareRfid
from app.schemas import MedicamentPrescrisOut,RaportTransportOut,ConfirmarePreluareCreate
from app.schemas import ConfirmareRfidCreate
from app.models import ConfirmarePreluareRfid

router = APIRouter(
    prefix="/asistente",
    tags=["asistente"]
)

@router.get("/saloane", response_model=List[int])
def get_saloane(db: Session = Depends(get_db)):
    # Interoghează distinct saloanele din tabelul pacienti
    saloane = db.query(Pacient.salon).distinct().all()
    # Rezultatul este o listă de tuple, extragem doar valorile
    return [s[0] for s in saloane]

@router.get("/salon/{id_salon}/pacienti")
def get_pacienti_din_salon(id_salon: int, db: Session = Depends(get_db)):
    pacienti = db.query(Pacient).filter(Pacient.salon == id_salon).all()
    if not pacienti:
        raise HTTPException(status_code=404, detail="Niciun pacient găsit în acest salon")
    return pacienti

@router.get("/pacient/{id_pacient}/medicamente", response_model=List[MedicamentPrescrisOut], tags=["asistente"])
def get_medicamente_pacient(id_pacient: int, db: Session = Depends(get_db)):
    prescriptii = select(Prescriptie.ID_prescriptie).where(Prescriptie.ID_pacient == id_pacient).subquery()

    rezultate = (
        db.query(
            Medicament.denumire,
            Medicament.descriere,
            PrescriptieMedicament.doza,
            PrescriptieMedicament.frecventa
        )
        .join(PrescriptieMedicament, Medicament.ID_medicament == PrescriptieMedicament.ID_medicament)
        .filter(PrescriptieMedicament.ID_prescriptie.in_(prescriptii))
        .all()
    )

    if not rezultate:
        raise HTTPException(status_code=404, detail="Niciun medicament găsit pentru acest pacient")

    return rezultate


