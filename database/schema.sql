DROP DATABASE IF EXISTS fechamento_medico;

CREATE DATABASE fechamento_medico
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE fechamento_medico;


CREATE TABLE medicos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,

    nome VARCHAR(150) NOT NULL,

    crm VARCHAR(30),

    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    observacoes TEXT,

    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uk_medicos_nome
        UNIQUE (nome)
);


CREATE TABLE locais_setores (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,

    cidade VARCHAR(100) NOT NULL,

    tipo_atendimento ENUM('SUS', 'CONVENIO') NOT NULL,

    setor VARCHAR(120) NOT NULL,

    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    observacoes TEXT,

    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uk_local_setor
        UNIQUE (cidade, tipo_atendimento, setor)
);


CREATE TABLE valores_plantao (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,

    local_setor_id BIGINT NOT NULL,

    tipo_calculo ENUM('POR_HORA', 'VALOR_FIXO')
        NOT NULL DEFAULT 'POR_HORA',

    valor DECIMAL(10,2) NOT NULL,

    vigencia_inicio DATE NOT NULL,

    vigencia_fim DATE,

    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_valores_local_setor
        FOREIGN KEY (local_setor_id)
        REFERENCES locais_setores(id),

    CONSTRAINT chk_valor_positivo
        CHECK (valor >= 0),

    CONSTRAINT chk_vigencia
        CHECK (
            vigencia_fim IS NULL
            OR vigencia_fim >= vigencia_inicio
        )
);


CREATE INDEX idx_valores_local_setor
    ON valores_plantao (local_setor_id);

CREATE INDEX idx_valores_vigencia
    ON valores_plantao (vigencia_inicio, vigencia_fim);


CREATE TABLE fechamentos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,

    local_setor_id BIGINT NOT NULL,

    competencia DATE NOT NULL,

    status ENUM('ABERTO', 'EM_CONFERENCIA', 'FECHADO')
        NOT NULL DEFAULT 'ABERTO',

    total_horas DECIMAL(10,2) NOT NULL DEFAULT 0,

    total_valor DECIMAL(14,2) NOT NULL DEFAULT 0,

    fechado_em DATETIME,

    observacoes TEXT,

    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_fechamentos_local_setor
        FOREIGN KEY (local_setor_id)
        REFERENCES locais_setores(id),

    CONSTRAINT uk_fechamento_competencia
        UNIQUE (local_setor_id, competencia)
);


CREATE INDEX idx_fechamentos_competencia
    ON fechamentos (competencia);