DROP DATABASE IF EXISTS barbearia;
CREATE DATABASE barbearia CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE barbearia;

CREATE TABLE CLIENTE (
    id_cliente     INT AUTO_INCREMENT PRIMARY KEY,
    nome_completo  VARCHAR(100) NOT NULL,
    telefone       VARCHAR(15)  NOT NULL,
    email          VARCHAR(100) NULL,
    data_cadastro  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE BARBEIRO (
    id_barbeiro    INT AUTO_INCREMENT PRIMARY KEY,
    nome_completo  VARCHAR(100) NOT NULL,
    telefone       VARCHAR(15)  NOT NULL,
    data_admissao  DATETIME     NOT NULL,
    status_ativo   TINYINT      NOT NULL DEFAULT 1
);

CREATE TABLE FORMA_PAGAMENTO (
    id_forma_pagamento INT AUTO_INCREMENT PRIMARY KEY,
    descricao          VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE SERVICO (
    id_servico         INT AUTO_INCREMENT PRIMARY KEY,
    nome_servico       VARCHAR(50)    NOT NULL,
    preco_padrao       DECIMAL(10,2)  NOT NULL,
    tempo_estimado_min INT            NOT NULL,
    CONSTRAINT ck_servico_preco CHECK (preco_padrao >= 0),
    CONSTRAINT ck_servico_tempo CHECK (tempo_estimado_min > 0)
);

CREATE TABLE AGENDAMENTO (
    id_agendamento        INT AUTO_INCREMENT PRIMARY KEY,
    data_hora_agendamento DATETIME    NOT NULL,
    status_agendamento    VARCHAR(20) NOT NULL DEFAULT 'AGENDADO',
    id_cliente            INT NOT NULL,
    id_barbeiro           INT NOT NULL,
    id_forma_pagamento    INT NOT NULL,
    CONSTRAINT fk_agend_cliente    FOREIGN KEY (id_cliente)         REFERENCES CLIENTE (id_cliente),
    CONSTRAINT fk_agend_barbeiro   FOREIGN KEY (id_barbeiro)        REFERENCES BARBEIRO (id_barbeiro),
    CONSTRAINT fk_agend_pagamento  FOREIGN KEY (id_forma_pagamento) REFERENCES FORMA_PAGAMENTO (id_forma_pagamento),
    CONSTRAINT ck_agend_status CHECK (status_agendamento IN ('AGENDADO','CONCLUIDO','CANCELADO'))
);

CREATE TABLE ITEM_AGENDAMENTO (
    id_item        INT AUTO_INCREMENT PRIMARY KEY,
    preco_cobrado  DECIMAL(10,2) NOT NULL,
    id_agendamento INT NOT NULL,
    id_servico     INT NOT NULL,
    CONSTRAINT fk_item_agendamento FOREIGN KEY (id_agendamento) REFERENCES AGENDAMENTO (id_agendamento),
    CONSTRAINT fk_item_servico     FOREIGN KEY (id_servico)     REFERENCES SERVICO (id_servico),
    CONSTRAINT ck_item_preco CHECK (preco_cobrado >= 0)
);

CREATE TABLE AVALIACAO (
    id_avaliacao   INT AUTO_INCREMENT PRIMARY KEY,
    nota           INT          NOT NULL,
    comentario     VARCHAR(255) NULL,
    data_avaliacao DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_agendamento INT NOT NULL UNIQUE,
    CONSTRAINT fk_aval_agendamento FOREIGN KEY (id_agendamento) REFERENCES AGENDAMENTO (id_agendamento),
    CONSTRAINT ck_aval_nota CHECK (nota BETWEEN 1 AND 5)
);

INSERT INTO CLIENTE (nome_completo, telefone, email, data_cadastro) VALUES
('Marcos Oliveira',   '11987650001', 'marcos@gmail.com',  '2026-01-10 09:00:00'),
('Lucas Ferreira',    '11987650002', 'lucas@hotmail.com', '2026-02-15 10:30:00'),
('Mateus Santos',     '11987650003', NULL,                '2026-03-05 14:00:00'),
('Rafael Almeida',    '11987650004', 'rafael@gmail.com',  '2026-04-20 16:45:00'),
('Pedro Henrique',    '11987650005', 'pedro@outlook.com', '2026-05-12 11:15:00'),
('Bruno Costa',       '11987650006', NULL,                '2026-06-01 08:30:00'),
('Carlos Eduardo',    '11987650007', 'carlos@gmail.com',  '2026-07-18 13:00:00');

INSERT INTO BARBEIRO (nome_completo, telefone, data_admissao, status_ativo) VALUES
('Andre Souza',   '11999990001', '2024-03-01 08:00:00', 1),
('Thiago Lima',   '11999990002', '2024-08-15 08:00:00', 1),
('Diego Ramos',   '11999990003', '2025-02-10 08:00:00', 1),
('Felipe Nunes',  '11999990004', '2023-11-05 08:00:00', 1);

INSERT INTO FORMA_PAGAMENTO (descricao) VALUES
('Dinheiro'), ('Pix'), ('Cartao de Credito'), ('Cartao de Debito');

INSERT INTO SERVICO (nome_servico, preco_padrao, tempo_estimado_min) VALUES
('Corte Masculino',   40.00, 30),
('Barba',             30.00, 20),
('Corte + Barba',     65.00, 50),
('Sobrancelha',       15.00, 10),
('Pigmentacao',       50.00, 40),
('Hidratacao',        35.00, 25);

INSERT INTO AGENDAMENTO (data_hora_agendamento, status_agendamento, id_cliente, id_barbeiro, id_forma_pagamento) VALUES
('2026-10-01 09:00:00', 'CONCLUIDO', 1, 1, 2),
('2026-10-02 10:00:00', 'CONCLUIDO', 2, 2, 3),
('2026-10-05 14:30:00', 'CONCLUIDO', 3, 1, 1),
('2026-10-08 16:00:00', 'CANCELADO', 4, 3, 2),
('2026-10-12 11:00:00', 'CONCLUIDO', 1, 2, 4),
('2026-10-15 15:00:00', 'CONCLUIDO', 5, 3, 2),
('2026-10-20 09:30:00', 'CONCLUIDO', 2, 1, 3),
('2026-10-25 17:00:00', 'AGENDADO',  6, 2, 2),
('2026-10-28 10:00:00', 'AGENDADO',  1, 1, 1),
('2026-10-30 13:00:00', 'AGENDADO',  5, 3, 3);

INSERT INTO ITEM_AGENDAMENTO (preco_cobrado, id_agendamento, id_servico) VALUES
(40.00, 1, 1), (30.00, 1, 2),
(65.00, 2, 3),
(40.00, 3, 1),
(40.00, 4, 1),
(30.00, 5, 2), (15.00, 5, 4),
(50.00, 6, 5), (40.00, 6, 1),
(60.00, 7, 3),
(40.00, 8, 1),
(35.00, 9, 6),
(65.00, 10, 3);

INSERT INTO AVALIACAO (nota, comentario, data_avaliacao, id_agendamento) VALUES
(5, 'Atendimento excelente!',          '2026-10-01 12:00:00', 1),
(4, 'Corte muito bom, voltarei.',      '2026-10-02 13:00:00', 2),
(3, 'Demorou um pouco para comecar.',  '2026-10-05 17:00:00', 3),
(5, 'Melhor barbeiro da cidade.',      '2026-10-12 13:00:00', 5),
(4, NULL,                              '2026-10-15 18:00:00', 6);
-- ---------------1-----------------
SELECT a.id_agendamento,
       a.data_hora_agendamento,
       c.nome_completo  AS cliente,
       b.nome_completo  AS barbeiro,
       fp.descricao     AS forma_pagamento,
       a.status_agendamento
FROM AGENDAMENTO a
INNER JOIN CLIENTE c          ON c.id_cliente = a.id_cliente
INNER JOIN BARBEIRO b         ON b.id_barbeiro = a.id_barbeiro
INNER JOIN FORMA_PAGAMENTO fp ON fp.id_forma_pagamento = a.id_forma_pagamento
ORDER BY a.data_hora_agendamento;
-- ---------------2------------------------
SELECT a.id_agendamento,
       c.nome_completo AS cliente,
       s.nome_servico,
       s.preco_padrao,
       i.preco_cobrado,
       (i.preco_cobrado - s.preco_padrao) AS diferenca
FROM ITEM_AGENDAMENTO i
INNER JOIN AGENDAMENTO a ON a.id_agendamento = i.id_agendamento
INNER JOIN CLIENTE c     ON c.id_cliente = a.id_cliente
INNER JOIN SERVICO s     ON s.id_servico = i.id_servico
ORDER BY a.id_agendamento;
-- --------------3----------------------
SELECT b.nome_completo AS barbeiro,
       a.status_agendamento,
       COUNT(*) AS total_agendamentos
FROM AGENDAMENTO a
INNER JOIN BARBEIRO b ON b.id_barbeiro = a.id_barbeiro
GROUP BY b.nome_completo, a.status_agendamento
ORDER BY b.nome_completo, total_agendamentos DESC;
-- --------------4---------------------
SELECT fp.descricao AS forma_pagamento,
       COUNT(DISTINCT a.id_agendamento) AS qtd_atendimentos,
       SUM(i.preco_cobrado)             AS faturamento_total
FROM FORMA_PAGAMENTO fp
INNER JOIN AGENDAMENTO a       ON a.id_forma_pagamento = fp.id_forma_pagamento
INNER JOIN ITEM_AGENDAMENTO i  ON i.id_agendamento = a.id_agendamento
WHERE a.status_agendamento = 'CONCLUIDO'
GROUP BY fp.descricao
ORDER BY faturamento_total DESC;
-- --------------5----------------------
SELECT b.nome_completo AS barbeiro,
       COUNT(av.id_avaliacao)  AS qtd_avaliacoes,
       ROUND(AVG(av.nota), 2)  AS nota_media
FROM BARBEIRO b
INNER JOIN AGENDAMENTO a ON a.id_barbeiro = b.id_barbeiro
INNER JOIN AVALIACAO av  ON av.id_agendamento = a.id_agendamento
GROUP BY b.nome_completo
HAVING AVG(av.nota) >= 4
ORDER BY nota_media DESC;
-- ---------------6---------------------
SELECT id_cliente, nome_completo, telefone, email
FROM CLIENTE
WHERE nome_completo LIKE 'Ma%'
   OR email LIKE '%@gmail.com'
ORDER BY nome_completo ASC;

-- ----------------7---------------------
SELECT a.id_agendamento,
       a.data_hora_agendamento,
       c.nome_completo AS cliente,
       a.status_agendamento
FROM AGENDAMENTO a
INNER JOIN CLIENTE c ON c.id_cliente = a.id_cliente
WHERE a.data_hora_agendamento BETWEEN '2026-10-10 00:00:00' AND '2026-10-25 23:59:59'
  AND a.status_agendamento <> 'CANCELADO'
ORDER BY a.data_hora_agendamento DESC;
-- ---------------8----------------------
SELECT s.nome_servico,
       COUNT(i.id_item)                AS vezes_vendido,
       COALESCE(SUM(i.preco_cobrado),0) AS receita
FROM SERVICO s
LEFT JOIN ITEM_AGENDAMENTO i ON i.id_servico = s.id_servico
GROUP BY s.id_servico, s.nome_servico
HAVING COUNT(i.id_item) >= 0
ORDER BY vezes_vendido DESC, receita DESC;

SET SQL_SAFE_UPDATES = 0;
-- ---------------9----------------------
UPDATE AGENDAMENTO
SET status_agendamento = 'CONCLUIDO'
WHERE id_agendamento = 8;

UPDATE SERVICO
SET preco_padrao = ROUND(preco_padrao * 1.10, 2)
WHERE preco_padrao < 40;

-- Conferindo o resultado
SELECT 'AGENDAMENTO' AS tabela,
       id_agendamento AS id,
       CONCAT('Status: ', status_agendamento) AS detalhe
FROM AGENDAMENTO
WHERE id_agendamento = 8
UNION ALL
SELECT 'SERVICO',
       id_servico,
       CONCAT(nome_servico, ' - R$ ', preco_padrao)
FROM SERVICO
ORDER BY tabela, id;
-- ---------------10---------------------
UPDATE BARBEIRO
SET status_ativo = 0
WHERE nome_completo = 'Felipe Nunes';

DELETE FROM AVALIACAO
WHERE nota <= 3;

SELECT 'BARBEIRO' AS tabela,
       id_barbeiro AS id,
       CONCAT(nome_completo, ' - ', IF(status_ativo = 1, 'Ativo', 'Inativo')) AS detalhe
FROM BARBEIRO
UNION ALL
SELECT 'AVALIACAO',
       id_avaliacao,
       CONCAT('Nota ', nota, IF(comentario IS NULL, '', CONCAT(' - ', comentario)))
FROM AVALIACAO
ORDER BY tabela, id;
-- -----------------------------

CREATE OR REPLACE VIEW vw_desempenho_barbeiros AS
SELECT b.id_barbeiro,
       b.nome_completo                                AS barbeiro,
       IF(b.status_ativo = 1, 'Ativo', 'Inativo')     AS situacao,
       COUNT(t.id_agendamento)                        AS atendimentos_concluidos,
       COALESCE(SUM(t.valor_total), 0)                AS faturamento_total,
       ROUND(COALESCE(AVG(t.valor_total), 0), 2)      AS ticket_medio,
       ROUND(AVG(av.nota), 2)                         AS nota_media
FROM BARBEIRO b
LEFT JOIN (
        SELECT a.id_agendamento,
               a.id_barbeiro,
               SUM(i.preco_cobrado) AS valor_total
        FROM AGENDAMENTO a
        INNER JOIN ITEM_AGENDAMENTO i ON i.id_agendamento = a.id_agendamento
        WHERE a.status_agendamento = 'CONCLUIDO'
        GROUP BY a.id_agendamento, a.id_barbeiro
     ) t ON t.id_barbeiro = b.id_barbeiro
LEFT JOIN AVALIACAO av ON av.id_agendamento = t.id_agendamento
GROUP BY b.id_barbeiro, b.nome_completo, b.status_ativo;
 
SELECT * FROM vw_desempenho_barbeiros
ORDER BY faturamento_total DESC;
-- -----------------------------------------
SELECT tabela, coluna, tipo, aceita_nulo, chave
FROM (
    
    SELECT TABLE_NAME AS ordem_tabela, 0 AS ordem_col,
           CONCAT('=== ', TABLE_NAME, ' ===') AS tabela,
           'COLUNA' AS coluna, 'TIPO' AS tipo, 'NULO?' AS aceita_nulo, 'CHAVE' AS chave
    FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = 'barbearia' AND TABLE_TYPE = 'BASE TABLE'

    UNION ALL

    SELECT c.TABLE_NAME, c.ORDINAL_POSITION, '', c.COLUMN_NAME, c.COLUMN_TYPE, c.IS_NULLABLE, c.COLUMN_KEY
    FROM information_schema.COLUMNS c
    INNER JOIN information_schema.TABLES t
            ON t.TABLE_SCHEMA = c.TABLE_SCHEMA AND t.TABLE_NAME = c.TABLE_NAME
    WHERE c.TABLE_SCHEMA = 'barbearia' AND t.TABLE_TYPE = 'BASE TABLE'

    UNION ALL

    SELECT TABLE_NAME, 999, '', '', '', '', ''
    FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = 'barbearia' AND TABLE_TYPE = 'BASE TABLE'
) estrutura
ORDER BY FIELD(ordem_tabela, 'CLIENTE', 'BARBEIRO', 'FORMA_PAGAMENTO', 'SERVICO',
               'AGENDAMENTO', 'ITEM_AGENDAMENTO', 'AVALIACAO'),
         ordem_col;