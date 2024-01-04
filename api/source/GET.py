from sqlalchemy.sql import text
from fastapi import APIRouter, Depends
from database import SessionLocal
from dependencies import get_db
from sqlalchemy.exc import SQLAlchemyError


get_router = APIRouter()


@get_router.get("/is_connected/")
async def check_connection(db: SessionLocal = Depends(get_db)):
    try:
        result = db.execute(text("SELECT is_connected();"))
        is_connected_value = result.scalar()
        return {"response": is_connected_value}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        return {"error": str(e)}



@get_router.get("/get_entidades_responsaveis/")
async def get_entidades_responsaveis(db: SessionLocal = Depends(get_db)):
    try:
        result = db.execute(text("SELECT get_entidades_responsaveis();"))
        nomes_entidades = [row[0] for row in result.fetchall()]
        return {"response": nomes_entidades}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        return {"error": str(e)}

@get_router.get("/load_especialidade/")
async def load_especialidade(db: SessionLocal = Depends(get_db)):
    try:
        result = db.execute(text("SELECT get_all_especialidades();"))
        nomes_entidades = [row[0] for row in result.fetchall()]
        return {"response": nomes_entidades}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        return {"error": str(e)}

@get_router.get("/get_requerimentos_utente_status_zero/")
async def get_requerimentos_utente_status_zero(db: SessionLocal = Depends(get_db)):
    try:
        result = db.execute(text("SELECT get_requerimentos_utente_status_zero();"))
        user_info = result.fetchall()
        colunas = result.keys()
        requerimentos = [{coluna: valor for coluna, valor in zip(colunas, row)} for row in user_info]
        return {"response": requerimentos}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        return {"error": str(e)}
    
    
    