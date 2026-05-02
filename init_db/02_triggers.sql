use imobiliaria_petropolis;

DELIMITER //

create trigger trg_valida_status_imovel
before insert on Contratos
for each row
begin
	-- Variável para guardar o status do imóvel
    declare v_status VARCHAR(20);
    
    -- 1. Vai à tabela Imoveis e busca o status do imóvel que o corretor está a tentar alugar
    select status into v_status
    from Imoveis
    where id_imovel = NEW.id_imovel;
    
    -- 2. Regra de Negócio: Se não estiver 'Disponível', a operação é bloqueada
    if v_status != 'Disponível' then
		signal SQLSTATE '45000'
        set MESSAGE_TEXT = 'Erro de Negócio: O imóvel selecionado não está Disponível para locação!';
	END if;
END //
DELIMITER ;

INSERT INTO Imoveis (endereco, valor_aluguel, status) 
VALUES ('Rua Teresa, 100 - Centro', 1500.00, 'Alugado');

INSERT INTO Corretores (nome, creci, telefone) 
VALUES ('João Corretor', '12345-RJ', '24999999999');

INSERT INTO Contratos (id_imovel, id_corretor, data_inicio, data_vencimento)
VALUES (1, 1, '2026-05-01', '2027-05-01');

select * from Imoveis;
select * from Corretores;
select * from Contratos;
delete from Contratos
where id_imovel = 1;
SHOW TRIGGERS;

use imobiliaria_petropolis;

DELIMITER //
CREATE TRIGGER trg_auditoria_status_imovel
AFTER UPDATE ON Imoveis
FOR EACH ROW
BEGIN
    -- Só grava na tabela de logs se o status realmente tiver mudado
    IF OLD.status != NEW.status THEN
        
        INSERT INTO Log_Auditoria (
            tabela_alterada, 
            acao,
            usuario,
            data_hora,
            descricao_antiga,
            descricao_nova,
            id_registro_alterado
        ) VALUES (
            'Imoveis', 
            'UPDATE',
			USER(), -- Função nativa do MySQL que pega o nome de quem fez a alteração,
            NOW(),   -- Função nativa que pega a data e hora exata do servidor
            OLD.status,
            NEW.status,
            NEW.id_imovel
        );
        
    END IF;
END //

DELIMITER ;

UPDATE Imoveis 
SET status = 'Disponível' 
WHERE id_imovel = 1;

SELECT * FROM Log_Auditoria Imoveis;
describe Imoveis;
select * from Imoveis;
drop trigger trg_auditoria_status_imovel;
describe Log_Auditoria;


DELIMITER //

CREATE TRIGGER trg_auditoria_insert_imovel
AFTER INSERT ON Imoveis
FOR EACH ROW
BEGIN
    INSERT INTO Log_Auditoria (
        tabela_alterada, 
        acao,
        usuario,
        data_hora,
        descricao_antiga,
        descricao_nova,
        id_registro_alterado
    ) VALUES (
        'Imoveis', 
        'INSERT',
        USER(), 
        NOW(), 
        NULL,        -- Como é um registro novo, não existe passado
        NEW.status,  -- O status com o qual o imóvel foi cadastrado
        NEW.id_imovel
    );
END //

DELIMITER ;



DELIMITER //

CREATE TRIGGER trg_auditoria_delete_imovel
AFTER DELETE ON Imoveis
FOR EACH ROW
BEGIN
    INSERT INTO Log_Auditoria (
        tabela_alterada, 
        acao,
        usuario,
        data_hora,
        descricao_antiga,
        descricao_nova,
        id_registro_alterado
    ) VALUES (
        'Imoveis', 
        'DELETE',
        USER(), 
        NOW(), 
        OLD.status,  -- Salvamos o status que o imóvel tinha antes de sumir
        NULL,        -- Como foi deletado, não há um "novo" status
        OLD.id_imovel
    );
END //

DELIMITER ;
describe Imoveis;
select * from Imoveis;

INSERT INTO Imoveis (endereco, valor_aluguel, status) 
VALUES ('Rua Teresa, 100', 2000, 'Disponível');

SELECT * FROM Log_Auditoria Imoveis;

DELETE FROM Imoveis WHERE id_imovel = 2;