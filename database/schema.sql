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


    CREATE TABLE importacoes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,

    competencia DATE NOT NULL,

    nome_arquivo_original VARCHAR(255) NOT NULL,

    nome_arquivo_armazenado VARCHAR(255),

    caminho_arquivo VARCHAR(500),

    tipo_layout VARCHAR(100),

    status ENUM(
        'PENDENTE',
        'PROCESSANDO',
        'CONCLUIDA',
        'CONCLUIDA_COM_ERROS',
        'ERRO'
    ) NOT NULL DEFAULT 'PENDENTE',

    total_registros INT NOT NULL DEFAULT 0,

    registros_importados INT NOT NULL DEFAULT 0,

    registros_com_erro INT NOT NULL DEFAULT 0,

    mensagem_erro TEXT,

    importado_em DATETIME,

    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_importacao_totais
        CHECK (
            total_registros >= 0
            AND registros_importados >= 0
            AND registros_com_erro >= 0
        )
);

CREATE INDEX idx_importacoes_competencia
    ON importacoes (competencia);

CREATE INDEX idx_importacoes_status
    ON importacoes (status);

    CREATE TABLE plantoes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,

    fechamento_id BIGINT NOT NULL,

    medico_id BIGINT NOT NULL,

    local_setor_id BIGINT NOT NULL,

    importacao_id BIGINT,

    inicio DATETIME NOT NULL,

    fim DATETIME NOT NULL,

    tipo_calculo ENUM('POR_HORA', 'VALOR_FIXO')
        NOT NULL DEFAULT 'POR_HORA',

    horas_calculadas DECIMAL(8,2) NOT NULL DEFAULT 0,

    valor_unitario_aplicado DECIMAL(10,2) NOT NULL DEFAULT 0,

    valor_total DECIMAL(14,2) NOT NULL DEFAULT 0,

    origem ENUM('IMPORTACAO', 'MANUAL')
        NOT NULL DEFAULT 'IMPORTACAO',

    status ENUM(
        'PENDENTE',
        'VALIDO',
        'COM_INCONSISTENCIA',
        'CANCELADO'
    ) NOT NULL DEFAULT 'PENDENTE',

    linha_origem INT,

    observacoes TEXT,

    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    atualizado_em DATETIME
        NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_plantoes_fechamento
        FOREIGN KEY (fechamento_id)
        REFERENCES fechamentos(id),

    CONSTRAINT fk_plantoes_medico
        FOREIGN KEY (medico_id)
        REFERENCES medicos(id),

    CONSTRAINT fk_plantoes_local_setor
        FOREIGN KEY (local_setor_id)
        REFERENCES locais_setores(id),

    CONSTRAINT fk_plantoes_importacao
        FOREIGN KEY (importacao_id)
        REFERENCES importacoes(id),

    CONSTRAINT chk_plantao_periodo
        CHECK (fim > inicio),

    CONSTRAINT chk_plantao_horas
        CHECK (horas_calculadas >= 0),

    CONSTRAINT chk_plantao_valores
        CHECK (
            valor_unitario_aplicado >= 0
            AND valor_total >= 0
        )
);

CREATE INDEX idx_plantoes_fechamento
    ON plantoes (fechamento_id);

CREATE INDEX idx_plantoes_medico
    ON plantoes (medico_id);

CREATE INDEX idx_plantoes_local_setor
    ON plantoes (local_setor_id);

CREATE INDEX idx_plantoes_importacao
    ON plantoes (importacao_id);

CREATE INDEX idx_plantoes_periodo
    ON plantoes (inicio, fim);

CREATE INDEX idx_plantoes_medico_periodo
    ON plantoes (medico_id, inicio, fim);