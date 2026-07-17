CREATE DATABASE IF NOT EXISTS fechamento_medico
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE fechamento_medico;

CREATE TABLE medicos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    crm VARCHAR(30),
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uk_medicos_nome UNIQUE (nome)
);