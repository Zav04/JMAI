from pydantic import BaseModel
from typing import Optional

class Agendamento(BaseModel):
    hashed_id: str
    data: str