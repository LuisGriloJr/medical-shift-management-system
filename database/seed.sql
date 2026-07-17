USE fechamento_medico;


-- Médicos de teste
INSERT INTO medicos (
    nome,
    crm,
    observacoes
) VALUES
(
    'Dr. João da Silva',
    'CRM-SP 123456',
    NULL
),
(
    'Dra. Maria Oliveira',
    'CRM-SP 234567',
    NULL
),
(
    'Dr. Carlos Pereira',
    'CRM-SP 345678',
    'Realiza plantões de UTI e clínica médica.'
);


-- Locais e setores de teste
INSERT INTO locais_setores (
    cidade,
    tipo_atendimento,
    setor,
    observacoes
) VALUES
(
    'Cosmópolis',
    'SUS',
    'UTI',
    NULL
),
(
    'Cosmópolis',
    'SUS',
    'Clínico',
    NULL
),
(
    'Cosmópolis',
    'CONVENIO',
    'Clínico',
    NULL
),
(
    'Artur Nogueira',
    'SUS',
    'Pediatria PA',
    NULL
),
(
    'Monte Mor',
    'SUS',
    'Clínica Médica',
    NULL
);


-- Valores de plantão de teste
INSERT INTO valores_plantao (
    local_setor_id,
    tipo_calculo,
    valor,
    vigencia_inicio
) VALUES
(
    1,
    'POR_HORA',
    125.00,
    '2026-01-01'
),
(
    2,
    'POR_HORA',
    110.00,
    '2026-01-01'
),
(
    3,
    'POR_HORA',
    130.00,
    '2026-01-01'
),
(
    4,
    'POR_HORA',
    115.00,
    '2026-01-01'
),
(
    5,
    'POR_HORA',
    105.00,
    '2026-01-01'
);


-- Fechamento de teste
INSERT INTO fechamentos (
    local_setor_id,
    competencia,
    status,
    observacoes
) VALUES
(
    1,
    '2026-07-01',
    'ABERTO',
    'Fechamento de teste da UTI de Cosmópolis.'
);


-- Importação de teste
INSERT INTO importacoes (
    competencia,
    nome_arquivo_original,
    tipo_layout,
    status,
    total_registros,
    registros_importados,
    registros_com_erro,
    importado_em
) VALUES
(
    '2026-07-01',
    'escala_uti_cosmopolis_julho_2026.xlsx',
    'COSMOPOLIS_SUS',
    'CONCLUIDA',
    1,
    1,
    0,
    CURRENT_TIMESTAMP
);


-- Plantão de teste
INSERT INTO plantoes (
    fechamento_id,
    medico_id,
    local_setor_id,
    importacao_id,
    inicio,
    fim,
    tipo_calculo,
    horas_calculadas,
    valor_unitario_aplicado,
    valor_total,
    origem,
    status,
    linha_origem
) VALUES
(
    1,
    1,
    1,
    1,
    '2026-07-10 19:00:00',
    '2026-07-11 07:00:00',
    'POR_HORA',
    12.00,
    125.00,
    1500.00,
    'IMPORTACAO',
    'VALIDO',
    18
);