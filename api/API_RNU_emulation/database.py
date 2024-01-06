from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base 
from dotenv import load_dotenv
import os

load_dotenv()

password = os.getenv('DB_PASSWORD')
host = os.getenv('DB_HOST')
port = os.getenv('DB_PORT')
user = os.getenv('DB_USER')
database_name = os.getenv('DB_NAME')

URL_DATABASE = f'postgresql://{user}:{password}@{host}:{int(port)}/{database_name}'


engine = create_engine(
    URL_DATABASE)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()
