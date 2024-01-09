from pydantic import BaseModel
from typing import Optional

class SendEmail_Agendamento(BaseModel):
    email: str
    agendamento: str