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


@put_router.put("/validar_requerimento/")
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
    
    
@put_router.put("/recusar_requerimento/")
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

@put_router.put("/accept_junta_medica_requerimento/")
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
    
@put_router.put("/decline_junta_medica_requerimento/")
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
    
@put_router.put("/agendar_junta_medica_requerimento/")
async def agendar_junta_medica_requerimento(hashedid: Search, db: SessionLocal = Depends(get_db)):
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
    
    
    