from sqlalchemy.orm import Session
from jose import JWTError, jwt
from fastapi import Depends, HTTPException, status  # ← aceste importuri lipsesc
from fastapi.security import OAuth2PasswordBearer

from app.db import get_db
from app.models import Utilizator

SECRET_KEY = "secretul_tău_lung_și_sigur"
ALGORITHM = "HS256"
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")


def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Token invalid sau lipsă",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception

    user = db.query(Utilizator).filter(Utilizator.username == username).first()
    if user is None:
        raise credentials_exception
    return user


def get_current_active_user(current_user: Utilizator = Depends(get_current_user)):
    return current_user
