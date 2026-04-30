-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: 127.0.0.1    Database: imobiliaria_petropolis
-- ------------------------------------------------------
-- Server version	8.0.45-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Clientes`
--

DROP TABLE IF EXISTS `Clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Clientes` (
  `id_cliente` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `cpf` varchar(14) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `cpf` (`cpf`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Clientes`
--

LOCK TABLES `Clientes` WRITE;
/*!40000 ALTER TABLE `Clientes` DISABLE KEYS */;
INSERT INTO `Clientes` VALUES (1,'João da Silva Teste','11122233344','joao@teste.com','24999999999');
/*!40000 ALTER TABLE `Clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Contratos`
--

DROP TABLE IF EXISTS `Contratos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Contratos` (
  `id_contrato` int NOT NULL AUTO_INCREMENT,
  `id_imovel` int NOT NULL,
  `id_corretor` int NOT NULL,
  `id_cliente` int NOT NULL,
  `data_inicio` date NOT NULL,
  `status_contrato` enum('Ativo','Encerrado','Rescindido') DEFAULT 'Ativo',
  PRIMARY KEY (`id_contrato`),
  UNIQUE KEY `id_imovel` (`id_imovel`),
  KEY `id_corretor` (`id_corretor`),
  KEY `fk_contratos_clientes` (`id_cliente`),
  CONSTRAINT `Contratos_ibfk_1` FOREIGN KEY (`id_imovel`) REFERENCES `Imoveis` (`id_imovel`),
  CONSTRAINT `Contratos_ibfk_2` FOREIGN KEY (`id_corretor`) REFERENCES `Corretores` (`id_corretor`),
  CONSTRAINT `fk_contratos_clientes` FOREIGN KEY (`id_cliente`) REFERENCES `Clientes` (`id_cliente`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Contratos`
--

LOCK TABLES `Contratos` WRITE;
/*!40000 ALTER TABLE `Contratos` DISABLE KEYS */;
INSERT INTO `Contratos` VALUES (3,1,1,1,'2023-01-01','Ativo');
/*!40000 ALTER TABLE `Contratos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`simonaci`@`localhost`*/ /*!50003 TRIGGER `trg_valida_status_imovel` BEFORE INSERT ON `Contratos` FOR EACH ROW begin
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Corretores`
--

DROP TABLE IF EXISTS `Corretores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Corretores` (
  `id_corretor` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `creci` varchar(20) NOT NULL,
  `telefone` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_corretor`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Corretores`
--

LOCK TABLES `Corretores` WRITE;
/*!40000 ALTER TABLE `Corretores` DISABLE KEYS */;
INSERT INTO `Corretores` VALUES (1,'João Corretor','12345-RJ','24999999999');
/*!40000 ALTER TABLE `Corretores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Faturas`
--

DROP TABLE IF EXISTS `Faturas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Faturas` (
  `id_fatura` int NOT NULL AUTO_INCREMENT,
  `id_contrato` int NOT NULL,
  `numero_parcela` int NOT NULL,
  `valor_parcela` decimal(10,2) NOT NULL,
  `data_vencimento` date NOT NULL,
  `data_pagamento` date DEFAULT NULL,
  `status_pagamento` enum('Pendente','Pago','Atrasado','Cancelado') DEFAULT 'Pendente',
  PRIMARY KEY (`id_fatura`),
  KEY `fk_fatura_contrato` (`id_contrato`),
  CONSTRAINT `fk_fatura_contrato` FOREIGN KEY (`id_contrato`) REFERENCES `Contratos` (`id_contrato`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Faturas`
--

LOCK TABLES `Faturas` WRITE;
/*!40000 ALTER TABLE `Faturas` DISABLE KEYS */;
INSERT INTO `Faturas` VALUES (3,3,1,1500.00,'2024-01-01',NULL,'Atrasado'),(4,3,2,1500.00,'2026-05-29',NULL,'Pendente'),(5,3,1,1500.00,'2024-01-01',NULL,'Atrasado'),(6,3,2,1500.00,'2026-05-29',NULL,'Pendente');
/*!40000 ALTER TABLE `Faturas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Imoveis`
--

DROP TABLE IF EXISTS `Imoveis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Imoveis` (
  `id_imovel` int NOT NULL AUTO_INCREMENT,
  `endereco` varchar(255) NOT NULL,
  `valor_aluguel` decimal(10,2) NOT NULL,
  `status` enum('Disponível','Alugado','Manutenção') DEFAULT 'Disponível',
  PRIMARY KEY (`id_imovel`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Imoveis`
--

LOCK TABLES `Imoveis` WRITE;
/*!40000 ALTER TABLE `Imoveis` DISABLE KEYS */;
INSERT INTO `Imoveis` VALUES (1,'Rua Teresa, 100 - Centro',1500.00,'Disponível');
/*!40000 ALTER TABLE `Imoveis` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`simonaci`@`localhost`*/ /*!50003 TRIGGER `trg_auditoria_insert_imovel` AFTER INSERT ON `Imoveis` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`simonaci`@`localhost`*/ /*!50003 TRIGGER `trg_auditoria_status_imovel` AFTER UPDATE ON `Imoveis` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`simonaci`@`localhost`*/ /*!50003 TRIGGER `trg_auditoria_delete_imovel` AFTER DELETE ON `Imoveis` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Log_Auditoria`
--

DROP TABLE IF EXISTS `Log_Auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Log_Auditoria` (
  `id_log` int NOT NULL AUTO_INCREMENT,
  `tabela_alterada` varchar(50) NOT NULL,
  `acao` enum('INSERT','UPDATE','DELETE') NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `data_hora` datetime DEFAULT CURRENT_TIMESTAMP,
  `descricao_antiga` text,
  `descricao_nova` text,
  `id_registro_alterado` int DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Log_Auditoria`
--

LOCK TABLES `Log_Auditoria` WRITE;
/*!40000 ALTER TABLE `Log_Auditoria` DISABLE KEYS */;
INSERT INTO `Log_Auditoria` VALUES (1,'Imoveis','UPDATE','simonaci@localhost','2026-04-29 19:43:59','Alugado','Disponível',1),(2,'Imoveis','INSERT','simonaci@localhost','2026-04-29 19:50:19',NULL,'Disponível',2),(3,'Imoveis','DELETE','simonaci@localhost','2026-04-29 19:51:29','Disponível',NULL,2);
/*!40000 ALTER TABLE `Log_Auditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'imobiliaria_petropolis'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `evt_atualizacao_diaria_faturas` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8mb4 */ ;;
/*!50003 SET character_set_results = utf8mb4 */ ;;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`simonaci`@`localhost`*/ /*!50106 EVENT `evt_atualizacao_diaria_faturas` ON SCHEDULE EVERY 1 DAY STARTS '2026-04-29 23:59:00' ON COMPLETION NOT PRESERVE ENABLE DO BEGIN
        -- Registra no log que o agendador iniciou a tarefa (opcional, mas boa prática)
        CALL sp_atualiza_faturas_atrasadas();
    END */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'imobiliaria_petropolis'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_atualiza_faturas_atrasadas` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`simonaci`@`localhost` PROCEDURE `sp_atualiza_faturas_atrasadas`()
BEGIN
    UPDATE Faturas
    SET status_pagamento = 'Atrasado'
    WHERE data_vencimento < CURDATE() 
      AND status_pagamento = 'Pendente';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-29 21:19:09
