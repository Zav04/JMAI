from pydantic import BaseModel
from typing import Optional, List

class RequerimentoRequest(BaseModel):
    hashed_id: str
    documentos: List[str]
    observacoes: str
    type: int
    nunca_submetido : Optional[bool] = False
    submetido : Optional[bool] = False
    data_submissao : Optional[str] = ''

