from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base  # Atualizado aqui


#import os

#password = os.getenv('tDd15fe2LxCmqV8J')
#URL_DATABASE = f'postgresql://postgres:{password}@db.exaeozpjrqqzfrztgulf.supabase.co:5432/postgres'

URL_DATABASE = f'postgresql://postgres.exaeozpjrqqzfrztgulf:[tDd15fe2LxCmqV8J]@aws-0-eu-central-1.pooler.supabase.com:5432/postgres'

engine = create_engine(URL_DATABASE)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()  # Não mudou o uso, apenas a importação
