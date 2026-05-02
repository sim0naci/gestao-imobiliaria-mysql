import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

# Carregando as variáveis do arquivo .env para a memória do sistema
load_dotenv()

usuario = os.getenv("DB_USER")
senha = os.getenv("DB_PASSWORD")
host = os.getenv("DB_HOST")
banco = os.getenv("DB_NAME")

DATABASE_URL = f"mysql+pymysql://{usuario}:{senha}@{host}:3306/{banco}"

engine = create_engine(DATABASE_URL, echo=True)
Base = declarative_base()
SessionLocal = sessionmaker(bind=engine)