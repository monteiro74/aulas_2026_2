- =======================================================
-- 1) CRIAÇÃO DO BANCO DE DADOS
-- =======================================================

-- Cria um banco de dados chamado "cafe"
IF DB_ID('cafe') IS NULL
    CREATE DATABASE cafe;
GO

-- O comando USE define qual banco será usado para os próximos comandos
USE cafe;
GO

-- =======================================================
-- 2) CRIAÇÃO DA TABELA ALUNOS
-- =======================================================

-- Cria a tabela "tblAlunos" com:
--  IdAluno   → chave primária, autoincremento (IDENTITY)
--  Nome      → nome do aluno
--  Aniversario → data de nascimento
--  Sexo      → 'M' ou 'F'
--  Salario   → salário decimal com 2 casas
IF OBJECT_ID('dbo.tblAlunos','U') IS NOT NULL DROP TABLE dbo.tblAlunos;
CREATE TABLE dbo.tblAlunos 
(
    IdAluno      INT IDENTITY(1,1) PRIMARY KEY NOT NULL,  -- Identity(1,1): inicia em 1 e incrementa de 1 em 1
    Nome         VARCHAR(100) NOT NULL,
    Aniversario  DATE NOT NULL,
    Sexo         VARCHAR(1) NOT NULL, -- M ou F
    Salario      DECIMAL(10,2) NOT NULL
);

-- Observações úteis:
--   DROP TABLE tblAlunos        → remove a tabela
--   ALTER TABLE DROP/ADD COLUMN → altera colunas
--   IDENTITY(seed, increment)   → gera valores automáticos
--   seed = valor inicial, increment = quanto aumenta

-- =======================================================
-- 3) INSERINDO DADOS NA TABELA ALUNOS
-- =======================================================

-- Ao inserir sem especificar colunas, é necessário seguir a ordem definida na criação da tabela
INSERT INTO dbo.tblAlunos VALUES ('ANA', '19971231', 'F', 5000);
INSERT INTO dbo.tblAlunos VALUES ('BOB', '19980522', 'M', 2500.50);
INSERT INTO dbo.tblAlunos VALUES ('BILL', '19950715', 'M', 3500.50);
INSERT INTO dbo.tblAlunos VALUES ('CLARA', '19810817', 'F', 4000.50);
INSERT INTO dbo.tblAlunos VALUES ('DANIEL', '20031125', 'M', 3500);
INSERT INTO dbo.tblAlunos VALUES ('DANIELA', '20031220', 'F', 5500);

-- Seleciona os 1000 primeiros registros (útil em bases grandes)
SELECT TOP (1000) [IdAluno], [Nome], [Aniversario], [Sexo], [Salario]
FROM dbo.tblAlunos;

-- Seleciona todos os registros da tabela Alunos
SELECT * FROM dbo.tblAlunos;

-- Exemplo (NÃO executar): inserir IdAluno manual em IDENTITY gera erro
-- INSERT INTO tblAlunos VALUES (2, 'DANIEL', '20031125', 'F', 3670);

-- =======================================================
-- 4) TABELA SITUAÇÃO (STATUS DO ALUNO)
-- =======================================================

IF OBJECT_ID('dbo.tblSituacao','U') IS NOT NULL DROP TABLE dbo.tblSituacao;
CREATE TABLE dbo.tblSituacao
(
    IdSituacao INT PRIMARY KEY NOT NULL, -- chave primária
    Situacao   VARCHAR(30) NOT NULL      -- descrição (matriculado, aprovado etc.)
);

-- Inserindo status de exemplo
INSERT INTO dbo.tblSituacao VALUES (1, 'MATRICULADO');
INSERT INTO dbo.tblSituacao VALUES (2, 'CURSANDO');
INSERT INTO dbo.tblSituacao VALUES (3, 'APROVADO');
INSERT INTO dbo.tblSituacao VALUES (4, 'REPROVADO');
INSERT INTO dbo.tblSituacao VALUES (5, 'SUSPENSO');
INSERT INTO dbo.tblSituacao VALUES (6, 'CANCELADO');

-- Consultar todos os status
SELECT * FROM dbo.tblSituacao;

-- =======================================================
-- 5) TABELA CURSOS
-- =======================================================

IF OBJECT_ID('dbo.tblCursos','U') IS NOT NULL DROP TABLE dbo.tblCursos;
CREATE TABLE dbo.tblCursos
(
    IdCurso   INT PRIMARY KEY NOT NULL,
    NomeCurso VARCHAR(50) NOT NULL
);

-- Inserindo cursos
INSERT INTO dbo.tblCursos VALUES (1, 'PROGRAMACAO C++');
INSERT INTO dbo.tblCursos VALUES (2, 'BANCO DE DADOS 1');
INSERT INTO dbo.tblCursos VALUES (3, 'SISTEMAS OPERACIONAIS');
INSERT INTO dbo.tblCursos VALUES (4, 'REDES 2');

-- Consultar cursos cadastrados
SELECT * FROM dbo.tblCursos;

-- =======================================================
-- 6) TABELA TURMAS
-- =======================================================

-- Cada turma está associada a um curso e a alunos
-- Inclui preço e datas de início/fim
IF OBJECT_ID('dbo.tblTurmas','U') IS NOT NULL DROP TABLE dbo.tblTurmas;
CREATE TABLE dbo.tblTurmas
(
    IdTurma        INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    IdAluno        INT NOT NULL,
    IdCurso        INT NOT NULL,
    DescricaoTurma VARCHAR(50) NOT NULL,
    PrecoTurma     NUMERIC(15,2) NOT NULL,
    DataInicio     DATE NOT NULL,
    DataFim        DATE NULL
);

-- Inserindo registros de exemplo (IdAluno=1 existe; IdCurso=1-3 existem)
INSERT INTO dbo.tblTurmas VALUES (1, 1, 'C++ DE FÉRIAS', 1250.50, '20231025', '20231029');
INSERT INTO dbo.tblTurmas VALUES (1, 2, 'C++ DE FÉRIAS', 1250.50, '20231025', '20231029');
INSERT INTO dbo.tblTurmas VALUES (1, 3, 'C++ DE FÉRIAS',    0.00 , '20231025', '20231029');

-- Consultar turmas
SELECT * FROM dbo.tblTurmas;

-- =======================================================
-- 7) TABELA PRESENÇAS
-- =======================================================

IF OBJECT_ID('dbo.tblPresencas','U') IS NOT NULL DROP TABLE dbo.tblPresencas;
CREATE TABLE dbo.tblPresencas
(
    IdTurma     INT NOT NULL,     -- FK para turma
    IdAluno     INT NOT NULL,     -- FK para aluno
    IdSituacao  INT NOT NULL,     -- FK para status
    DataPresenca DATE NOT NULL
);

-- Inserindo presenças de exemplo
INSERT INTO dbo.tblPresencas VALUES (1, 1, 2, '20231026');
INSERT INTO dbo.tblPresencas VALUES (1, 2, 2, '20231026');
INSERT INTO dbo.tblPresencas VALUES (1, 3, 2, '20231026');

-- =======================================================
-- 8) RELACIONAMENTOS (FOREIGN KEYS)
-- =======================================================

ALTER TABLE dbo.tblTurmas
  ADD CONSTRAINT fk_Turmas_Alunos  FOREIGN KEY (IdAluno) REFERENCES dbo.tblAlunos(IdAluno);

ALTER TABLE dbo.tblTurmas
  ADD CONSTRAINT fk_Turmas_Cursos  FOREIGN KEY (IdCurso) REFERENCES dbo.tblCursos(IdCurso);

ALTER TABLE dbo.tblPresencas
  ADD CONSTRAINT fk_Presenca_Turma FOREIGN KEY (IdTurma) REFERENCES dbo.tblTurmas(IdTurma);

ALTER TABLE dbo.tblPresencas
  ADD CONSTRAINT fk_Presenca_Aluno FOREIGN KEY (IdAluno) REFERENCES dbo.tblAlunos(IdAluno);

ALTER TABLE dbo.tblPresencas
  ADD CONSTRAINT fk_Presenca_Sit   FOREIGN KEY (IdSituacao) REFERENCES dbo.tblSituacao(IdSituacao);

-- =======================================================
-- 9) CONSULTAS AGREGADAS
-- =======================================================

-- Conta quantas turmas existem
SELECT COUNT(IdTurma) as qtdeTurma FROM dbo.tblTurmas;

-- Soma dos preços das turmas
SELECT SUM(PrecoTurma) AS somaPreco FROM dbo.tblTurmas;

-- Média dos salários dos alunos
SELECT AVG(Salario) AS mediaSalario FROM dbo.tblAlunos;

-- Valor máximo e mínimo de salários
SELECT MAX(Salario) AS maxSalario FROM dbo.tblAlunos;
SELECT MIN(Salario) AS minSalario FROM dbo.tblAlunos;

-- =======================================================
-- 10) TABELA PETS (EXERCÍCIO DE RELACIONAMENTO)
-- =======================================================

IF OBJECT_ID('dbo.tblPets','U') IS NOT NULL DROP TABLE dbo.tblPets;
CREATE TABLE dbo.tblPets
(
    IdPet   INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Apelido VARCHAR(50)     NOT NULL,
    Raca    VARCHAR(50)     NOT NULL,
    IdAluno INT             NULL,              -- FK para Alunos
    Valor   DECIMAL(18,2)   NULL               -- Preço/valor do pet
);

-- FK opcional para reforçar vínculo com alunos
ALTER TABLE dbo.tblPets
  ADD CONSTRAINT fk_Pets_Alunos FOREIGN KEY (IdAluno) REFERENCES dbo.tblAlunos(IdAluno);

-- Inserindo dados de exemplo
INSERT INTO dbo.tblPets (Apelido,Raca,IdAluno,Valor) VALUES('DOG1', 'MASTIN', 1 ,1500.00);
INSERT INTO dbo.tblPets (Apelido,Raca,IdAluno,Valor) VALUES('DOG2', 'FILA',   2 ,2500.00);
INSERT INTO dbo.tblPets (Apelido,Raca,IdAluno,Valor) VALUES('DOG3', 'BULDOGUE',3,3500.00);
INSERT INTO dbo.tblPets (Apelido,Raca,IdAluno,Valor) VALUES('CAT1', 'PERSA',  2 ,1800.00);
INSERT INTO dbo.tblPets (Apelido,Raca,IdAluno,Valor) VALUES('CAT2', 'ANGORA', 2 ,2300.00);
INSERT INTO dbo.tblPets (Apelido,Raca,IdAluno,Valor) VALUES('CAT3', 'SIAMES', 3 , 990.00);
-- Aqui omitimos IdAluno (permitido porque é NULL)
INSERT INTO dbo.tblPets (Apelido,Raca,Valor) VALUES('CAT4', 'SIAMES',1000.00);
INSERT INTO dbo.tblPets (Apelido,Raca,Valor) VALUES('DOG4', 'FILA', 2000.00);

-- =======================================================
-- 11) CONSULTAS COM JOIN E CÁLCULOS
-- =======================================================

-- Desconto de 10% no valor dos pets
SELECT Apelido, Raca, IdAluno AS Dono, Valor, (Valor*0.90) AS valorVendaAVista 
FROM dbo.tblPets;

-- Join de Pets com Alunos para mostrar dono (JOIN ANSI)
SELECT p.Apelido, p.Raca, p.Valor, a.Nome as Dono
FROM dbo.tblPets AS p
JOIN dbo.tblAlunos AS a ON p.IdAluno = a.IdAluno;

-- INNER JOIN (mostra só correspondências)
SELECT *
FROM dbo.tblAlunos a
INNER JOIN dbo.tblPets b ON a.IdAluno = b.IdAluno;

-- LEFT JOIN (mostra todos alunos, mesmo sem pet)
SELECT *
FROM dbo.tblAlunos a
LEFT JOIN dbo.tblPets b ON a.IdAluno = b.IdAluno;

-- FULL OUTER JOIN (mostra todos alunos e todos pets)
SELECT *
FROM dbo.tblAlunos a
FULL OUTER JOIN dbo.tblPets b ON a.IdAluno = b.IdAluno;

-- =======================================================
-- 12) AGRUPAMENTO, HAVING E ORDER
-- =======================================================

-- Média e quantidade de pets por raça
SELECT Raca, AVG(Valor) AS mediaPreco, COUNT(*) AS qtdeRaca
FROM dbo.tblPets
GROUP BY Raca
ORDER BY Raca;

-- Filtrar grupos com soma de valor > 1800
SELECT Raca, SUM(Valor) AS somaValor
FROM dbo.tblPets
GROUP BY Raca
HAVING SUM(Valor) > 1800
ORDER BY somaValor ASC;

-- =======================================================
-- 13) FUNÇÕES NUMÉRICAS E DE DATA
-- =======================================================

-- Exemplos de cálculos matemáticos
SELECT 500/2 AS valor;
SELECT POWER(2,2) AS valor;
SELECT SQRT(35) AS valor;
SELECT PI() AS valorPI;

-- Mostrar data e hora atual do servidor
SELECT GETDATE() AS data_hora_atual;

-- =======================================================
-- 14) VIEW, BACKUP E TRIGGER
-- =======================================================

-- Criação de uma VIEW para simplificar consultas (JOIN ANSI)
IF OBJECT_ID('dbo.minhaView','V') IS NOT NULL DROP VIEW dbo.minhaView;
GO
CREATE VIEW dbo.minhaView AS
SELECT p.Apelido, p.Raca, p.Valor, a.Nome as Dono
FROM dbo.tblPets AS p
JOIN dbo.tblAlunos AS a ON p.IdAluno = a.IdAluno;
GO

-- Backup de banco de dados (necessário permissões de sysadmin e caminho válido)
-- RECOMENDAÇÃO: manter comentado no script didático para não quebrar a execução.
-- BACKUP DATABASE cafe
-- TO DISK = 'D:\bd\backup\backup1.bak'
-- WITH INIT, STATS = 10;

-- Criar trigger para disparar mensagem quando houver alteração na tabela pets
IF OBJECT_ID('dbo.aviso','TR') IS NOT NULL DROP TRIGGER dbo.aviso;
GO
CREATE TRIGGER dbo.aviso
ON dbo.tblPets
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    RAISERROR ('Avisar o usuario', 16, 10);
END;
GO

-- Testar o trigger
INSERT INTO dbo.tblPets (Apelido,Raca,Valor) VALUES('DOG5', 'FILA', 2300.00);

-- =======================================================
-- 15) USUÁRIO/ROLE EXCLUSIVO PARA BACKUP DO BANCO "cafe"
-- =======================================================
-- Observação:
--  - Para gravar o arquivo .BAK, a conta do serviço do SQL Server
--    precisa ter permissão NTFS na pasta de destino.

USE master;
GO

-- 15.1) Criar LOGIN no servidor (substitua a senha por uma forte)
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'login_backup_cafe')
BEGIN
    CREATE LOGIN login_backup_cafe WITH PASSWORD = 'Troque_Esta_Senha!123', CHECK_POLICY = ON, CHECK_EXPIRATION = ON;
END
GO

-- 15.2) Criar USER no banco "cafe" para esse login
USE cafe;
GO
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'user_backup_cafe')
BEGIN
    CREATE USER user_backup_cafe FOR LOGIN login_backup_cafe;
END
GO

-- 15.3) Criar uma ROLE somente para backup e conceder permissões de BACKUP
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'db_backuponly')
BEGIN
    CREATE ROLE db_backuponly AUTHORIZATION dbo;
END
GO

-- Conceder apenas as permissões necessárias para backup neste banco
GRANT BACKUP DATABASE TO db_backuponly;
GRANT BACKUP LOG      TO db_backuponly;
GO

-- 15.4) Adicionar o usuário à role de backup
EXEC sp_addrolemember @rolename = N'db_backuponly', @membername = N'user_backup_cafe';
GO

-- 15.5) Exemplo de uso (mantenha comentado para evitar erro por caminho/permissão):
-- BACKUP DATABASE cafe TO DISK = 'D:\bd\backup\cafe_full_YYYYMMDD.bak' WITH INIT, STATS = 10;
-- BACKUP LOG cafe     TO DISK = 'D:\bd\backup\cafe_log_YYYYMMDD.trn'  WITH INIT, STATS = 10;
GO

-- =======================================================
-- 16) TAMANHO DO BANCO "cafe" (por arquivo e total)
-- =======================================================
USE master;
GO
SELECT
    d.name                                            AS database_name,
    mf.type_desc                                      AS file_type,
    SUM(mf.size) * 8.0 / 1024                         AS size_mb,
    SUM(mf.size) * 8.0 / 1024 / 1024                  AS size_gb
FROM sys.databases AS d
JOIN sys.master_files AS mf
    ON d.database_id = mf.database_id
WHERE d.name = N'cafe'
GROUP BY d.name, mf.type_desc
WITH ROLLUP;  -- a linha de ROLLUP mostra o total geral
GO

-- =======================================================
-- 17) TABELAS, COLUNAS E TIPOS DE DADOS (BANCO "cafe")
-- =======================================================
USE cafe;
GO
SELECT
    s.name                              AS schema_name,
    t.name                              AS table_name,
    c.column_id,
    c.name                              AS column_name,
    ty.name                             AS data_type,
    c.max_length,
    c.precision,
    c.scale,
    c.is_nullable,
    CASE WHEN ic.index_column_id IS NOT NULL THEN 1 ELSE 0 END AS is_indexed,
    CASE WHEN c.is_identity = 1 THEN 1 ELSE 0 END AS is_identity
FROM sys.tables t
JOIN sys.schemas s       ON s.schema_id = t.schema_id
JOIN sys.columns c       ON c.object_id = t.object_id
JOIN sys.types ty        ON ty.user_type_id = c.user_type_id
LEFT JOIN sys.indexes i  ON i.object_id = t.object_id AND i.is_hypothetical = 0
LEFT JOIN sys.index_columns ic
    ON ic.object_id = t.object_id AND ic.column_id = c.column_id AND ic.index_id = i.index_id
WHERE t.is_ms_shipped = 0
ORDER BY s.name, t.name, c.column_id;
GO

-- =======================================================
-- 18) RECURSOS: CPU, MEMÓRIA E DISCO (versões globais e "safe")
-- =======================================================

-- 18.1) CPU por banco (global)
USE master;
GO
SELECT
    DB_NAME(st.dbid)                                            AS database_name,
    SUM(qs.total_worker_time) / 1000.0                          AS total_cpu_ms,
    SUM(qs.execution_count)                                     AS exec_count,
    (SUM(qs.total_worker_time) / NULLIF(SUM(qs.execution_count),0)) / 1000.0 AS avg_cpu_ms_per_exec
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
WHERE st.dbid IS NOT NULL
GROUP BY DB_NAME(st.dbid)
ORDER BY total_cpu_ms DESC;
GO

-- 18.2) Memória (Buffer Pool) por banco (global)
SELECT
    DB_NAME(database_id)                 AS database_name,
    COUNT(*) * 8.0 / 1024                AS buffer_pool_mb
FROM sys.dm_os_buffer_descriptors
WHERE database_id <> 32767
GROUP BY database_id
ORDER BY buffer_pool_mb DESC;
GO

-- 18.3) Disco (I/O) por banco/arquivo (global)
SELECT
    DB_NAME(mf.database_id)                          AS database_name,
    mf.type_desc                                     AS file_type,
    mf.physical_name,
    vfs.num_of_reads,
    vfs.num_of_writes,
    vfs.num_of_bytes_read,
    vfs.num_of_bytes_written,
    CASE WHEN (vfs.num_of_reads) = 0 THEN 0
         ELSE (vfs.io_stall_read_ms * 1.0 / vfs.num_of_reads) END  AS avg_read_ms,
    CASE WHEN (vfs.num_of_writes) = 0 THEN 0
         ELSE (vfs.io_stall_write_ms * 1.0 / vfs.num_of_writes) END AS avg_write_ms
FROM sys.dm_io_virtual_file_stats(NULL,NULL) AS vfs
JOIN sys.master_files AS mf
  ON mf.database_id = vfs.database_id AND mf.file_id = vfs.file_id
ORDER BY database_name, file_type;
GO

-- 18A) Versões “safe” (apenas o banco cafe)
-- CPU SOMENTE DO BANCO "cafe"
SELECT
    DB_NAME(st.dbid) AS database_name,
    SUM(qs.total_worker_time) / 1000.0 AS total_cpu_ms,
    SUM(qs.execution_count)            AS exec_count,
    (SUM(qs.total_worker_time) / NULLIF(SUM(qs.execution_count),0)) / 1000.0 AS avg_cpu_ms_per_exec
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
WHERE st.dbid = DB_ID(N'cafe')
GROUP BY DB_NAME(st.dbid)
ORDER BY total_cpu_ms DESC;

-- MEMÓRIA (BUFFER POOL) SOMENTE "cafe"
SELECT
    DB_NAME(database_id)  AS database_name,
    COUNT(*) * 8.0 / 1024 AS buffer_pool_mb
FROM sys.dm_os_buffer_descriptors
WHERE database_id = DB_ID(N'cafe')
GROUP BY database_id
ORDER BY buffer_pool_mb DESC;

-- DISCO (I/O) SOMENTE "cafe"
SELECT
    DB_NAME(mf.database_id) AS database_name,
    mf.type_desc            AS file_type,
    mf.physical_name,
    vfs.num_of_reads,
    vfs.num_of_writes,
    vfs.num_of_bytes_read,
    vfs.num_of_bytes_written,
    CASE WHEN vfs.num_of_reads  = 0 THEN 0 ELSE (vfs.io_stall_read_ms  * 1.0 / vfs.num_of_reads)  END AS avg_read_ms,
    CASE WHEN vfs.num_of_writes = 0 THEN 0 ELSE (vfs.io_stall_write_ms * 1.0 / vfs.num_of_writes) END AS avg_write_ms
FROM sys.dm_io_virtual_file_stats(DB_ID(N'cafe'), NULL) AS vfs
JOIN sys.master_files AS mf
  ON mf.database_id = vfs.database_id AND mf.file_id = vfs.file_id
ORDER BY file_type, mf.physical_name;
GO