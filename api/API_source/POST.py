from sqlalchemy.sql import text
from fastapi import APIRouter, Depends, HTTPException
from database import SessionLocal
from dependencies import get_db
from Models.Utente import UtenteRequest
from FireBase import singup, login, resetpassword
from sqlalchemy.exc import SQLAlchemyError
from Models.UserSignup import UserSignup
from Models.Search import Search
from Models.SecretarioClinico import SecretarioClinicoRequest
from Models.Medico import MedicoRequest
from Models.Requerimento import RequerimentoRequest
from Models.Email import SendEmail
from SendEmail import enviarEmailRequerimentoAceite, enviarEmailRequerimentoRecusado , enviarEmailPreAvaliação
from Models.SendPreAvalicao import SendEmailPreAvaliacao
from Models.RNU import RNU
from Models.PreAvalição import PreAvaliacao
import httpx
import json


post_router = APIRouter()

@post_router.post("/create_user/")
async def create_user(utente: UtenteRequest, db: SessionLocal = Depends(get_db)):
    try:
        # Converter os dados do modelo Pydantic para dicionário
        utente_data = utente.dict()
        query = text("""
        SELECT register_utente(
            :email,
            :password,
            :numero_utente_saude,
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
    
    
@post_router.post("/validation_create_secretario_clinico/")
async def validation_create_secretario_clinico(secretario_clinico: SecretarioClinicoRequest, db: SessionLocal = Depends(get_db)):
    try:
        # Converter os dados do modelo Pydantic para dicionário
        secretario_clinico_data = secretario_clinico.dict()
        query = text("""
        SELECT register_secretario_clinico(
            :nome_completo,
            :data_nascimento,
            :numero_telemovel,
            :sexo,
            :pais,
            :distrito,
            :concelho,
            :freguesia,
            :email,
            :password,
            :justvalidate_input
        );
        """)
        result = db.execute(query, secretario_clinico_data)
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


@post_router.post("/validation_create_medico/")
async def validation_create_medico(medico: MedicoRequest, db: SessionLocal = Depends(get_db)):
    try:
        # Converter os dados do modelo Pydantic para dicionário
        medico_data = medico.dict()
        query = text("""
        SELECT register_medico(
            :nome_completo,
            :data_nascimento,
            :numero_telemovel,
            :sexo,
            :pais,
            :distrito,
            :concelho,
            :freguesia,
            :especialidade,
            :num_cedula,
            :num_ordem,
            :email,
            :password,
            :justvalidate_inputs
        );
        """)
        result = db.execute(query, medico_data)
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
        result=singup(user.email,user.password)
        if result!=True:
            return {"error": result}
        return {"response": result}
    except Exception as e:
        return {"error": str(e)}


@post_router.post("/full_login/")
async def full_login(user:UserSignup):
    try:
        result=login(user.email,user.password)
        if(result=="Credenciais Invalidas"):
            return {"error": result}
        return {"response": result}
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
        result = result.scalar()
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


@post_router.post("/get_user_info/")
async def get_user_info(user:UserSignup, db: SessionLocal = Depends(get_db)):
    try:
        query = text("SELECT * FROM get_user_info(:email);")
        result = db.execute(query, {"email": user.email})
        user_info = result.fetchone()
        if user_info:
            hashed_id = user_info[0]
            cargo_name = user_info[1]
            result = {
                "hashed_id": hashed_id,
                "cargo_name": cargo_name
            }
        return {"response": result}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        db.rollback()
        error_messages = [str(arg) for arg in e.args]
        return {"error": error_messages}
    
#NOT TESTED MISSING JSON TO RESPONSE
@post_router.post("/get_utente_info/")
async def get_utente_info(hashedid: Search, db: SessionLocal = Depends(get_db)):
    try:
        query = text("SELECT * FROM get_utente_info(:hashed_id);")
        result = db.execute(query, {"hashed_id": hashedid.hashed_id})
        user_info = result.fetchone()
        if user_info:
            # Desempacotar os valores retornados
            result = dict(zip(result.keys(), user_info))
        return {"response": result}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        db.rollback()
        return {"error": str(e)}



@post_router.post("/get_secretario_clinico_info/")
async def get_secretario_clinico_info(hashedid: Search, db: SessionLocal = Depends(get_db)):
    try:
        query = text("SELECT * FROM get_secretario_clinico_info(:hashed_id);")
        result = db.execute(query, {"hashed_id": hashedid.hashed_id})
        user_info = result.fetchone()
        if user_info:
            result = dict(zip(result.keys(), user_info))
        return {"response": result}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        db.rollback()
        return {"error": str(e)}
    
    
    
@post_router.post("/get_medic_info/")
async def get_medic_info(hashedid: Search, db: SessionLocal = Depends(get_db)):
    try:
        query = text("SELECT * FROM get_medico_info(:hashed_id);")
        result = db.execute(query, {"hashed_id": hashedid.hashed_id})
        user_info = result.fetchone()
        if user_info:
            result = dict(zip(result.keys(), user_info))
        return {"response": result}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        db.rollback()
        return {"error": str(e)}


    
@post_router.post("/insert_requirement/")
async def insert_requirement(requerimento: RequerimentoRequest, db: SessionLocal = Depends(get_db)):
    try:
        requerimento_data = requerimento.dict()
        requerimento_data['documentos'] = json.dumps(requerimento_data['documentos'])
        query = text("""
        SELECT insert_requerimento_junta_medica(
            :hashed_id,
            :documentos,
            :type,
            :nunca_submetido,
            :submetido,
            :data_submetido
        );
        """)
        result = db.execute(query, requerimento_data)
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


@post_router.post("/fetch_requirement/")
async def fetch_requirement(hashedid: Search, db: SessionLocal = Depends(get_db)):
    try:
        query = text("SELECT * FROM requerimentos_por_utente(:hashed_id);")
        result = db.execute(query, {"hashed_id": hashedid.hashed_id})
        info = result.fetchall()
        colunas = result.keys()
        result = [{coluna: valor for coluna, valor in zip(colunas, row)} for row in info]

        return {"response": result}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        db.rollback()
        return {"error": str(e)}
    
    
@post_router.post("/validar_requerimento/")
async def validar_requerimento(hashedid: Search, db: SessionLocal = Depends(get_db)):
    try:
        query = text("SELECT * FROM validar_requerimento(:hashed_id);")
        result = db.execute(query, {"hashed_id": hashedid.hashed_id})
        result = result.scalar()
        db.commit()
        return {"response": result}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        db.rollback()
        return {"error": str(e)}
    
    
@post_router.post("/recusar_requerimento/")
async def recusar_requerimento(hashedid: Search, db: SessionLocal = Depends(get_db)):
    try:
        query = text("SELECT * FROM recusar_requerimento(:p_hashed_id);")
        result = db.execute(query, {"p_hashed_id": hashedid.hashed_id})
        result = result.scalar()
        db.commit()
        return {"response": result}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        db.rollback()
        return {"error": str(e)}
    


@post_router.post("/send_email_validar_requerimento/")
async def send_email_validar_requerimento(sendEmail: SendEmail, db: SessionLocal = Depends(get_db)):
    try:
        enviarEmailRequerimentoAceite(sendEmail.email)
        return {"response": True}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        return {"error": str(e)}


@post_router.post("/send_email_recusar_requerimento/")
async def send_email_recusar_requerimento(sendEmail: SendEmail, db: SessionLocal = Depends(get_db)):
    try:
        enviarEmailRequerimentoRecusado(sendEmail.email)
        return {"response": True}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        return {"error": str(e)}
    

@post_router.post("/send_email_validar_requerimento/")
async def send_email_validar_requerimento(sendEmail: SendEmail, db: SessionLocal = Depends(get_db)):
    try:
        enviarEmailRequerimentoAceite(sendEmail.email)
        return {"response": True}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        return {"error": str(e)}


@post_router.post("/send_email_preavalicao/")
async def send_email_preavalicao(preavalicao: SendEmailPreAvaliacao, db: SessionLocal = Depends(get_db)):
    try:
        enviarEmailPreAvaliação(preavalicao.email,preavalicao.preavalicao)
        return {"response": True}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        return {"error": str(e)}



@post_router.post("/rnu_verificar_existe_nss/")
async def rnu_verificar_existe_nss(NNS: RNU):
    async with httpx.AsyncClient() as client:
        try:
            response = await client.post('http://localhost:5000/RNU_GET_NNS_EXIST/', json={"NNS": NNS.NNS})
            response.raise_for_status()
            return response.json()
        except httpx.RequestError as exc:
            raise HTTPException(status_code=400, detail=f"Erro ao se conectar com a API: {exc}") 
        except httpx.HTTPStatusError as exc:
            raise HTTPException(status_code=exc.response.status_code, detail=f"Erro na resposta da API: {exc.response.content}")
        
        

@post_router.post("/rnu_get_dados_nss/")
async def rnu_get_dados_nss(NNS: RNU):
    async with httpx.AsyncClient() as client:
        try:
            response = await client.post('http://localhost:5000/RNU_GET_DADOS_BY_NNS/', json={"NNS": NNS.NNS})
            response.raise_for_status()
            return response.json()
        except httpx.RequestError as exc:
            raise HTTPException(status_code=400, detail=f"Erro ao se conectar com a API: {exc}") 
        except httpx.HTTPStatusError as exc:
            raise HTTPException(status_code=exc.response.status_code, detail=f"Erro na resposta da API: {exc.response.content}")


@post_router.post("/insert_preavaliacao/")
async def insert_preavaliacao(preavalicao: PreAvaliacao, db: SessionLocal = Depends(get_db)):
    try:
        # Converter os dados do modelo Pydantic para dicionário
        preavalicao_data = preavalicao.dict()
        query = text("""
        SELECT inserir_pre_avaliacao(
            :hashed_id_requerimento,
            :hashed_id_medico, 
            :pre_avaliacao,
            :observacoes
        );
        """)
        result = db.execute(query, preavalicao_data)
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
    

@post_router.post("/get_dados_preavaliacao/")
async def get_dados_preavaliacao(hashedid: Search, db: SessionLocal = Depends(get_db)):
    try:
        query = text("SELECT * FROM get_preavaliacao_medico_info(:hashed_id);")
        result = db.execute(query, {"hashed_id": hashedid.hashed_id})
        preAvalicao_info = result.fetchall()
        colunas = result.keys()
        result = [{coluna: valor for coluna, valor in zip(colunas, row)} for row in preAvalicao_info]
        return {"response": result}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        db.rollback()
        return {"error": str(e)}

@post_router.post("/accept_junta_medica_requerimento/")
async def accept_junta_medica_requerimento(hashedid: Search, db: SessionLocal = Depends(get_db)):
    try:
        query = text("SELECT * FROM accept_update_requerimento_status(:hashed_id);")
        result = db.execute(query, {"hashed_id": hashedid.hashed_id})
        result = result.scalar()
        db.commit()
        return {"response": result}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        db.rollback()
        return {"error": str(e)}
    
@post_router.post("/decline_junta_medica_requerimento/")
async def decline_junta_medica_requerimento(hashedid: Search, db: SessionLocal = Depends(get_db)):
    try:
        query = text("SELECT * FROM rejcted_update_requerimento_status(:hashed_id);")
        result = db.execute(query, {"hashed_id": hashedid.hashed_id})
        result = result.scalar()
        db.commit()
        return {"response": result}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        db.rollback()
        return {"error": str(e)}

