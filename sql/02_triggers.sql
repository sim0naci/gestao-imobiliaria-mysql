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