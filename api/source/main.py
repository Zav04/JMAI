from sqlalchemy.sql import text
from fastapi import FastAPI, status, Depends
from database import SessionLocal
import uvicorn
# from decouple import config
# from supabase import create_client, Client

# url = config("SUPERBASE_URL")
# key = config("SUPERBASE_KEY")

api = FastAPI()
# supabase: Client = create_client(url, key)

# Função para obter a sessão do banco de dados
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


if __name__ == "__main__":
    uvicorn.run("main:api", host="localhost", port=8000, reload=True)
    

@api.get("/is_connected/")
async def check_connection(db: SessionLocal = Depends(get_db)):
    try:
        result = db.execute(text("SELECT is_connected();"))
        is_connected_value = result.scalar()  # Assume que a função retorna um único valor
        return {"is_connected": is_connected_value}
    except Exception as e:
        return {"error": str(e)}
