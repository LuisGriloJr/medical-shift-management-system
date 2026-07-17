# Sistema de Gestão de Plantões Médicos

## Objetivo

Desenvolver um sistema para automatizar o processo de conferência e fechamento financeiro dos plantões médicos realizados em hospitais.

O sistema deverá importar escalas médicas em Excel, validar inconsistências automaticamente e gerar o fechamento financeiro dos médicos.

---

# Problema Atual

Atualmente o processo é realizado manualmente.

A auditoria envia:

* Escalas médicas em Excel;
* Fechamento financeiro em Excel.

O setor financeiro realiza a conferência comparando as escalas com as folhas físicas assinadas pelos médicos.

Esse processo demanda muito tempo e está sujeito a erros.

---

# Objetivos do Sistema

O sistema deverá:

* Cadastrar médicos;
* Cadastrar cidades;
* Cadastrar setores;
* Cadastrar valores por hora de cada setor;
* Importar escalas médicas em Excel;
* Calcular automaticamente a quantidade de horas trabalhadas;
* Calcular automaticamente o valor a receber;
* Detectar inconsistências;
* Gerar o fechamento financeiro;
* Exportar o fechamento para Excel.

---

# Regras de Negócio

## Médicos

* Um médico pode realizar vários plantões.
* Um plantão pode possuir mais de um médico (ex.: divisão de plantão de 12h em dois médicos de 6h).

## Plantões

* A maioria possui duração de 12 horas.
* Existem plantões de 6 horas.
* Existem plantões à distância em alguns setores.

## Pagamento

O pagamento depende de:

* Cidade;
* Setor.

O valor por hora é fixo para cada combinação Cidade + Setor.

## Validações

O sistema deverá identificar automaticamente:

* Médico realizando mais de 24 horas consecutivas;
* Médico escalado em dois locais no mesmo horário;
* Valores divergentes do cadastro;
* Escalas com informações incompletas.

---

# Cidades Atendidas

## Cosmópolis

### SUS

* Cirurgião Geral
* Vascular
* Ortopedia
* Enfermaria
* UTI
* Anestesia
* Ginecologia
* Pediatria
* Clínico
* Hemodiálise

### Convênio

* Clínico
* Clínico Extra
* Pediatria
* Hemodiálise

---

## Artur Nogueira

### SUS

* Ginecologia
* Pediatria Maternidade
* Anestesia
* Clínico
* Pediatria Pronto Atendimento
* Hemodiálise

---

## Monte Mor

### SUS

* Clínica Médica

---

# Relatórios

O sistema deverá gerar:

* Fechamento financeiro por médico;
* Fechamento por cidade;
* Fechamento por setor;
* Total de horas trabalhadas;
* Total financeiro.

---

# Tecnologias

## Backend

* Java
* Spring Boot

## Banco de Dados

* MySQL

## Frontend

* React

## Versionamento

* Git
* GitHub

---

# Objetivo Final

Eliminar praticamente todo o trabalho manual realizado durante o fechamento médico, permitindo que o financeiro apenas importe a escala e valide as inconsistências encontradas pelo sistema.
