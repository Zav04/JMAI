from pydantic import BaseModel
from typing import Optional

class USF(BaseModel):
    data_avaliacao: str
    email : str
    numero_utente : str
    password : str
    terms: str
    tipo_requerimento: str
    tipo_submissao: str
