from fastapi import FastAPI
import uvicorn
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.sql import text
from fastapi import Depends
from database import SessionLocal
from dependencies import get_db
from sqlalchemy.exc import SQLAlchemyError
from Models.RNU import RNU


api = FastAPI()

api.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)



@api.post("/RNU_GET_DADOS_BY_NNS/")
async def RNU_GET_DADOS_BY_NNS(nns_rnu: RNU, db: SessionLocal = Depends(get_db)):
    try:
        query = text("SELECT * FROM obter_dados_utente(:NNS);")
        result = db.execute(query, {"NNS": nns_rnu.NNS})
        user_info = result.fetchall()
        colunas = result.keys()
        dados = [{coluna: valor for coluna, valor in zip(colunas, row)} for row in user_info]
        return {"response": dados}
    except SQLAlchemyError as e:
        error_msg = str(e.__dict__['orig'])
        error_msg = error_msg.split('\n')[0]
        return {"error": error_msg}
    except Exception as e:
        db.rollback()
        return {"error": str(e)}
    
    
@api.post("/RNU_GET_NNS_EXIST/")
async def RNU_GET_NNS_EXIST(nns_rnu: RNU, db: SessionLocal = Depends(get_db)):
    try:
        query = text("SELECT * FROM verificar_utente_existente(:NNS);")
        result = db.execute(query, {"NNS": nns_rnu.NNS})
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



if __name__ == "__main__":
    uvicorn.run("main:api", host="localhost", port=5000, reload=True)
    #uvicorn.run(api)


