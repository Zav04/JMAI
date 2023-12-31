from sqlalchemy.sql import text
from fastapi import APIRouter, Depends
from database import SessionLocal
from dependencies import get_db
from Models.Utente import UtenteRequest
from FireBase import singup, login, resetpassword
from sqlalchemy.exc import SQLAlchemyError
from Models.UserSignup import UserSignup


post_router = APIRouter()

@post_router.post("/validation_create_user/")
async def validation_create_user(utente: UtenteRequest, db: SessionLocal = Depends(get_db)):
    try:
        # Converter os dados do modelo Pydantic para dicionário
        utente_data = utente.dict()
        query = text("""
        SELECT register_utente(
            :email,
            :password,
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



@post_router.post("/firebase_signup/")
async def create_user(user:UserSignup):
    try:
        user=singup(user.email,user.password)
        if user!=True:
            return {"error": user}
        return {"response": user}
    except Exception as e:
        return {"error": str(e)}


@post_router.post("/login/")
async def login(user:UserSignup):
    try:
        user=login(user.email,user.password)
        return {"response": user}
    except Exception as e:
        return {"error": str(e)}


@post_router.post("/firebase_forgorpassword/")
async def firebase_forgorpassword(user:UserSignup):
    try:
        response=resetpassword(user.email)
        return {"response": response}
    except Exception as e:
        return {"error": str(e)}
    

@post_router.post("/verify_email_exist/")
async def verify_email_exist(user:UserSignup, db: SessionLocal = Depends(get_db)):
    try:
        
        query = text("SELECT email_exists(:email);")
        result = db.execute(query, {"email": user.email})
        email_exists = result.scalar()
        db.commit()
        return {"response": email_exists}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        db.rollback()
        error_messages = [str(arg) for arg in e.args]
        return {"error": error_messages}



