from pydantic import BaseModel
from typing import Optional

class SecretarioClinicoRequest(BaseModel):
    nome_completo: Optional[str] = ''
    data_nascimento: Optional[str] = ''
    numero_telemovel: Optional[str] = ''
    sexo: Optional[str] = ''
    pais_nacionalidade: Optional[str] = ''
    distrito: Optional[str] = ''
    concelho: Optional[str] = ''
    freguesia: Optional[str] = ''
    email: Optional[str] = ''
    password: Optional[str] = ''
    justvalidate_input: bool

    def dict(self, **kwargs):
        d = super().dict(**kwargs)
        for k, v in d.items():
            if v is None:
                d[k] = ''
        return d
