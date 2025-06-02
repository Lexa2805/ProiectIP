from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from app.routers import (
    auth, delivery, telecontrol, items, test_db,
    utilizatori, asistente, reporting
)
from app.deps import get_current_active_user  
from app.routers import robot_control

import logging
app = FastAPI(title="MediGo API")
logging.basicConfig(level=logging.DEBUG)
# CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)
@app.get("/secure-data")
def secure_data(user: dict = Depends(get_current_active_user)):
    return {"message": f"Bun venit, {user['username']}!"}
@app.get("/")
def read_root():
    return {"message": "Bine ai venit la MediGo API"}


# @app.get("/test-db")
# def test_db_connection(db=Depends(get_db)):
#     return {"status": "connected"}

# Rute fără autentificare
app.include_router(auth.router)
app.include_router(telecontrol.router)  # ← activat corect
app.include_router(items.router)
app.include_router(robot_control.router)
# Rute cu autentificare
app.include_router(delivery.router, dependencies=[Depends(get_current_active_user)])
app.include_router(utilizatori.router)
app.include_router(asistente.router)
app.include_router(reporting.router)





