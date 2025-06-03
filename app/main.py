from fastapi import FastAPI, Depends,HTTPException
from fastapi.middleware.cors import CORSMiddleware
from app.routers import (
    auth, delivery, telecontrol, items, test_db,
    utilizatori, asistente
)
from app.deps import get_current_active_user  
from app.routers import robot_control
from app.rapoarte import router as rapoarte_router
from app.routers import confirmari_rfid
import logging

app = FastAPI(title="MediGo API")

logging.basicConfig(level=logging.DEBUG)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(telecontrol.router) 
app.include_router(items.router)
app.include_router(robot_control.router)
app.include_router(delivery.router, dependencies=[Depends(get_current_active_user)])
app.include_router(utilizatori.router)
app.include_router(asistente.router)
app.include_router(rapoarte_router)
app.include_router(confirmari_rfid.router)
__all__ = ["router"]


