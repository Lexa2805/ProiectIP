from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from sqlalchemy.orm import Session
from app.db import get_db
from app.models import Utilizator  # asigură-te că modelul e corect importat

router = APIRouter(prefix="/auth", tags=["auth"])

class LoginRequest(BaseModel):
    email: str
    password: str

@router.post("/login")
def login(request: LoginRequest, db: Session = Depends(get_db)):
    user = db.query(Utilizator).filter(Utilizator.email == request.email).first()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    if user.parola != request.password:
        raise HTTPException(status_code=401, detail="Invalid password")

    return {"message": f"Bine ai venit, {user.username}!"}
