from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from app.routers import auth, delivery, telecontrol, items, test_db
from app.routers import utilizatori
from app.deps import get_current_active_user  # adaugă asta dacă lipsește
from app.routers import asistente
from app.routers.robot_control import router
from app.routers import reporting

app = FastAPI(title="MediGo API")

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
#cod temporar
from fastapi import FastAPI, Depends
from app.db import get_db  # asigură-te că această funcție este corect importată

app = FastAPI(title="MediGo API")

@app.get("/test-db")
def test_db_connection(db=Depends(get_db)):
    return {"status": "connected"}

# Include routers
app.include_router(auth.router)
app.include_router(delivery.router, dependencies=[Depends(get_current_active_user)])
app.include_router(telecontrol.router, dependencies=[Depends(get_current_active_user)])
app.include_router(items.router)  
app.include_router(utilizatori.router)
app.include_router(asistente.router)
app.include_router(router)
app.include_router(reporting.router)




