from pydantic import BaseModel
from typing import Optional

class UtenteRequest(BaseModel):
    nome_completo: Optional[str] = ''
    data_nascimento: Optional[str] = ''
    numero_telemovel: Optional[str] = ''
    sexo: Optional[str] = ''
    pais_naturalidade: Optional[str] = ''
    pais_nacionalidade: Optional[str] = ''
    tipo_documento_identificacao: Optional[str] = ''
    documento_validade: Optional[str] = ''
    numero_identificacao_fiscal: Optional[str] = ''
    numero_documento_identificacao: Optional[str] = ''
    numero_seguranca_social: Optional[str] = ''
    numero_utente_saude: Optional[str] = ''
    morada: Optional[str] = ''
    nr_porta: Optional[str] = ''
    nr_andar: Optional[str] = ''
    codigo_postal: Optional[str] = ''
    distrito: Optional[str] = ''
    concelho: Optional[str] = ''
    freguesia: Optional[str] = ''
    id_entidade_responsavel: Optional[str] = ''    
    email: Optional[str] = ''
    password: Optional[str] = '' 
    justvalidate_inputs: bool
    
    def dict(self, **kwargs):
        d = super().dict(**kwargs)
        for k, v in d.items():
            if v is None:
                d[k] = ''  # Converte None para string vazia
        return d