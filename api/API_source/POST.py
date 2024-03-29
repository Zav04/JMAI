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
from SendEmail import enviarEmailRequerimentoAceite, enviarEmailRequerimentoRecusado , enviarEmailPreAvaliação, enviarEmailAgendamento
from Models.SendPreAvalicao import SendEmailPreAvaliacao
from Models.Email_Agendamento import SendEmail_Agendamento
from Models.RNU import RNU
from Models.PreAvalição import PreAvaliacao
from Models.Agendamento import Agendamento
from Models.USF import USF
from Models.Email_Recusado import SendEmail_Recusado
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
    
    

@post_router.post("/send_email_agendado/")
async def send_email_agendado(sendEmail: SendEmail_Agendamento):
    try:
        enviarEmailAgendamento(sendEmail.email, sendEmail.agendamento)
        return {"response": True}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        return {"error": str(e)}
    

@post_router.post("/send_email_recusar_requerimento/")
async def send_email_recusar_requerimento(sendEmail: SendEmail_Recusado):
    try:
        enviarEmailRequerimentoRecusado(sendEmail.email, sendEmail.observacoes)
        return {"response": True}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        return {"error": str(e)}
    

@post_router.post("/send_email_validar_requerimento/")
async def send_email_validar_requerimento(sendEmail: SendEmail):
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
async def send_email_preavalicao(preavalicao: SendEmailPreAvaliacao):
    try:
        enviarEmailPreAvaliação(preavalicao.email,preavalicao.preavalicao)
        return {"response": True}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        return {"error": str(e)}


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
    


@post_router.post("/agendar_junta_medica_requerimento/")
async def agendar_junta_medica_requerimento(agenda: Agendamento, db: SessionLocal = Depends(get_db)):
    try:
        query = text("""
        SELECT agendar_junta_medica(
            :data,
            :hashed_id
        );
        """)
        result = db.execute(query, {"data": agenda.data,"hashed_id": agenda.hashed_id})
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

@post_router.post("/get_data_agendamento_junta_medica/")
async def get_data_agendamento_junta_medica(hashedid: Search, db: SessionLocal = Depends(get_db)):
    try:
        query = text("SELECT * FROM obter_data_agendamento_junta_medica(:hashed_id);")
        result = db.execute(query, {"hashed_id": hashedid.hashed_id})
        result = result.scalar()
        return {"response": result}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        db.rollback()
        return {"error": str(e)}
    
    
    
@post_router.post("/verificar_requerimento_existente/")
async def verificar_requerimento_existente(hashedid: Search, db: SessionLocal = Depends(get_db)):
    try:
        query = text("SELECT * FROM verificar_requerimento_existente(:hashed_id);")
        result = db.execute(query, {"hashed_id": hashedid.hashed_id})
        result = result.scalar()
        return {"response": result}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        db.rollback()
        return {"error": str(e)}
    


@post_router.post("/USF_insert/")
async def USF_insert(usf: USF, db: SessionLocal = Depends(get_db)):
    try:
        #Primerio validar se Existe o NSS no RNU
        NSS=int(usf.numero_utente)
        rnu_local = RNU(NNS=NSS)
        response = await rnu_get_dados_nss(rnu_local)
        if response['response'] == []:
            return {"error": "Número de Sáude Não Existe no RNU"}
        
        #Depois validar se o o email e o NSS já existe na BD
        query = text("SELECT * FROM USF_register_utente(:email,:password,:NNS, :validationInputs);")
        response = db.execute(query, {"email": usf.email, "password": usf.password, "NNS": usf.numero_utente, "validationInputs": True})

        query = text("SELECT * FROM USF_register_utente(:email,:password,:NNS, :validationInputs);")
        response = db.execute(query, {"email": usf.email, "password": usf.password, "NNS": usf.numero_utente, "validationInputs": False})
        response = response.scalar()
        id_utilizador=response
        db.commit()
        
        #Fazer Registo no FireBase
        firebase_local = UserSignup(email=usf.email,password=usf.password)
        response= await create_user(firebase_local)
        
        type='multiuso'
        if(usf.tipo_requerimento==type):
            type=1
        else:
            type=2
        
        submisao= 'primeira_vez'
        if(usf.tipo_submissao==submisao):
            submisao=1
        else:
            submisao=2
        
        if(submisao==1):
            query = text("SELECT * FROM insert_requerimento_junta_medica_SNS(:id_utilizador,:documentos,:type,:nuncaSubmetido,:submetido,:data_submissao);")
            response = db.execute(query, {"id_utilizador": id_utilizador, "documentos": "[]", "type": type, "nuncaSubmetido": True, "submetido": False,"data_submissao":""})
            response = response.scalar()
            db.commit()
        else:
            query = text("SELECT * FROM insert_requerimento_junta_medica_SNS(:id_utilizador,:documentos,:type,:nuncaSubmetido,:submetido,:data_submissao);")
            response = db.execute(query, {"id_utilizador": id_utilizador, "documentos": "[]", "type": type, "nuncaSubmetido": False, "submetido": True,"data_submissao":usf.data_avaliacao})
            response = response.scalar()
            db.commit()
        
        return {"response": response}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        db.rollback()
        return {"error": error_msg}
    except Exception as e:
        db.rollback()
        return {"error": str(e)}
    
    

    
    #Depois inserir na BD
    #Depois inserir na Firebase
    



