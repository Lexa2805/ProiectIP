# deps.py

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from pydantic import BaseModel

# Configurări
SECRET_KEY = "mysecret"  # ideal din .env
ALGORITHM = "HS256"

# Ruta tokenului
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")  # trebuie să corespundă cu ruta de autentificare

# Model pentru datele din token
class TokenData(BaseModel):
    username: str | None = None

# Funcție utilitară pentru decodare
def verify_token(token: str, credentials_exception):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
        return TokenData(username=username)
    except JWTError:
        raise credentials_exception

# Funcția principală care se folosește cu Depends
def get_current_active_user(token: str = Depends(oauth2_scheme)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

    token_data = verify_token(token, credentials_exception)
    return {"username": token_data.username}
