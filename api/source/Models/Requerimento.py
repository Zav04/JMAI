from pydantic import BaseModel
from typing import Optional, List

class RequerimentoRequest(BaseModel):
    hashed_id: str
    documentos: List[str]
    observacoes: str
    type: int

