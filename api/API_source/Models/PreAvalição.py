from pydantic import BaseModel
from typing import Optional

class PreAvaliacao(BaseModel):
    hashed_id_requerimento: str
    hashed_id_medico:str 
    pre_avaliacao: float
    observacoes: str