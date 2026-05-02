from sqlalchemy import Column, Integer, String, Numeric, Date, Enum, ForeignKey
from sqlalchemy.orm import relationship, Session
import enum
from app.database import Base
from datetime import date, timedelta

# Esse arquivo consiste na criação das tabelas, do banco de dados, no Python.
# As tabelas são classes.
# Também foi necessário transformar cada "enumerate" do SQL em uma classe no python.


class StatusImovel(enum.Enum):
    DISPONIVEL = 'Disponível'
    ALUGADO = 'Alugado'
    MANUTENCAO = 'Manutenção'

class StatusContrato(enum.Enum):
    ATIVO = 'Ativo'
    ENCERRADO = 'Encerrado'
    RESCINDIDO = 'Rescindido'

class StatusPagamento(enum.Enum):
    PENDENTE = 'Pendente'
    PAGO = 'Pago'
    ATRASADO = 'Atrasado'
    CANCELADO = 'Cancelado'



class Corretor(Base):

    __tablename__ = 'Corretores'

    # Definição das Colunas conforme o Schema
    id_corretor = Column(Integer, primary_key=True, autoincrement=True) 
    nome = Column(String(100), nullable=False) 
    creci = Column(String(20), nullable=False) 
    telefone = Column(String(20)) 


    # Essencial para análises de produtividade e engenharia de dados
    contratos = relationship("Contrato", back_populates="corretor")

    def __repr__(self):
        """Representação do objeto para facilitar o debugging no terminal Linux"""
        return f"<Corretor(nome='{self.nome}', creci='{self.creci}')>" 

class Imovel(Base):
    __tablename__ = 'Imoveis'
    id_imovel = Column(Integer, primary_key=True, autoincrement=True)
    endereco = Column(String(255), nullable=False)
    valor_aluguel = Column(Numeric(10, 2), nullable=False) # utilização do Numeric ao invés do float para garantir precisão de valores
    status = Column(Enum(StatusImovel), default=StatusImovel.DISPONIVEL)
    
    contrato = relationship("Contrato", back_populates="imovel", uselist=False)

class Cliente(Base):
    __tablename__ = 'Clientes'
    id_cliente = Column(Integer, primary_key=True, autoincrement=True)
    nome = Column(String(100), nullable=False)
    cpf = Column(String(14), nullable=False, unique=True)
    email = Column(String(100))
    telefone = Column(String(20))
    
    contratos = relationship("Contrato", back_populates="cliente")


class Contrato(Base):
    __tablename__ = 'Contratos'
    id_contrato = Column(Integer, primary_key=True, autoincrement=True)
    id_imovel = Column(Integer, ForeignKey('Imoveis.id_imovel'), unique=True, nullable=False)
    id_corretor = Column(Integer, ForeignKey('Corretores.id_corretor'), nullable=False)
    id_cliente = Column(Integer, ForeignKey('Clientes.id_cliente'), nullable=False)
    data_inicio = Column(Date, nullable=False)
    status_contrato = Column(Enum(StatusContrato), default=StatusContrato.ATIVO)

    corretor = relationship("Corretor", back_populates="contratos")
    imovel = relationship("Imovel", back_populates="contrato")
    cliente = relationship("Cliente", back_populates="contratos")
    faturas = relationship("Fatura", back_populates="contrato", cascade="all, delete-orphan")


class Fatura(Base):
    __tablename__ = 'Faturas'
    id_fatura = Column(Integer, primary_key=True, autoincrement=True)
    id_contrato = Column(Integer, ForeignKey('Contratos.id_contrato', ondelete="CASCADE"), nullable=False)
    numero_parcela = Column(Integer, nullable=False)
    valor_parcela = Column(Numeric(10, 2), nullable=False)
    data_vencimento = Column(Date, nullable=False)
    data_pagamento = Column(Date, nullable=True)
    status_pagamento = Column(Enum(StatusPagamento), default=StatusPagamento.PENDENTE)

    contrato = relationship("Contrato", back_populates="faturas")





# Calculando faturas autmomaticamente ao criar um novo contrato

def criar_novo_contrato(db: Session, id_imovel: int, id_cliente: int, id_corretor: int, meses: int):
    imovel = db.query(Imovel).filter(Imovel.id_imovel == id_imovel).first()
    

    novo_contrato = Contrato(
        id_imovel=id_imovel,
        id_cliente=id_cliente,
        id_corretor=id_corretor,
        data_inicio=date.today()
    )
    db.add(novo_contrato)
    db.flush() # Para obter o id_contrato antes do commit


    for i in range(1, meses + 1):
        fatura = Fatura(
            id_contrato=novo_contrato.id_contrato,
            numero_parcela=i,
            valor_parcela=imovel.valor_aluguel,
            data_vencimento=date.today() + timedelta(days=30 * i)
        )
        db.add(fatura)
    
    try:
        db.commit()
    except Exception as e:
        db.rollback()
        raise e