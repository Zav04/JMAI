from pydantic import BaseModel, EmailStr
from typing import Optional

class MedicoRequest(BaseModel):
    nome_completo: Optional[str] = ''
    data_nascimento: Optional[str] = ''
    numero_telemovel: Optional[str] = ''
    sexo: Optional[str] = ''
    pais: Optional[str] = ''
    distrito: Optional[str] = ''
    concelho: Optional[str] = ''
    freguesia: Optional[str] = ''
    especialidade: Optional[str] = ''
    num_cedula: Optional[str] = ''
    num_ordem: Optional[str] = ''
    email: Optional[str] = ''
    password: Optional[str] = ''
    justvalidate_inputs: bool

    def dict(self, **kwargs):
        d = super().dict(**kwargs)
        for k, v in d.items():
            if v is None:
                d[k] = ''
        return d
