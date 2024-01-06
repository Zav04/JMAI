from pydantic import BaseModel
from typing import Optional

class UtenteRequest(BaseModel):
    hashed_id: Optional[str] = ''
    numero_utente_saude: Optional[str] = ''
    email: Optional[str] = ''
    password: Optional[str] = '' 
    justvalidate_inputs: bool
    
    def dict(self, **kwargs):
        d = super().dict(**kwargs)
        for k, v in d.items():
            if v is None:
                d[k] = ''  # Converte None para string vazia
        return d