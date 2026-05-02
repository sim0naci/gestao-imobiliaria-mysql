# 1. Pega um Linux bem leve
FROM python:3.10-slim

# 2. Cria uma pasta chamada /app dentro do container e entra nela
WORKDIR /app

# 3. Copia o arquivo de dependências da minha máquina para dentro do container
COPY requirements.txt .

# 4. Instala as bibliotecas
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copia todo o resto do seu código (models.py, database.py, etc) para o container
COPY . .

# 6. O comando que o container vai rodar quando for ligado
CMD ["python", "main.py"]