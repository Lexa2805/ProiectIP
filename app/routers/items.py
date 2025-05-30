from fastapi import Depends, APIRouter
from app.deps import get_current_active_user
from app.models import User

router = APIRouter(prefix="/items", tags=["items"])

@router.get("/", response_model=list[dict])
def read_items(current_user: User = Depends(get_current_active_user)):
    return [{"item_id": "foo", "owner": current_user.username}]
