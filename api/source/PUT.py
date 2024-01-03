from sqlalchemy.sql import text
from fastapi import APIRouter, Depends
from database import SessionLocal
from dependencies import get_db
from Models.Utente import UtenteRequest
from sqlalchemy.exc import SQLAlchemyError
from Models.UserSignup import UserSignup
from Models.Search import Search
from Models.SecretarioClinico import SecretarioClinicoRequest
from Models.Medico import MedicoRequest


put_router = APIRouter()

@put_router.put("/validation_edit_user/")
async def validation_edit_user(utente: UtenteRequest, db: SessionLocal = Depends(get_db)):
    try:
        # Converter os dados do modelo Pydantic para dicionário
        utente_data = utente.dict()
        query = text("""
        SELECT edit_utente(
            :hashed_id,
            :nome_completo,
            :sexo,
            :morada,
            :nr_porta,
            :nr_andar,
            :codigo_postal,
            :data_nascimento,
            :distrito,
            :concelho,
            :freguesia,
            :pais_naturalidade,
            :pais_nacionalidade,
            :tipo_documento_identificacao,
            :numero_documento_identificacao,
            :numero_utente_saude,
            :numero_identificacao_fiscal,
            :numero_seguranca_social,
            :numero_telemovel,
            :id_entidade_responsavel,
            :documento_validade,
            :justvalidate_inputs
        );
        """)
        result = db.execute(query, utente_data)
        db.commit()
        return {"response": result} 
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        db.rollback()
        error_messages = [str(arg) for arg in e.args]
        return {"error": error_messages}