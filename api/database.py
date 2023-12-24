from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base  # Atualizado aqui

URL_DATABASE = 'postgresql://postgres.exaeozpjrqqzfrztgulf:[bLnq84ooRMT2koOH]@aws-0-eu-central-1.pooler.supabase.com:6543/postgres'

engine = create_engine(URL_DATABASE)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()  # Não mudou o uso, apenas a importação
