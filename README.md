# Projeto DIO — Integrando Dados com MySQL Azure e Transformando com Power BI

## Objetivo
Construir um fluxo de integração de dados usando MySQL e Power BI, realizando tratamento, limpeza, mesclagem e agregação dos dados de funcionários, departamentos e projetos.

> **Observação sobre a fonte:** a base utilizada neste estudo é uma implementação pública do Company/Employee Database de Elmasri & Navathe. Ela é compatível com as tabelas e transformações solicitadas no desafio da DIO, mas não foi apresentada aqui como o repositório oficial da DIO.

## Tecnologias
- MySQL
- Azure Database for MySQL — Flexible Server
- MySQL Workbench
- Power BI / Power Query
- GitHub

## Tabelas
- EMPLOYEE
- DEPARTMENT
- DEPT_LOCATIONS
- PROJECT
- WORKS_ON
- DEPENDENT

## Tratamentos realizados
1. Conferência de cabeçalhos e tipos.
2. Conversão de salário para tipo numérico decimal.
3. Verificação de nulos.
4. Identificação de colaboradores sem superior.
5. Verificação de departamentos sem gerente.
6. Conferência das horas dos projetos.
7. Separação de informações complexas.
8. Mesclagem de EMPLOYEE com DEPARTMENT.
9. Criação da coluna Nome a partir de nome e sobrenome.
10. Associação do nome do gerente por autojunção da tabela EMPLOYEE.
11. Combinação departamento + localização.
12. Agrupamento para quantidade de colaboradores por gerente.
13. Remoção de colunas que não são necessárias ao relatório.

## Resultado
Foram preparadas tabelas para consumo no Power BI:
- `Employee_Tratada`
- `Departamento_Local`
- `Horas_Projeto`
- `Colaboradores_por_Gerente`

## Importante
Os arquivos CSV/XLSX deste pacote permitem reproduzir a etapa de tratamento e construir o relatório no Power BI. A conexão real com Azure MySQL e o arquivo `.pbix` precisam ser feitos na conta/ambiente do usuário, pois o `.pbix` não é gerado neste pacote.

## Ideias para o dashboard
### Página 1 — Visão Geral
- Total de colaboradores
- Total de departamentos
- Total de projetos
- Total de horas trabalhadas

### Página 2 — Pessoas e Gestão
- Colaboradores por gerente
- Colaboradores por departamento
- Tabela com colaborador, departamento e gerente

### Página 3 — Projetos
- Horas por projeto
- Projeto x departamento
- Localização dos projetos

## Fonte da base
Repositório público utilizado como referência:
https://github.com/tolgahanakgun/Elmasri-Database
