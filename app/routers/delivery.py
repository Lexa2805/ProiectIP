from fastapi import APIRouter, HTTPException
from app.models import DeliveryConfirm
from app.db import get_db

router = APIRouter(prefix="/delivery")

@router.post("/confirm")
def confirm_delivery(payload: DeliveryConfirm):
    db = get_db()
    cursor = db.cursor()
    cursor.execute(
        "UPDATE comenzi_robot SET stare = 'FINALIZAT' WHERE comanda_id = %s",
        (payload.command_id,)
    )
    if cursor.rowcount == 0:
        raise HTTPException(status_code=404, detail="Command not found")
    return {"status": "ok", "command_id": payload.command_id}
