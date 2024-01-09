from pydantic import BaseModel
from typing import Optional

class SendEmail_Recusado(BaseModel):
    email: str
    observacoes: str