select * from Contratos;
describe Contratos;

-- Percebi que precisarei criar uma nova tabela para faturas. Dessa forma, consigo fazer um stored procedure
-- que varre todo dia o banco identificando quem ficou com o pagamento atrasado

CREATE TABLE Faturas (
    id_fatura INT AUTO_INCREMENT PRIMARY KEY,
    id_contrato INT NOT NULL,
    numero_parcela INT NOT NULL,           -- Ex: 1, 2, 3 (para saber qual mês é)
    valor_parcela DECIMAL(10,2) NOT NULL,  -- Valor exato daquela mensalidade
    data_vencimento DATE NOT NULL,         -- O dia limite para pagar
    data_pagamento DATE NULL,              -- Fica vazio (NULL) até o cliente realmente pagar
    status_pagamento ENUM('Pendente', 'Pago', 'Atrasado', 'Cancelado') DEFAULT 'Pendente',
    
    -- Aqui criei a Chave Estrangeira
    CONSTRAINT fk_fatura_contrato 
        FOREIGN KEY (id_contrato) 
        REFERENCES Contratos(id_contracto) 
        ON DELETE CASCADE 
);


ALTER TABLE Contratos 
DROP COLUMN data_vencimento,
DROP COLUMN status_pagamento;


ALTER TABLE Contratos
ADD COLUMN status_contrato ENUM('Ativo', 'Encerrado', 'Rescindido') DEFAULT 'Ativo';



DELIMITER //

CREATE PROCEDURE sp_atualiza_faturas_atrasadas()
BEGIN
    UPDATE Faturas
    SET status_pagamento = 'Atrasado'
    WHERE data_vencimento < CURDATE() 
      AND status_pagamento = 'Pendente';
END //

DELIMITER ;

CREATE TABLE IF NOT EXISTS Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(100),
    telefone VARCHAR(20)
);

-- 1. Crieis a nova coluna de id para o cliente na tabela
ALTER TABLE Contratos
ADD COLUMN id_cliente INT NOT NULL AFTER id_corretor;

ALTER TABLE Contratos
ADD CONSTRAINT fk_contratos_clientes
FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente);

