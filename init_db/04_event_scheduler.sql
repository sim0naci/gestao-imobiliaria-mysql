-- Ativando o Agendador no Servidor
SET GLOBAL event_scheduler = ON;


-- criando o evento de auditoria diária
DELIMITER //

CREATE EVENT evt_atualizacao_diaria_faturas
ON SCHEDULE EVERY 1 DAY
STARTS (TIMESTAMP(CURRENT_DATE) + INTERVAL 23 HOUR + INTERVAL 59 MINUTE)
DO
    BEGIN
        -- Registra no log que o agendador iniciou a tarefa (opcional, mas boa prática)
        CALL sp_atualiza_faturas_atrasadas();
    END //

DELIMITER ;

SHOW EVENTS;
SHOW PROCESSLIST;