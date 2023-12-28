from sqlalchemy.sql import text
from fastapi import FastAPI, status, Depends
from database import SessionLocal
import uvicorn
from fastapi.middleware.cors import CORSMiddleware

api = FastAPI()

api.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Permite todas as origens
    allow_credentials=True,
    allow_methods=["*"],  # Permite todos os métodos
    allow_headers=["*"],  # Permite todos os cabeçalhos
)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


if __name__ == "__main__":
    uvicorn.run("main:api", host="localhost", port=8000, reload=True)
    #uvicorn.run(api)
    

@api.get("/is_connected/")
async def check_connection(db: SessionLocal = Depends(get_db)):
    try:
        result = db.execute(text("SELECT is_connected();"))
        is_connected_value = result.scalar()
        return {"is_connected": is_connected_value}
    except Exception as e:
        return {"error": str(e)}
    
@api.get("/get_entidades_responsaveis/")
async def check_connection(db: SessionLocal = Depends(get_db)):
    try:
        result = db.execute(text("SELECT get_entidades_responsaveis();"))
        nomes_entidades = [row[0] for row in result.fetchall()]
        return {"nomes_entidades": nomes_entidades}
    except Exception as e:
        return {"error": str(e)}
