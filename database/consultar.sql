USE fechamento_medico;


-- Listar médicos ativos
SELECT
    id,
    nome,
    crm,
    observacoes
FROM medicos
WHERE ativo = TRUE
ORDER BY nome;


-- Listar locais e setores ativos
SELECT
    id,
    cidade,
    tipo_atendimento,
    setor
FROM locais_setores
WHERE ativo = TRUE
ORDER BY cidade, tipo_atendimento, setor;


-- Listar valores vigentes atualmente
SELECT
    vp.id,
    ls.cidade,
    ls.tipo_atendimento,
    ls.setor,
    vp.tipo_calculo,
    vp.valor,
    vp.vigencia_inicio,
    vp.vigencia_fim
FROM valores_plantao vp
INNER JOIN locais_setores ls
    ON ls.id = vp.local_setor_id
WHERE vp.ativo = TRUE
  AND vp.vigencia_inicio <= CURRENT_DATE
  AND (
      vp.vigencia_fim IS NULL
      OR vp.vigencia_fim >= CURRENT_DATE
  )
ORDER BY ls.cidade, ls.setor;


-- Listar plantões com médico e local
SELECT
    p.id,
    m.nome AS medico,
    ls.cidade,
    ls.tipo_atendimento,
    ls.setor,
    p.inicio,
    p.fim,
    p.horas_calculadas,
    p.valor_unitario_aplicado,
    p.valor_total,
    p.origem,
    p.status
FROM plantoes p
INNER JOIN medicos m
    ON m.id = p.medico_id
INNER JOIN locais_setores ls
    ON ls.id = p.local_setor_id
ORDER BY p.inicio;


-- Total por médico
SELECT
    m.id,
    m.nome AS medico,
    SUM(p.horas_calculadas) AS total_horas,
    SUM(p.valor_total) AS total_valor
FROM plantoes p
INNER JOIN medicos m
    ON m.id = p.medico_id
WHERE p.status <> 'CANCELADO'
GROUP BY m.id, m.nome
ORDER BY m.nome;


-- Total por local e setor
SELECT
    ls.id,
    ls.cidade,
    ls.tipo_atendimento,
    ls.setor,
    SUM(p.horas_calculadas) AS total_horas,
    SUM(p.valor_total) AS total_valor
FROM plantoes p
INNER JOIN locais_setores ls
    ON ls.id = p.local_setor_id
WHERE p.status <> 'CANCELADO'
GROUP BY
    ls.id,
    ls.cidade,
    ls.tipo_atendimento,
    ls.setor
ORDER BY ls.cidade, ls.setor;


-- Inconsistências ainda não resolvidas
SELECT
    i.id,
    i.tipo,
    i.nivel,
    i.descricao,
    i.linha_origem,
    i.criado_em,
    p.id AS plantao_id,
    m.nome AS medico
FROM inconsistencias i
LEFT JOIN plantoes p
    ON p.id = i.plantao_id
LEFT JOIN medicos m
    ON m.id = p.medico_id
WHERE i.resolvida = FALSE
ORDER BY i.nivel DESC, i.criado_em;


-- Possíveis conflitos de horário
SELECT
    p1.medico_id,
    m.nome AS medico,
    p1.id AS plantao_1,
    p2.id AS plantao_2,
    p1.inicio AS inicio_1,
    p1.fim AS fim_1,
    p2.inicio AS inicio_2,
    p2.fim AS fim_2
FROM plantoes p1
INNER JOIN plantoes p2
    ON p1.medico_id = p2.medico_id
    AND p1.id < p2.id
    AND p1.inicio < p2.fim
    AND p1.fim > p2.inicio
INNER JOIN medicos m
    ON m.id = p1.medico_id
WHERE p1.status <> 'CANCELADO'
  AND p2.status <> 'CANCELADO';


-- Plantões individuais com mais de 24 horas
SELECT
    p.id,
    m.nome AS medico,
    p.inicio,
    p.fim,
    TIMESTAMPDIFF(MINUTE, p.inicio, p.fim) / 60 AS duracao_horas
FROM plantoes p
INNER JOIN medicos m
    ON m.id = p.medico_id
WHERE TIMESTAMPDIFF(MINUTE, p.inicio, p.fim) > 1440;