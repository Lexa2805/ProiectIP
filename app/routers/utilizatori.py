from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db import get_db
from app.models import Utilizator
from app.schemas import UtilizatorOut

router = APIRouter(prefix="/utilizatori", tags=["utilizatori"])

@router.get("/", response_model=list[UtilizatorOut])
def get_utilizatori(db: Session = Depends(get_db)):
    utilizatori = db.query(Utilizator).all()
    return utilizatori

print("🔧 Ruta utilizatori a fost încărcată")

