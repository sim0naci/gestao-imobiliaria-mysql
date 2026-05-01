from database import SessionLocal, engine, Base
from models import Corretor, Cliente, Imovel
from sqlalchemy import text

def testar_sistema():
    # 1. Testar Conexão Básica
    print("--- Testando conexão com o banco ---")
    try:
        with engine.connect() as conn:
            result = conn.execute(text("SELECT 'Conexão OK!'"))
            print(f"Resultado do Banco: {result.fetchone()[0]}")
    except Exception as e:
        print(f"❌ Erro de conexão: {e}")
        return

    # 2. Abrir Sessão para Testar Modelos
    db = SessionLocal()
    try:
        print("\n--- Testando Inserção de Dados ---")
        
        # Criando um Corretor de teste[cite: 1, 5]
        novo_corretor = Corretor(
            nome="Corretor de Teste", 
            creci="99999-RJ", 
            telefone="24988888888"
        )
        db.add(novo_corretor)
        
        # Criando um Cliente de teste[cite: 1, 3]
        novo_cliente = Cliente(
            nome="Cliente de Teste",
            cpf="000.000.000-00",
            email="teste@email.com"
        )
        db.add(novo_cliente)
        
        db.commit()
        print("✅ Dados inseridos com sucesso!")

        # 3. Testando Consulta (Query)
        print("\n--- Testando Consulta ---")
        corretor_db = db.query(Corretor).filter_by(creci="99999-RJ").first()
        if corretor_db:
            print(f"Encontrado no Banco: {corretor_db.nome} (ID: {corretor_db.id_corretor})")

    except Exception as e:
        db.rollback()
        print(f"❌ Erro durante a operação: {e}")
    finally:
        db.close()
        print("\n--- Sessão fechada ---")

if __name__ == "__main__":
    testar_sistema()