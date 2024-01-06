from pydantic import BaseModel
from typing import Optional

class SendEmailPreAvaliacao(BaseModel):
    email: str
    preavalicao :float