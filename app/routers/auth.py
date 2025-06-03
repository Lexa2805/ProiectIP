from fastapi import APIRouter, HTTPException, Depends
from sqlalchemy.orm import Session
from app.db import get_db
from app.models import Utilizator
from pydantic import BaseModel
from app.auth_utils import verifica_parola

router = APIRouter(prefix="/auth", tags=["auth"])

class LoginRequest(BaseModel):
    email: str
    password: str

@router.post("/login")
def login(data: LoginRequest, db: Session = Depends(get_db)):
    user = db.query(Utilizator).filter(Utilizator.email == data.email).first()

    if not user or not verifica_parola(data.password, user.parola):
        raise HTTPException(status_code=401, detail="Email sau parolă incorecte")

    return {"message": f" {user.nume} {user.prenume}", "rol": user.rol}

