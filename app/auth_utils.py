from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verifica_parola(parola_clara: str, parola_hash: str) -> bool:
    return pwd_context.verify(parola_clara, parola_hash)

def hash_parola(parola: str) -> str:
    return pwd_context.hash(parola)
