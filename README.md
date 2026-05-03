# 🏢 Sistema Inteligente de Gestão Imobiliária

Este projeto apresenta um ecossistema de backend projetado para resolver um problema crítico no setor imobiliário: a **dessincronização de dados**. Utilizando Python e MySQL dentro de containers Docker, a solução garante que regras de negócio sejam respeitadas automaticamente, evitando erros humanos e prejuízos financeiros.

---

## 🎯 O Problema de Negócio (O "Porquê")
Em muitas imobiliárias, corretores perdem tempo tentando alugar imóveis que já foram reservados, ou o setor financeiro esquece de atualizar faturas atrasadas. Isso ocorre porque a "inteligência" do sistema depende de processos manuais.

**Minha Solução:** Transferir a inteligência para o motor de dados. O sistema não apenas armazena informações; ele **fiscaliza** as operações em tempo real.

---

## 🚀 Principais Funcionalidades

### 1. Prevenção de Conflitos (Integridade Atômica)
O banco de dados possui um bloqueio automático (*Triggers*). Se um corretor tentar criar um contrato para um imóvel que não esteja com status "Disponível", o sistema impede a gravação instantaneamente, protegendo a credibilidade da empresa.

### 2. Auditoria e Rastreabilidade (CDC - Change Data Capture)
Toda mudança de status de um imóvel (ex: de 'Disponível' para 'Alugado') é capturada automaticamente em uma tabela de logs separada. Isso permite saber **quem, quando e o que** foi alterado, essencial para conformidade e segurança de dados.

### 3. Automação Financeira Inteligente
Implementei um agendador (*Event Scheduler*) que roda todas as noites. Ele varre o banco de dados e marca faturas como "Atrasadas" automaticamente se o vencimento passou e o pagamento não foi detectado. Isso reduz a carga de trabalho operacional do setor financeiro.

---

## 🛠️ Tecnologias Utilizadas

* **Python (SQLAlchemy):** Gerenciamento da lógica de negócio e automação de parcelas.
* **MySQL 8.0:** Motor de banco de dados com Procedures, Triggers e Events.
* **Docker & Docker Compose:** Garante que o projeto rode em qualquer computador (Windows, Mac ou Linux) sem precisar instalar nada manualmente.

---

## 📦 Como Executar o Projeto

### Pré-requisitos
* Docker e Docker Compose instalados.

### Passo a Passo
1.  Clone este repositório.
2.  Crie um arquivo `.env` na raiz (use o `.env.example` como base).
3.  No terminal, execute:
    ```bash
    docker compose up -d --build
    ```
4.  Para testar a inserção automática e as regras de negócio, execute:
    ```bash
    docker exec -it imobiliaria_python python -m app.main
    ```

---

## 📊 Arquitetura de Dados
O sistema foi desenhado seguindo as melhores práticas de normalização, garantindo que o histórico de pagamentos e contratos permaneça íntegro mesmo se um imóvel for deletado do catálogo principal.

---
**Desenvolvido como parte do meu Portfólio de Engenharia de Dados.** 🚀
