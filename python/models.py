from sqlalchemy import Column, Integer, String

class Corretores(Base):
    __tablename__ = 'Corretores'  # Exatamente o nome que está no Workbench

    # Mapeando as colunas
    id_corretor = Column(Integer, primary_key=True, autoincrement=True)
    nome = Column(String(100), nullable=False)
    creci = Column(String(20), nullable=False)
    telefone = Column(String(20))

    # Isso é apenas para o Python imprimir o objeto de um jeito bonito
    def __repr__(self):
        return f"<Corretor(nome='{self.nome}', creci='{self.creci}')>"