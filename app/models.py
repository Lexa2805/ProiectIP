from pydantic import BaseModel
from typing import Optional
from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from app.db import Base
from datetime import datetime

#Base = declarative_base() 

class Utilizator(Base):
    __tablename__ = "utilizatori"

    ID_utilizator = Column(Integer, primary_key=True, index=True)
    nume = Column(String)
    prenume = Column(String)
    rol = Column(String)
    username = Column(String)
    parola = Column(String)
    email = Column(String)
    status = Column(String)


class Pacient(Base):
    __tablename__ = 'pacienti'

    ID_pacient = Column(Integer, primary_key=True, index=True)
    nume = Column(String)
    prenume = Column(String)
    CNP = Column(String(13))
    adresa = Column(String)
    telefon = Column(String)
    salon = Column(Integer)
    pat = Column(Integer)

    prescriptii = relationship("Prescriptie", back_populates="pacient")


class Prescriptie(Base):
    __tablename__ = 'prescriptii'

    ID_prescriptie = Column(Integer, primary_key=True, index=True)
    ID_pacient = Column(Integer, ForeignKey('pacienti.ID_pacient'))
    ID_medic = Column(Integer, ForeignKey('utilizatori.ID_utilizator'))
    data_prescriptiei = Column(String)

    medicamente = relationship("PrescriptieMedicament", back_populates="prescriptie")
    pacient = relationship("Pacient", back_populates="prescriptii") 


class PrescriptieMedicament(Base):
    __tablename__ = 'prescriptii_medicamente'

    ID_prescriptie = Column(Integer, ForeignKey('prescriptii.ID_prescriptie'), primary_key=True)
    ID_medicament = Column(Integer, ForeignKey('medicamente.ID_medicament'), primary_key=True)
    doza = Column(String)
    frecventa = Column(String)

    prescriptie = relationship("Prescriptie", back_populates="medicamente")
    medicament = relationship("Medicament", back_populates="prescriptii")

class Medicament(Base):
    __tablename__ = 'medicamente'

    ID_medicament = Column(Integer, primary_key=True, index=True)
    denumire = Column(String)
    descriere = Column(String)
    RFID = Column(String)
    stoc_curent = Column(Integer)

    prescriptii = relationship("PrescriptieMedicament", back_populates="medicament")

class RaportTransport(Base):
    __tablename__ = "rapoarte_transport"

    id = Column(Integer, primary_key=True, index=True)
    timestamp = Column(DateTime, default=datetime.utcnow)
    actiune = Column(String, nullable=False)
    detalii = Column(String, nullable=True)

class ConfirmarePreluare(Base):
    __tablename__ = "confirmari_preluare"

    id = Column(Integer, primary_key=True, index=True)
    ID_pacient = Column(Integer, nullable=False)
    nume_asistenta = Column(String)
    timestamp = Column(DateTime)

class ConfirmarePreluareRfid(Base):
    __tablename__ = "confirmari_rfid" 

    id = Column(Integer, primary_key=True, index=True)
    rfid_medicament = Column(String)
    timestamp = Column(DateTime)


class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    username: Optional[str] = None

class User(BaseModel):
    username: str
    role: str

class UserInDB(User):
    hashed_password: str


class LoginRequest(BaseModel):
    username: str
    password: str

class LoginResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"


class DeliveryConfirm(BaseModel):
    id: int
    received_by: str
    timestamp: str  



__all__ = [
    "Pacient",
    "Prescriptie",
    "PrescriptieMedicament",
    "Medicament", 
    "Utilizator",
    "ConfirmarePreluare",
    "RaportTransport"
]

