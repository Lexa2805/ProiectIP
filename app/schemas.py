# schemas.py
from pydantic import BaseModel, EmailStr,validator
from typing import List, Optional
from datetime import datetime

class LoginRequest(BaseModel):
    email: str
    password: str

class LoginResponse(BaseModel):
    access_token: str
class UtilizatorOut(BaseModel):
    id: int
    nume: str
    email: str
    rol: str
    
    class Config:
        orm_mode = True

class MedicamentBase(BaseModel):
    ID_medicament: int
    denumire: str
    descriere: Optional[str]
    RFID: Optional[str]
    stoc_curent: int

    class Config:
        orm_mode = True

class PrescriptieMedicamentBase(BaseModel):
    ID_medicament: int
    doza: str
    frecventa: str
    medicament: Optional[MedicamentBase]

    class Config:
        orm_mode = True

class PrescriptieOut(BaseModel):
    ID_prescriptie: int
    ID_pacient: int
    ID_medic: int
    data_prescriptiei: datetime
    medicamente: List[PrescriptieMedicamentBase] 

class Config:
        orm_mode = True

class MedicamentPrescrisOut(BaseModel):
    denumire: str
    descriere: Optional[str]
    doza: str
    frecventa: str

    class Config:
        orm_mode = True

class RaportTransportOut(BaseModel):
    id: int
    timestamp: datetime
    actiune: str
    detalii: str
 

    class Config:
        orm_mode = True

class ConfirmarePreluareCreate(BaseModel):
    ID_pacient: int
    nume_asistenta: str
    timestamp: datetime

    class Config:
        orm_mode = True

class ConfirmareRfidCreate(BaseModel):
    rfid_medicament: str

    class Config:
        orm_mode = True

class AlarmaCreate(BaseModel):
    tip_alarma: str
    descriere: str
    data_ora: datetime
    ID_comanda: int
    status: str

    class Config:
        orm_mode = True


class TeleghidareRequest(BaseModel):
    status: str 

    class Config:
        orm_mode = True

