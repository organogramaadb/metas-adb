-- ================================================================
-- Novos KPIs, Centros de Custo e Vínculos CC × KPI
-- ================================================================

-- 1. Desativar KPI 3.09 agregado (substituído pelos 3 separados)
UPDATE public.kpis SET ativo = FALSE WHERE id = 'd7f1a000-0000-0000-0000-000000000309';
UPDATE public.kpi_responsaveis SET ativo = FALSE WHERE id_kpi = 'd7f1a000-0000-0000-0000-000000000309';

-- 2. Novos KPIs
INSERT INTO public.kpis (id, codigo, nome, nome_completo, area, ordem_exibicao)
VALUES ('d7f1a000-0000-0002-0000-000000000309', '3.09', 'KPI CAMPO CAT', '3.09 - KPI CAMPO CAT', 'AREA_PRODUTIVA', 15)
ON CONFLICT (nome_completo) DO NOTHING;
INSERT INTO public.kpis (id, codigo, nome, nome_completo, area, ordem_exibicao)
VALUES ('d7f1a000-0000-0000-0000-000000000311', '3.11', 'KPI CAMPO CE', '3.11 - KPI CAMPO CE', 'AREA_PRODUTIVA', 16)
ON CONFLICT (nome_completo) DO NOTHING;
INSERT INTO public.kpis (id, codigo, nome, nome_completo, area, ordem_exibicao)
VALUES ('d7f1a000-0000-0000-0000-000000000312', '3.12', 'KPI CAMPO INAJA', '3.12 - KPI CAMPO INAJA', 'AREA_PRODUTIVA', 17)
ON CONFLICT (nome_completo) DO NOTHING;
INSERT INTO public.kpis (id, codigo, nome, nome_completo, area, ordem_exibicao)
VALUES ('d7f1a000-0000-0000-0000-000000000405', '4.05', 'KPI ENERGIA', '4.05 - KPI ENERGIA', 'INVESTIMENTOS_SOCIAIS', 22)
ON CONFLICT (nome_completo) DO NOTHING;
INSERT INTO public.kpis (id, codigo, nome, nome_completo, area, ordem_exibicao)
VALUES ('d7f1a000-0000-0000-0000-000000000511', '5.11', 'KPI DESENVOLVIMENTO INSTITUCIONAL EVENTOS', '5.11 - KPI DESENVOLVIMENTO INSTITUCIONAL EVENTOS', 'PROGRAMAS_SOCIAIS', 29)
ON CONFLICT (nome_completo) DO NOTHING;
INSERT INTO public.kpis (id, codigo, nome, nome_completo, area, ordem_exibicao)
VALUES ('d7f1a000-0000-0000-0000-000000000512', '5.12', 'KPI ASSISTENCIA SOCIAL', '5.12 - KPI ASSISTENCIA SOCIAL', 'PROGRAMAS_SOCIAIS', 30)
ON CONFLICT (nome_completo) DO NOTHING;

-- Atualizar codigo KPI Obras SD para 4.02 (conforme arquivo CC)
UPDATE public.kpis SET codigo = '4.02', nome = 'KPI OBRAS E PROJETOS SD',
  nome_completo = '4.02 - KPI OBRAS E PROJETOS SD'
WHERE id = 'd7f1a000-0000-0001-0000-000000000401';

-- 3. kpi_responsaveis para novos KPIs
INSERT INTO public.kpi_responsaveis (id_kpi, responsavel, diretor)
VALUES ('d7f1a000-0000-0002-0000-000000000309', 'Paulo Souza', 'Alcione Albanesi')
ON CONFLICT (id_kpi, responsavel) DO NOTHING;
INSERT INTO public.kpi_responsaveis (id_kpi, responsavel, diretor)
VALUES ('d7f1a000-0000-0000-0000-000000000311', 'Aurora Dionisio', 'Alcione Albanesi')
ON CONFLICT (id_kpi, responsavel) DO NOTHING;
INSERT INTO public.kpi_responsaveis (id_kpi, responsavel, diretor)
VALUES ('d7f1a000-0000-0000-0000-000000000312', 'Diogo Siqueira', 'Alcione Albanesi')
ON CONFLICT (id_kpi, responsavel) DO NOTHING;
INSERT INTO public.kpi_responsaveis (id_kpi, responsavel, diretor)
VALUES ('d7f1a000-0000-0000-0000-000000000405', 'Sergio Tamassia', 'André de Luca')
ON CONFLICT (id_kpi, responsavel) DO NOTHING;
INSERT INTO public.kpi_responsaveis (id_kpi, responsavel, diretor)
VALUES ('d7f1a000-0000-0000-0000-000000000511', 'Alceu Caldeira', 'Alceu Caldeira')
ON CONFLICT (id_kpi, responsavel) DO NOTHING;
INSERT INTO public.kpi_responsaveis (id_kpi, responsavel, diretor)
VALUES ('d7f1a000-0000-0000-0000-000000000512', 'Aurora Dionisio', 'André de Luca')
ON CONFLICT (id_kpi, responsavel) DO NOTHING;
INSERT INTO public.kpi_responsaveis (id_kpi, responsavel, diretor)
VALUES ('d7f1a000-0000-0000-0000-000000000512', 'Diogo Siqueira', 'André de Luca')
ON CONFLICT (id_kpi, responsavel) DO NOTHING;
INSERT INTO public.kpi_responsaveis (id_kpi, responsavel, diretor)
VALUES ('d7f1a000-0000-0000-0000-000000000512', 'Mauriceia Rodrigues', 'André de Luca')
ON CONFLICT (id_kpi, responsavel) DO NOTHING;
INSERT INTO public.kpi_responsaveis (id_kpi, responsavel, diretor)
VALUES ('d7f1a000-0000-0000-0000-000000000512', 'Paulo Souza', 'André de Luca')
ON CONFLICT (id_kpi, responsavel) DO NOTHING;

-- 4. Importar centros_custo (148 analíticos)
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (3, '1.01.001', 'SP', 'ADMINISTRAÇÃO', 'Administracao Central - SP', 'A', '1.01',
   'CENTRAL SÃO PAULO', 'Daniel Benedetti', 'Usar para despesas e folha da estrutura corporativa da matriz em SP (governança, diretoria, reuniões, despesas gerais administrativas não atribuíveis a uma área específica). Serve para consolidar o custo “corporativo” e suportar orçamento/KPIs. Não usar para gastos de projetos, unidades do Sertão, produção, logística ou captação (esses têm CC próprios).', 'Fernando Medeiros', 'Daniel Benedetti', 'Daniel Benedetti', 'Ubiratan Reis')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (345, '1.01.007', 'SP', 'ADMINISTRAÇÃO', 'Juridico e Regulatorios', 'A', '1.01',
   'CENTRAL SÃO PAULO', 'Ubiratan Reis', 'Usar para despesas departamentais, despesas jurídicas, folha e operações, processos.', 'Fernando Medeiros', 'Ubiratan Reis', 'Ubiratan Reis', 'Ubiratan Reis')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (7, '1.01.002', 'SP', 'ADMINISTRAÇÃO', 'Recursos Humanos', 'A', '1.02',
   'CENTRAL SÃO PAULO', 'Gisele Carneiro', 'Usar para despesas e folha do RH (recrutamento, treinamento, benefícios corporativos, sistemas de RH, exames, ações internas). Serve para medir custo de gestão de pessoas e suportar KPIs do RH. Não usar para salários das áreas finalísticas (lançar no CC da área/unidade).', 'Fernando Medeiros', 'Luciana Feola', 'Gisele', 'Ubiratan Reis')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (280, '1.01.003', 'SP', 'ADMINISTRAÇÃO', 'Administracao Suprimentos', 'A', '1.03',
   'CENTRAL SÃO PAULO', 'Roberto Zambeli', 'Usar para despesas e folha da área de suprimentos/compras (equipe, sistemas, homologações, processos de compras, custos do departamento). Serve para medir eficiência do ciclo de compras e governança de fornecedores. Não usar para compras em si (lançar no CC demandante: obra, unidade, produção etc.).', 'Fernando Medeiros', 'Rosemary', 'Rosemary', 'Roberto Zambeli')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (281, '1.01.004', 'SP', 'ADMINISTRAÇÃO', 'Administracao Facilities', 'A', '1.04',
   'CENTRAL SÃO PAULO', 'Roberto Zambeli', 'Usar para despesas e folha de facilities corporativo em SP (manutenção predial, limpeza, segurança, utilidades, contratos prediais e infraestrutura física da central). Serve para consolidar custo de operação do prédio/estrutura. Não usar para manutenção das unidades do Sertão (há CC de manutenção por unidade).', 'Fernando Medeiros', 'Erick Poncio', 'Erick Poncio', 'Reginaldo Queiroz')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (307, '1.01.005', 'SP', 'ADMINISTRAÇÃO', 'Gestao Institucional Matriz', 'A', '1.01',
   'CENTRAL SÃO PAULO', 'Daniel Benedetti', 'Usar para custos ligados à gestão institucional/relacionamento institucional, governança e articulações da matriz (agendas institucionais, representações, despesas de suporte à alta gestão). Serve para evidenciar o custo de gestão institucional central. Não usar para captação (PF/PJ), marketing ou eventos (têm CC próprios).', 'Fernando Medeiros', 'Daniel Benedetti', 'Daniel Benedetti', 'Ubiratan Reis')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (336, '1.01.006', 'SP', 'ADMINISTRAÇÃO', 'Departamento Pessoal', 'A', '1.05',
   'CENTRAL SÃO PAULO', 'Vaga', 'Usar para custos do DP (processamento de folha, encargos operacionais do DP, sistemas e rotinas trabalhistas/benefícios na execução). Serve para medir custo operacional do DP e compliance trabalhista. Não usar para salário das áreas; aqui é custo do “departamento DP”, não o custo de pessoal das áreas.', 'Fernando Medeiros', 'Luciana Feola', 'Gisele', 'Ubiratan Reis')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (4, '1.04.001', 'SP', 'ADMINISTRAÇÃO', 'Financeiro - SP', 'A', '1.06',
   'CENTRAL SÃO PAULO', 'Daniel Benedetti', 'Usar para despesas e folha do Financeiro (contas a pagar/receber, tesouraria, bancos, tarifas bancárias do processo, rotinas financeiras). Serve para controlar custo do backoffice financeiro e KPI de eficiência. Não usar para impostos de unidades/projetos (lançar no CC correto da unidade/projeto).', 'Fernando Medeiros', 'Daniel Benedetti', 'Daniel Benedetti', 'Ubiratan Reis')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (282, '1.04.002', 'SP', 'ADMINISTRAÇÃO', 'Controladoria', 'A', '1.06',
   'CENTRAL SÃO PAULO', 'Daniel Benedetti', 'Usar para despesas e folha da Controladoria (orçamento, forecast, BI/relatórios gerenciais, normas de centros de custos, análises e controles internos). Serve para consolidar custo da função de controle e governança. Não usar para auditoria nem para despesas operacionais de áreas.', 'Fernando Medeiros', 'Daniel Benedetti', 'Daniel Benedetti', 'Ubiratan Reis')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (6, '1.05.001', 'SP', 'ADMINISTRAÇÃO', 'Informatica', 'A', '1.07',
   'CENTRAL SÃO PAULO', 'Alexandre Carrega', 'Usar para despesas e folha de TI (suporte, infraestrutura, licenças, sistemas, telecom, equipamentos de TI corporativos e contratos de tecnologia). Serve para consolidar custo de tecnologia e rateios quando aplicável. Não usar para equipamentos/softwares comprados exclusivamente para um projeto ou unidade (nesse caso, lançar no CC do projeto/unidade e justificar).', 'Fernando Medeiros', 'Rodrigo Amaral', 'Rodrigo Amaral', 'Alexandre Carrega')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (9, '1.06.001', 'SP', 'ADMINISTRAÇÃO', 'Marketing', 'A', '1.08',
   'CENTRAL SÃO PAULO', 'Thays Aiala', 'Usar para despesas e folha de marketing institucional e de comunicação (agência, criação, mídia, produção de conteúdo, materiais promocionais). Serve para medir investimento em comunicação e KPIs de campanhas. Não usar para despesas de captação (PF/PJ) quando forem custos comerciais diretos; nesses casos usar Desenvolvimento Institucional PF/PJ.', 'André de Luca', 'Thays Aiala', 'Thays Aiala', 'Alceu Caldeira')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (13, '2.01.001', 'CATIMBAU', 'PROGRAMAS SOCIAIS', 'Centro de Transformacao - CAT', 'A', '2.01',
   'CENTRO DE TRANSFORMAÇÃO - CAT', 'Alceu Caldeira', 'Usar para despesas e folha diretamente ligadas à operação do Centro de Transformação de Catimbau (educação/atividades, consumos locais, serviços e manutenção operacional específica do CT). Serve para medir custo por unidade CT e KPI Educação. Não usar para obras/reformas (usar CC de reformas/obras).', 'Alceu Caldeira', 'Mara Gardinali', 'Mara Gardinali', 'Renato Brito')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (15, '2.01.002', 'CEARA', 'PROGRAMAS SOCIAIS', 'Centro de Transformacao - CE', 'A', '2.01',
   'CENTRO DE TRANSFORMAÇÃO - CE', 'Alceu Caldeira', 'Mesmo conceito do CT, aplicado à unidade Ceará. Não usar para compras gerais da Cidade do Bem nem para produção.', 'Alceu Caldeira', 'Mara Gardinali', 'Mara Gardinali', 'Renato Brito')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (19, '2.01.004', 'TORROES', 'PROGRAMAS SOCIAIS', 'Centro de Transformacao - TORROES', 'A', '2.01',
   'CENTRO DE TRANSFORMAÇÃO - TORROES', 'Alceu Caldeira', 'Mesmo conceito do CT, aplicado à unidade Torrões. Evitar lançar despesas administrativas gerais (usar Administrativo - TORROES).', 'Alceu Caldeira', 'Mara Gardinali', 'Mara Gardinali', 'Renato Brito')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (17, '2.01.007', 'INAJA', 'PROGRAMAS SOCIAIS', 'Centro de Transformacao - INAJA', 'A', '2.01',
   'CENTRO DE TRANSFORMAÇÃO - INAJA', 'Alceu Caldeira', 'Mesmo conceito do CT, aplicado à unidade Inajá. Obras e ampliações devem ir para Reformas/Projetos.', 'Alceu Caldeira', 'Mara Gardinali', 'Mara Gardinali', 'Renato Brito')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (344, '2.01.008', 'S DOMINGOS', 'PROGRAMAS SOCIAIS', 'Centro de Transformacao - SD', 'A', '2.01',
   'CENTRO DE TRANSFORMAÇÃO - INAJA', 'Alceu Caldeira', 'Mesmo conceito do CT, aplicado à unidade Inajá. Obras e ampliações devem ir para Reformas/Projetos.', 'Alceu Caldeira', 'Mara Gardinali', 'Mara Gardinali', 'Renato Brito')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (14, '2.02.002', 'CEARA', 'PROGRAMAS SOCIAIS', 'Centro Educacional - CE', 'A', '2.01',
   'ESCOLA CEARA', 'Alceu Caldeira', 'Usar para despesas e folha do Centro Educacional/escola do Ceará (estrutura escolar, materiais pedagógicos locais, serviços e consumos da escola). Serve para custo por escola/unidade e KPI Educação. Não usar para bolsas ou projetos especiais.', 'Alceu Caldeira', 'Mara Gardinali', 'Mara Gardinali', 'Renato Brito')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (16, '2.02.003', 'INAJA', 'PROGRAMAS SOCIAIS', 'Centro Educacional - INAJA', 'A', '2.01',
   'ESCOLA INAJA', 'Alceu Caldeira', 'Mesmo conceito, aplicado à escola Inajá.', 'Alceu Caldeira', 'Mara Gardinali', 'Mara Gardinali', 'Renato Brito')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (18, '2.02.004', 'TORROES', 'PROGRAMAS SOCIAIS', 'Centro Educacional - TORROES', 'A', '2.01',
   'ESCOLA TORROES', 'Alceu Caldeira', 'Mesmo conceito, aplicado à escola Torrões.', 'Alceu Caldeira', 'Mara Gardinali', 'Mara Gardinali', 'Renato Brito')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (11, '2.02.005', 'SP', 'PROGRAMAS SOCIAIS', 'Gestao Educacional', 'A', '2.01',
   'CENTRAL SÃO PAULO', 'Alceu Caldeira', 'Usar para despesas e folha da gestão central de educação (coordenação pedagógica, padrões, treinamentos, planejamento educacional, equipe central). Serve para separar “gestão” de “execução nas unidades”. Não usar para custos diretos das escolas (lançar nos CC das escolas/CT).', 'Alceu Caldeira', 'Mara Gardinali', 'Mara Gardinali', 'Renato Brito')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (12, '2.02.006', 'CATIMBAU', 'PROGRAMAS SOCIAIS', 'Centro Educacional - CAT', 'A', '2.01',
   'ESCOLA CATIMBAU', 'Alceu Caldeira', 'Mesmo conceito, aplicado à escola Catimbau.', 'Alceu Caldeira', 'Mara Gardinali', 'Mara Gardinali', 'Renato Brito')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (343, '2.02.007', 'S DOMINGOS', 'PROGRAMAS SOCIAIS', 'Centro Educacional - SD', 'A', '2.01',
   'ESCOLA CATIMBAU', 'Alceu Caldeira', 'Mesmo conceito, aplicado à escola Catimbau.', 'Alceu Caldeira', 'Mara Gardinali', 'Mara Gardinali', 'Renato Brito')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (20, '2.03.001', 'CATIMBAU', 'PROGRAMAS SOCIAIS', 'Bolsa Faculdade - CAT', 'A', '4.03',
   'NÃO APLICÁVEL', 'Alceu Caldeira', 'Usar para despesas do programa de bolsas/apoio a universitários vinculados à base Catimbau (mensalidades, auxílios, taxas, suportes diretamente do programa). Serve para evidenciar gasto do programa e prestação de contas. Não usar para custos escolares (educação básica) nem para assistência social geral.', 'Alceu Caldeira', 'Mara Gardinali', 'Mara Gardinali', 'Alceu Caldeira')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (21, '2.03.002', 'CEARA', 'PROGRAMAS SOCIAIS', 'Bolsa Faculdade - CE', 'A', '4.03',
   'NÃO APLICÁVEL', 'Alceu Caldeira', 'Mesmo conceito, aplicado ao Ceará.', 'Alceu Caldeira', 'Mara Gardinali', 'Mara Gardinali', 'Alceu Caldeira')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (23, '2.03.003', 'INAJA', 'PROGRAMAS SOCIAIS', 'Bolsa Faculdade - INAJA', 'A', '4.03',
   'NÃO APLICÁVEL', 'Alceu Caldeira', 'Mesmo conceito, aplicado a Inajá.', 'Alceu Caldeira', 'Mara Gardinali', 'Mara Gardinali', 'Alceu Caldeira')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (22, '2.03.004', 'TORROES', 'PROGRAMAS SOCIAIS', 'Bolsa Faculdade - TORROES', 'A', '4.03',
   'NÃO APLICÁVEL', 'Alceu Caldeira', 'Mesmo conceito, aplicado a Torrões.', 'Alceu Caldeira', 'Mara Gardinali', 'Mara Gardinali', 'Alceu Caldeira')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (76, '3.01.001', 'CATIMBAU', 'ÁREA PRODUTIVA', 'Artesanato - CAT', 'A', '3.01',
   'CATIMBAU', 'Roberto Barroso', 'Usar para despesas e folha da produção de artesanato em Catimbau (insumos, manutenção de oficina, ferramentas, mão de obra produtiva quando não houver CC separado). Serve para medir custo e margem por linha produtiva. Não usar para vendas/expedição (usar Comercial/Expedição).', 'Fernando Medeiros', 'Tony', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (78, '3.01.002', 'INAJA', 'ÁREA PRODUTIVA', 'Artesanato - INAJA', 'A', '3.01',
   'INAJA', 'Roberto Barroso', 'Mesmo conceito, aplicado a Inajá.', 'Fernando Medeiros', 'Tony', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (79, '3.01.003', 'TORROES', 'ÁREA PRODUTIVA', 'Artesanato - TORROES', 'A', '3.01',
   'TORROES', 'Roberto Barroso', 'Mesmo conceito, aplicado a Torrões.', 'Fernando Medeiros', 'Tony', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (77, '3.01.004', 'CEARA', 'ÁREA PRODUTIVA', 'Artesanato - CE', 'A', '3.01',
   'CEARA', 'Roberto Barroso', 'Mesmo conceito, aplicado ao Ceará.', 'Fernando Medeiros', 'Tony', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (8, '3.03.001', 'SP', 'ÁREA PRODUTIVA', 'Comercial', 'A', '3.08',
   'CENTRAL SÃO PAULO', 'Fernando Sanches', 'Usar para despesas e folha do time comercial (vendas, promotores, comissões, viagens comerciais, materiais de apoio de vendas). Serve para medir custo comercial e KPI de receita. Não usar para marketing institucional (usar Marketing) nem para logística (usar Expedição/Logística).', 'Fernando Medeiros', 'Rosangela Nostório', 'Rogério Salles', 'Fernando Sanches')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (62, '3.05.001', 'CATIMBAU', 'ÁREA PRODUTIVA', 'Fabrica de Castanha - CAT', 'A', '3.01',
   'FÁBRICA DE CASTANHA - CAT', 'Roberto Barroso', 'Usar para despesas e folha da operação industrial de castanha em Catimbau (manutenção industrial, utilidades, insumos indiretos, serviços industriais). Serve para custo industrial por planta. Não usar para campo (caju) nem para comercial.', 'Fernando Medeiros', 'Regina Cabeça', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (63, '3.05.002', 'CEARA', 'ÁREA PRODUTIVA', 'Fabrica de Castanha - CE', 'A', '3.01',
   'FÁBRICA DE CASTANHA - CE', 'Roberto Barroso', 'Mesmo conceito, aplicado à planta do Ceará.', 'Fernando Medeiros', 'Regina Cabeça', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (301, '3.05.003', 'CATIMBAU', 'ÁREA PRODUTIVA', 'Mao de Obra Fabrica Castanha - CAT', 'A', '3.01',
   'FÁBRICA DE CASTANHA - CAT', 'Roberto Barroso', 'Usar exclusivamente para salários/encargos/benefícios da mão de obra direta da fábrica de castanha em Catimbau. Serve para separar MOD de demais custos industriais. Não usar para manutenção, materiais e serviços (usar o CC da fábrica).', 'Fernando Medeiros', 'Regina Cabeça', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (302, '3.05.004', 'CEARA', 'ÁREA PRODUTIVA', 'Mao de Obra Fabrica Castanha - CE', 'A', '3.01',
   'FÁBRICA DE CASTANHA - CE', 'Roberto Barroso', 'Mesmo conceito, aplicado à planta do Ceará.', 'Fernando Medeiros', 'Regina Cabeça', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (69, '3.06.001', 'CATIMBAU', 'ÁREA PRODUTIVA', 'Fabrica de Doces - CAT', 'A', '3.01',
   'FÁBRICA DE DOCES - CAT', 'Roberto Barroso', 'Usar para despesas e folha da operação de doces em Catimbau (custos industriais, manutenção, insumos indiretos). Serve para custo por planta/linha. Não usar para comercial ou distribuição.', 'Fernando Medeiros', 'Regina Cabeça', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (71, '3.06.002', 'TORROES', 'ÁREA PRODUTIVA', 'Fabrica de Pimenta - TORROES', 'A', '3.01',
   'FÁBRICA DE PIMENTA - TORROES', 'Roberto Barroso', 'Usar para despesas e folha da operação de pimenta em Torrões. Mesmo racional.', 'Fernando Medeiros', 'Regina Cabeça', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (303, '3.06.003', 'CATIMBAU', 'ÁREA PRODUTIVA', 'Mao de Obra Doces - CAT', 'A', '3.01',
   'FABRICA DE DOCES - CAT', 'Roberto Barroso', 'Usar exclusivamente para mão de obra direta de doces em Catimbau (salários/encargos/benefícios). Não misturar com materiais/serviços.', 'Fernando Medeiros', 'Regina Cabeça', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (304, '3.06.004', 'TORROES', 'ÁREA PRODUTIVA', 'Mao de Obra Pimenta - TORROES', 'A', '3.01',
   'FABRICA DE DOCES - CAT', 'Roberto Barroso', 'Usar exclusivamente para mão de obra direta de pimenta em Torrões.', 'Fernando Medeiros', 'Regina Cabeça', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (55, '3.07.001', 'SP', 'ÁREA PRODUTIVA', 'KITS CORPORATIVOS', 'A', '3.01',
   'EXPEDIÇÃO SÃO PAULO', 'Roberto Barroso', 'Usar para despesas e folha diretamente ligadas à operação de montagem/embalagem/logística interna do Kit Corporativo em SP (caixas, materiais de embalagem quando não forem estoque, mão de obra do processo, custos operacionais do setor). Serve para apurar custo do canal e margem. Não usar para Comercial (venda) nem para Expedição geral.', 'Fernando Medeiros', 'Regina Cabeça', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (165, '3.08.001', 'CATIMBAU', 'ÁREA PRODUTIVA', 'Oficina de Costura - CAT', 'A', '3.01',
   'OFICINA DE COSTURA - CAT', 'Roberto Barroso', 'Usar para despesas e folha da oficina de costura em Catimbau (insumos, manutenção de máquinas, ferramentas, mão de obra produtiva se aplicável). Serve para custo e produtividade por unidade. Não usar para comercial ou distribuição.', 'Fernando Medeiros', 'Tony', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (73, '3.08.002', 'CEARA', 'ÁREA PRODUTIVA', 'Oficina de Costura - CE', 'A', '3.01',
   'OFICINA DE COSTURA - CE', 'Roberto Barroso', 'Mesmo conceito, aplicado ao Ceará.', 'Fernando Medeiros', 'Tony', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (166, '3.08.003', 'INAJA', 'ÁREA PRODUTIVA', 'Oficina de Costura - INAJA', 'A', '3.01',
   'OFICINA DE COSTURA - INAJA', 'Roberto Barroso', 'Mesmo conceito, aplicado a Inajá.', 'Fernando Medeiros', 'Tony', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (74, '3.08.004', 'TORROES', 'ÁREA PRODUTIVA', 'Oficina de Costura - TORROES', 'A', '3.01',
   'OFICINA DE COSTURA - TORROES', 'Roberto Barroso', 'Mesmo conceito, aplicado a Torrões.', 'Fernando Medeiros', 'Tony', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (167, '3.08.005', 'CEARA', 'ÁREA PRODUTIVA', 'Oficina Morro Dourado - CE', 'A', '3.01',
   'OFICINA MORRO DOURADO - CE', 'Roberto Barroso', 'Usar para despesas e folha específicas da oficina Morro Dourado (Ceará), separando do restante da costura. Serve para controle local e KPI de produção.', 'Fernando Medeiros', 'Tony', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (60, '3.09.001', 'SP', 'ÁREA PRODUTIVA', 'Quiosque', 'A', '3.08',
   'NÃO APLICÁVEL', 'Fernando Sanches', 'Usar para despesas e folha relacionadas à operação do quiosque (ponto de venda físico, insumos operacionais, taxas do local, pequenas manutenções). Serve para apurar resultado do canal quiosque. Não usar para e-commerce ou expedição.', 'Fernando Medeiros', 'Rosangela Nostório', 'Rogério Salles', 'Fernando Sanches')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (220, '3.10.001', 'SP', 'ÁREA PRODUTIVA', 'E-Commerce', 'A', '3.08',
   'NÃO APLICÁVEL', 'Fernando Sanches', 'Usar para despesas e folha do canal e-commerce (plataforma, integrações, mídia/performance se for do canal, atendimento do e-commerce, antifraude/fees do canal). Serve para medir custo do canal digital e resultado. Não usar para expedição (usar Expedição Comercial).', 'Fernando Medeiros', 'Rosangela Nostório', 'Rogério Salles', 'Fernando Sanches')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (176, '3.11.001', 'SP', 'ÁREA PRODUTIVA', 'Expedicao Comercial', 'A', '3.03',
   'EXPEDIÇÃO SÃO PAULO', 'Edmilson Lima', 'Usar para despesas e folha da expedição em SP voltada ao comercial (embalagem operacional, mão de obra de separação/expedição, transportes do canal quando aplicável, consumos do CD SP para vendas). Serve para apurar custo logístico do canal. Não usar para custos industriais nem para distribuição social.', 'Fernando Medeiros', 'Edmilson Lima', 'Edmilson Lima', 'Fernando Medeiros')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (323, '3.11.002', 'SP', 'PROGRAMAS SOCIAIS', 'Centro de Distribuicao - SP', 'A', '3.03',
   'JBN', 'Reginaldo Queiroz', 'Usar para despesas e folha do CD SP (armazenagem, locação, manutenção, mão de obra do CD, utilidades e serviços do centro). Serve para consolidar custo de logística SP. Não usar para expedição comercial específica se você quiser separar canal (usar Expedição Comercial).', 'Fernando Medeiros', 'Edmilson Lima', 'Edmilson Lima', 'Fernando Medeiros')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (284, '3.12.001', 'SP', 'ÁREA PRODUTIVA', 'Administracao Produtivo', 'A', '3.04',
   'CENTRAL SÃO PAULO', 'Roberto Barroso', 'Usar para despesas e folha de gestão/coordenação da área produtiva (planejamento de produção, coordenação, engenharia de processo, custos gerais de gestão da produção). Serve para separar “gestão produtiva” da execução por fábrica/oficina. Não usar para custos diretos de produção (lançar nas fábricas/oficinas).', 'Fernando Medeiros', 'Regina Cabeça', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (292, '3.13.001', 'CATIMBAU', 'ÁREA PRODUTIVA', 'Casa do Mel - CAT', 'A', '3.01',
   'CASA DO MEL - CAT', 'Roberto Barroso', 'Usar para despesas e folha da operação do mel em Catimbau. Serve para custo e resultado da linha de mel. Não usar para campo nem para comercial.', 'Fernando Medeiros', 'Regina Cabeça', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (305, '3.13.002', 'CEARA', 'ÁREA PRODUTIVA', 'Casa do Mel - CE', 'A', '3.01',
   'CASA DO MEL - CE', 'Roberto Barroso', 'Despesas e folha da operação do mel no Ceará. Não usar para outras linhas produtivas.', 'Fernando Medeiros', 'Regina Cabeça', 'Thiago Rufino', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (82, '4.02.001', 'CATIMBAU', 'PROJETOS INVESTIMENTOS', 'Construcao de Novas Casas - CAT', 'A', '4.01',
   'LOCAIS DIVERSOS', 'Roberto Barroso', 'Usar para despesas diretamente vinculadas à construção de casas em Catimbau (materiais, serviços de obra, projetos, taxas diretamente do projeto). Serve para controle de orçamento de obra e capitalização quando aplicável. Não usar para manutenção (usar Manutenção Unidade) nem para reformas (usar Reformas e Ampliações).', 'Fernando Medeiros', 'Maria Fernanda', 'Alessandra Siqueira', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (84, '4.02.002', 'CEARA', 'PROJETOS INVESTIMENTOS', 'Construcao de Novas Casas - CE', 'A', '4.01',
   'LOCAIS DIVERSOS', 'Roberto Barroso', 'Mesmo conceito, aplicado ao Ceará.', 'Fernando Medeiros', 'Maria Fernanda', 'Alessandra Siqueira', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (85, '4.02.003', 'INAJA', 'PROJETOS INVESTIMENTOS', 'Construcao de Novas Casas - INAJA', 'A', '4.01',
   'LOCAIS DIVERSOS', 'Roberto Barroso', 'Mesmo conceito, aplicado a Inajá.', 'Fernando Medeiros', 'Maria Fernanda', 'Alessandra Siqueira', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (86, '4.02.004', 'TORROES', 'PROJETOS INVESTIMENTOS', 'Construcao de Novas Casas - TORROES', 'A', '4.01',
   'LOCAIS DIVERSOS', 'Roberto Barroso', 'Mesmo conceito, aplicado a Torrões.', 'Fernando Medeiros', 'Maria Fernanda', 'Alessandra Siqueira', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (96, '4.04.006', 'SP', 'PROJETOS INVESTIMENTOS', 'Jantar', 'A', '5.08',
   'NÃO APLICÁVEL', 'Alceu Caldeira', 'Usar para custos do evento “Jantar” (produção, fornecedores, espaço, alimentação, audiovisual, convidados, taxas), com objetivo de apurar custo do evento e vincular a captação/relacionamento. Não usar para marketing geral nem despesas recorrentes.', 'Fernando Medeiros', 'Mirlane Souza', 'Mirlane Souza', 'Alceu Caldeira')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (99, '4.04.007', 'SP', 'PROJETOS INVESTIMENTOS', 'Eventos', 'A', '5.08',
   'NÃO APLICÁVEL', 'Alceu Caldeira', 'Usar para eventos institucionais diversos (quando não houver CC específico como “Jantar”). Serve para consolidar e comparar custos de eventos. Não usar para despesas permanentes de marketing/comercial.', 'Fernando Medeiros', 'Mirlane Souza', 'Mirlane Souza', 'Alceu Caldeira')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (88, '4.08.001', 'CATIMBAU', 'PROJETOS INVESTIMENTOS', 'Projeto agua - CAT', 'A', '4.03',
   'LOCAIS DIVERSOS', 'Sergio Tamassia', 'Usar para despesas diretamente atribuíveis ao projeto de água em Catimbau (perfuração, manutenção de sistemas, materiais, serviços do projeto). Serve para prestação de contas e KPI do projeto. Não usar para despesas gerais da unidade.', 'Fernando Medeiros', 'Sergio Tamassia', 'Sergio Tamassia', 'Sergio Tamassia')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (89, '4.08.002', 'CEARA', 'PROJETOS INVESTIMENTOS', 'Projeto agua - CE', 'A', '4.03',
   'LOCAIS DIVERSOS', 'Sergio Tamassia', 'Mesmo conceito, aplicado ao Ceará.', 'Fernando Medeiros', 'Sergio Tamassia', 'Sergio Tamassia', 'Sergio Tamassia')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (90, '4.08.003', 'INAJA', 'PROJETOS INVESTIMENTOS', 'Projeto agua - INAJA', 'A', '4.03',
   'LOCAIS DIVERSOS', 'Sergio Tamassia', 'Mesmo conceito, aplicado a Inajá.', 'Fernando Medeiros', 'Sergio Tamassia', 'Sergio Tamassia', 'Sergio Tamassia')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (91, '4.08.004', 'TORROES', 'PROJETOS INVESTIMENTOS', 'Projeto agua - TORROES', 'A', '4.03',
   'LOCAIS DIVERSOS', 'Sergio Tamassia', 'Mesmo conceito, aplicado a Torrões.', 'Fernando Medeiros', 'Sergio Tamassia', 'Sergio Tamassia', 'Sergio Tamassia')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (170, '4.12.001', 'TORROES', 'PROGRAMAS SOCIAIS', 'Manutencao Unidade - TORROES', 'A', '5.02',
   'NÃO APLICÁVEL', 'Mauriceia Rodrigues', 'Usar para manutenção corretiva/preventiva e pequenas melhorias da unidade Torrões (materiais de manutenção, serviços, contratos locais). Serve para medir custo de manutenção por unidade. Não usar para obras/ampliações (usar Reformas/Projetos).', 'Fernando Medeiros', 'Mauriceia Rodrigues', 'Mauriceia Rodrigues', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (316, '4.12.002', 'CEARA', 'PROGRAMAS SOCIAIS', 'Manutencao Unidade - CE', 'A', '5.02',
   'NÃO APLICÁVEL', 'Aurora Dionisio', 'Mesmo conceito, aplicado ao Ceará.', 'Fernando Medeiros', 'Aurora Dionisio', 'Aurora Dionisio', 'Aurora Dionisio')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (317, '4.12.003', 'INAJA', 'PROGRAMAS SOCIAIS', 'Manutencao Unidade - INAJA', 'A', '5.02',
   'NÃO APLICÁVEL', 'Diogo Siqueira', 'Mesmo conceito, aplicado a Inajá.', 'Fernando Medeiros', 'Diogo Siqueira', 'Diogo Siqueira', 'Diogo Siqueira')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (318, '4.12.004', 'CATIMBAU', 'PROGRAMAS SOCIAIS', 'Manutencao Unidade - CAT', 'A', '5.02',
   'NÃO APLICÁVEL', 'Paulo Souza', 'Mesmo conceito, aplicado a Catimbau.', 'Fernando Medeiros', 'Paulo Souza', 'Paulo Souza', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (324, '4.13.002', 'CATIMBAU', 'PROGRAMAS SOCIAIS', 'Centro de Distribuicao - CAT', 'A', '3.03',
   'CD CAT', 'Reginaldo Queiroz', 'Usar para despesas e folha do CD de Catimbau (armazenagem, equipe, utilidades, equipamentos e manutenção do CD). Serve para apurar custo logístico por CD. Não usar para distribuição social (usar Distribuição - CAT) se você separa “armazenar” de “entregar”.', 'Fernando Medeiros', 'Moabe Siqueira', 'Reginaldo Queiroz', 'Reginaldo Queiroz')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (325, '4.13.003', 'CEARA', 'PROGRAMAS SOCIAIS', 'Centro de Distribuicao - CE', 'A', '3.03',
   'CD CE', 'Reginaldo Queiroz', 'Mesmo conceito, aplicado ao Ceará.', 'Fernando Medeiros', 'Devair / Aurora', 'Reginaldo Queiroz', 'Reginaldo Queiroz')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (326, '4.13.004', 'INAJA', 'PROGRAMAS SOCIAIS', 'Centro de Distribuicao - INAJA', 'A', '3.03',
   'CD INAJA', 'Reginaldo Queiroz', 'Mesmo conceito, aplicado a Inajá.', 'Fernando Medeiros', 'Diogo Siqueira', 'Reginaldo Queiroz', 'Reginaldo Queiroz')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (327, '4.13.005', 'TORROES', 'PROGRAMAS SOCIAIS', 'Centro de Distribuicao - TORROES', 'A', '3.03',
   'CD TORROES', 'Reginaldo Queiroz', 'Mesmo conceito, aplicado a Torrões.', 'Fernando Medeiros', 'Adriano Pereira', 'Reginaldo Queiroz', 'Reginaldo Queiroz')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (337, '3.12.002', 'SP', 'PROGRAMAS SOCIAIS', 'Operacoes e Planejamento Integrados', 'A', '3.03',
   'CD SÃO PAULO', 'Reginaldo Queiroz', 'Centro de Custo destinado para despesas da Gestão de Operações, quando a atividade não for esécífica de um local, geradas a pedido da Gestão de Operações.', 'Fernando Medeiros', 'Reginaldo Queiroz', 'Reginaldo Queiroz', 'Fernando Medeiros')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (160, '4.14.001', 'CATIMBAU', 'PROJETOS INVESTIMENTOS', 'Reformas e  Ampliacoes - CAT', 'A', '4.01',
   'NÃO APLICÁVEL', 'Roberto Barroso', 'Usar para reformas e ampliações (obras de melhoria, ampliação, adequações) em Catimbau. Serve para controle de CAPEX/obra e orçamento. Não usar para manutenção rotineira (usar Manutenção Unidade).', 'Fernando Medeiros', 'Maria Fernanda', 'Alessandra Siqueira', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (161, '4.14.002', 'CEARA', 'PROJETOS INVESTIMENTOS', 'Reformas e Ampliacoes - CE', 'A', '4.01',
   'NÃO APLICÁVEL', 'Roberto Barroso', 'Mesmo conceito, aplicado ao Ceará.', 'Fernando Medeiros', 'Maria Fernanda', 'Alessandra Siqueira', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (162, '4.14.003', 'INAJA', 'PROJETOS INVESTIMENTOS', 'Reformas e Ampliacoes - INAJA', 'A', '4.01',
   'NÃO APLICÁVEL', 'Roberto Barroso', 'Mesmo conceito, aplicado a Inajá.', 'Fernando Medeiros', 'Maria Fernanda', 'Alessandra Siqueira', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (163, '4.14.004', 'TORROES', 'PROJETOS INVESTIMENTOS', 'Reformas e Ampliacoes - TORROES', 'A', '4.01',
   'NÃO APLICÁVEL', 'Roberto Barroso', 'Mesmo conceito, aplicado a Torrões.', 'Fernando Medeiros', 'Maria Fernanda', 'Alessandra Siqueira', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (235, '4.14.005', 'SP', 'PROJETOS INVESTIMENTOS', 'Reformas e Ampliacoes Sao Paulo', 'A', '4.01',
   'NÃO APLICÁVEL', 'Roberto Barroso', 'Usar para reformas/ampliações e melhorias estruturais em SP (central, CDs, áreas SP). Serve para separar CAPEX SP do Sertão. Não usar para manutenção de facilities (usar Administração Facilities).', 'Fernando Medeiros', 'Maria Fernanda', 'Alessandra Siqueira', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (240, '4.14.007', 'TORROES', 'PROJETOS INVESTIMENTOS', 'Projeto Praca Digital - TORROES', 'A', '4.01',
   'PRAÇA DIGITAL TORROES', 'Roberto Barroso', 'Usar para custos de implantação/estrutura da Praça Digital em Torrões (obras, equipamentos, instalações). Serve para controle do projeto específico. Não usar para despesas operacionais do dia a dia da Praça (quando operação, usar CC Praça Digital Torrões).', 'Fernando Medeiros', 'Maria Fernanda', 'Alessandra Siqueira', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (328, '4.14.008', 'SP', 'PROJETOS INVESTIMENTOS', 'Gestao Obras, Reformas e Ampliacoes', 'A', '4.01',
   'CENTRAL SÃO PAULO', 'Roberto Barroso', 'Usar para custos da gestão central de obras (equipe, projetos, planejamento, deslocamentos técnicos, sistemas e apoio gerencial) quando não atribuíveis a uma obra específica. Serve para separar “gestão” de “execução” por unidade/projeto. Não usar para materiais/serviços da obra; isso vai no CC da obra/unidade.', 'Fernando Medeiros', 'Maria Fernanda', 'Alessandra Siqueira', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (215, '4.17.002', 'SP', 'PROJETOS INVESTIMENTOS', 'Acoes Emergenciais', 'A', '4.03',
   'NÃO APLICÁVEL', 'Mirlane Sousa', 'Usar para despesas emergenciais (ações pontuais e contingenciais) que exigem rastreabilidade. Serve para prestação e controle por evento. Não usar para despesas recorrentes das unidades.', 'Fernando Sanches', 'Mirlane Souza', 'Mirlane Souza', 'Alceu Caldeira')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (217, '4.18.001', 'CEARA', 'PROJETOS INVESTIMENTOS', 'Projeto Energia Solar - CE', 'A', '4.01',
   'LOCAIS DIVERSOS', 'Sergio Tamassia', 'Usar para custos de implantação do sistema de energia solar no Ceará (equipamentos, instalação, projetos, adequações). Serve para controle de CAPEX e payback do projeto. Não usar para manutenção elétrica rotineira (usar Manutenção).', 'Fernando Medeiros', 'Sergio Tamassia', 'Sergio Tamassia', 'Sergio Tamassia')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (218, '4.18.002', 'CATIMBAU', 'PROJETOS INVESTIMENTOS', 'Projeto Energia Solar - CAT', 'A', '4.01',
   'LOCAIS DIVERSOS', 'Sergio Tamassia', 'Mesmo conceito, aplicado a Catimbau.', 'Fernando Medeiros', 'Sergio Tamassia', 'Sergio Tamassia', 'Sergio Tamassia')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (230, '4.18.003', 'INAJA', 'PROJETOS INVESTIMENTOS', 'Projeto Energia Solar - Inaja', 'A', '4.01',
   'LOCAIS DIVERSOS', 'Sergio Tamassia', 'Mesmo conceito, aplicado a Inajá.', 'Fernando Medeiros', 'Sergio Tamassia', 'Sergio Tamassia', 'Sergio Tamassia')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (293, '4.18.004', 'TORROES', 'PROJETOS INVESTIMENTOS', 'Projeto Energia Solar - Torroes', 'A', '4.01',
   'NÃO APLICÁVEL', 'Sergio Tamassia', 'Mesmo conceito, aplicado a Torrões.', 'Fernando Medeiros', 'Sergio Tamassia', 'Sergio Tamassia', 'Sergio Tamassia')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (173, '4.23.001', 'CATIMBAU', 'PROJETOS INVESTIMENTOS', 'Projeto Galpao 1 e 2 Fabrica de Castanha - CAT', 'A', '4.01',
   'NÃO APLICÁVEL', 'Roberto Barroso', 'Usar para obra específica de ampliação/galpões da fábrica de castanha em Catimbau. Serve para controle do projeto de obra. Não usar para custos operacionais da fábrica (usar Fábrica Castanha).', 'Fernando Medeiros', 'Maria Fernanda', 'Alessandra Siqueira', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (262, '4.23.002', 'INAJA', 'PROJETOS INVESTIMENTOS', 'Projeto Biblioteca Inaja', 'A', '4.01',
   'NÃO APLICÁVEL', 'Roberto Barroso', 'Usar para custos do projeto biblioteca em Inajá (obra, instalação, equipamentos, implantação). Serve para rastreabilidade. Não usar para despesas escolares rotineiras.', 'Fernando Medeiros', 'Maria Fernanda', 'Alessandra Siqueira', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (277, '4.23.006', 'CATIMBAU', 'PROJETOS INVESTIMENTOS', 'Projeto Biblioteca - CAT', 'A', '4.01',
   'NÃO APLICÁVEL', 'Roberto Barroso', 'Mesmo conceito, aplicado a Catimbau.', 'Fernando Medeiros', 'Maria Fernanda', 'Alessandra Siqueira', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (286, '4.23.007', 'SP', 'ADMINISTRAÇÃO', 'Projeto Novo Galpao Central - SP', 'A', '4.01',
   'NÃO APLICÁVEL', 'Roberto Barroso', 'Usar para custos do novo galpão em SP (obra, instalações, equipamentos, serviços técnicos). Serve para controle de CAPEX SP/logística. Não usar para despesas do CD já em operação (usar CD SP).', 'Fernando Medeiros', 'Maria Fernanda', 'Alessandra Siqueira', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (279, '4.24.001', 'SAO DOMINGOS', 'PROJETOS INVESTIMENTOS', 'Projeto Novo Centro de Transformacao - PE', 'A', '4.01',
   'NÃO APLICÁVEL', 'Roberto Barroso', 'Usar para todos os custos do projeto de implantação do novo centro (terraplenagem, obra, projetos, licenças, serviços técnicos, materiais). Serve para rastrear investimento, orçamento e prestação futura. Não usar para custos operacionais do CT após iniciar operação (aí migra para Centro de Transformação da unidade).', 'Fernando Medeiros', 'Maria Fernanda', 'Alessandra Siqueira', 'Roberto Barroso')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (300, '4.25.001', 'SAO DOMINGOS', 'PROJETOS INVESTIMENTOS', 'PROJETO VALE', 'A', '4.03',
   'NÃO APLICÁVEL', 'Mirlane Sousa', 'Usar para despesas do projeto específico “Vale (São Domingos)” (ações, obras/implantação ou execução conforme escopo). Serve para rastreabilidade e prestação. Não usar para assistência social geral.', 'Fernando Sanches', 'Mirlane Souza', 'Mirlane Souza', 'Alceu Caldeira')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (25, '5.01.001', 'CATIMBAU', 'PROGRAMAS SOCIAIS', 'Administrativo - CAT', 'A', '5.01',
   'CIDADE DO BEM CATIMBAU', 'Paulo Souza', 'Usar para despesas e folha administrativas locais de Catimbau (administração da unidade, suporte, materiais administrativos, serviços gerais locais). Serve para separar “administração local” de programas e produção. Não usar para educação/saúde/distribuição (têm CC próprios).', 'Fernando Medeiros', 'Paulo Souza', 'Paulo Souza', 'Paulo Souza')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (26, '5.01.002', 'CEARA', 'PROGRAMAS SOCIAIS', 'Administrativo - CE', 'A', '5.01',
   'CIDADE DO BEM CEARÁ', 'Aurora Dionisio', 'Mesmo conceito, aplicado ao Ceará.', 'Fernando Medeiros', 'Aurora Dionisio', 'Aurora Dionisio', 'Aurora Dionisio')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (27, '5.01.003', 'INAJA', 'PROGRAMAS SOCIAIS', 'Administrativo - INAJA', 'A', '5.01',
   'CIDADE DO BEM INAJA', 'Diogo Siqueira', 'Mesmo conceito, aplicado a Inajá.', 'Fernando Medeiros', 'Diogo Siqueira', 'Diogo Siqueira', 'Diogo Siqueira')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (28, '5.01.004', 'TORROES', 'PROGRAMAS SOCIAIS', 'Administrativo - TORROES', 'A', '5.01',
   'CIDADE DO BEM TORROES', 'Mauriceia Rodrigues', 'Mesmo conceito, aplicado a Torrões.', 'Fernando Medeiros', 'Mauriceia Rodrigues', 'Mauriceia Rodrigues', 'Mauriceia Rodrigues')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (260, '5.01.005', 'CEARA', 'PROGRAMAS SOCIAIS', 'Centro de Empreendedorismo - CE', 'A', '5.02',
   'CIDADE DO BEM CEARÁ', 'Aurora Dionisio', 'Despesas do projeto de empreendedorismo', 'Fernando Medeiros', 'Kathia Cruz', 'Kathia Cruz', 'Kathia Cruz')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (269, '5.01.006', 'CEARA', 'PROGRAMAS SOCIAIS', 'Projeto Call Center Agrovila - CE', 'A', '4.03',
   'CENTRO DE SAÚDE CEARÁ', 'Roberto Barroso', 'Despesas do projeto Call Center', 'Fernando Medeiros', 'Sergio Tamassia', 'Sergio Tamassia', 'Sergio Tamassia')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (276, '5.01.007', 'CATIMBAU', 'PROGRAMAS SOCIAIS', 'Centro de Empreendedorismo -CAT', 'A', '5.02',
   'CIDADE DO BEM CATIMBAU', 'Paulo Souza', 'Despesas do projeto de empreendedorismo', 'Fernando Medeiros', 'Kathia Cruz', 'Kathia Cruz', 'Kathia Cruz')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (308, '5.01.008', 'CATIMBAU', 'PROGRAMAS SOCIAIS', 'Gestao Institucional Sertao', 'A', '5.01',
   'NÃO APLICÁVEL', 'Kathia Cruz', 'Usar para custos de coordenação/gestão institucional do Sertão (equipe de gestão, articulação entre unidades, despesas de gestão não atribuíveis a uma unidade específica). Serve para separar custo de gestão do custo de execução. Não usar para despesas locais (usar Administrativo da unidade).', 'André de Luca', 'Kathia Cruz', 'Kathia Cruz', 'Kathia Cruz')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (312, '5.01.009', 'CATIMBAU', 'PROGRAMAS SOCIAIS', 'Assistencia Social - CAT', 'A', '4.03',
   'NÃO APLICÁVEL', 'Kathia Cruz', 'Usar para despesas e folha de assistência social vinculadas à base Catimbau (atendimentos, ações sociais, materiais e serviços do programa). Serve para KPI de assistência social e prestação. Não usar para distribuição (usar Distribuição - CAT).', 'André de Luca', 'Kathia Cruz', 'Kathia Cruz', 'Kathia Cruz')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (313, '5.01.010', 'CEARA', 'PROGRAMAS SOCIAIS', 'Assistencia Social - CE', 'A', '4.03',
   'NÃO APLICÁVEL', 'Kathia Cruz', 'Mesmo conceito, aplicado ao Ceará.', 'André de Luca', 'Kathia Cruz', 'Kathia Cruz', 'Kathia Cruz')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (314, '5.01.011', 'INAJA', 'PROGRAMAS SOCIAIS', 'Assistencia Social - INAJA', 'A', '4.03',
   'NÃO APLICÁVEL', 'Kathia Cruz', 'Mesmo conceito, aplicado a Inajá.', 'André de Luca', 'Kathia Cruz', 'Kathia Cruz', 'Kathia Cruz')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (315, '5.01.012', 'TORROES', 'PROGRAMAS SOCIAIS', 'Assistencia Social - TORROES', 'A', '4.03',
   'NÃO APLICÁVEL', 'Kathia Cruz', 'Mesmo conceito, aplicado a Torrões.', 'André de Luca', 'Kathia Cruz', 'Kathia Cruz', 'Kathia Cruz')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (10, '5.02.001', 'SP', 'PROGRAMAS SOCIAIS', 'Central Doacoes', 'A', '5.1',
   'CENTRAL DE DOAÇÕES SÃO PAULO', 'Alexandre Lacorte', 'Usar para despesas e folha da central de doações em SP (triagem, recebimento, armazenagem inicial e gestão de doações na origem). Serve para medir custo de captação material/doações e KPI da central. Não usar para distribuição no Sertão (usar Distribuição/unidades).', 'Fernando Medeiros', 'Alexandre Lacorte', 'Alexandre Lacorte', 'Alexandre Lacorte')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (37, '5.02.002', 'SP', 'PROGRAMAS SOCIAIS', 'Gestao Distribuicao', 'A', '5.07',
   'NÃO APLICÁVEL', 'Kathia Cruz', 'Usar para despesas e folha da gestão central da distribuição (planejamento logístico, roteirização, coordenação da distribuição social). Serve para separar “gestão” de “execução” nas unidades. Não usar para custos de entrega local (usar Distribuição - unidade).', 'André de Luca', 'Kathia Cruz', 'Kathia Cruz', 'Kathia Cruz')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (98, '5.02.004', 'SP', 'PROGRAMAS SOCIAIS', 'Brinquedos', 'A', '4.03',
   'CENTRAL SÃO PAULO', 'Kathia Cruz', 'Usar para despesas relacionadas ao programa/gestão de brinquedos (compras específicas, logística dedicada, ações pontuais). Serve para rastrear esse escopo específico. Não usar para doações em geral.', 'André de Luca', 'Kathia Cruz', 'Kathia Cruz', 'Kathia Cruz')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (30, '5.03.001', 'CATIMBAU', 'PROGRAMAS SOCIAIS', 'Cidade do Bem - CAT', 'A', '5.02',
   'CIDADE DO BEM - CAT', 'Paulo Souza', 'Usar para despesas e folha da operação integrada da unidade Catimbau (estrutura da Cidade do Bem) quando o custo não for de um programa específico (educação/saúde/distribuição). Serve para consolidar custo da unidade. Não usar para custos específicos com CC próprio.', 'Fernando Medeiros', 'Paulo Souza', 'Paulo Souza', 'Paulo Souza')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (31, '5.03.002', 'CEARA', 'PROGRAMAS SOCIAIS', 'Cidade do Bem - CE', 'A', '5.02',
   'CIDADE DO BEM - CE', 'Aurora Dionisio', 'Mesmo conceito, aplicado ao Ceará.', 'Fernando Medeiros', 'Aurora Dionisio', 'Aurora Dionisio', 'Aurora Dionisio')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (32, '5.03.003', 'INAJA', 'PROGRAMAS SOCIAIS', 'Cidade do Bem - INAJA', 'A', '5.02',
   'CIDADE DO BEM - INAJA', 'Diogo Siqueira', 'Mesmo conceito, aplicado a Inajá.', 'Fernando Medeiros', 'Diogo Siqueira', 'Diogo Siqueira', 'Diogo Siqueira')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (33, '5.03.004', 'TORROES', 'PROGRAMAS SOCIAIS', 'Cidade do Bem - TORROES', 'A', '5.02',
   'CIDADE DO BEM - TORROES', 'Mauriceia Rodrigues', 'Mesmo conceito, aplicado a Torrões.', 'Fernando Medeiros', 'Mauriceia Rodrigues', 'Mauriceia Rodrigues', 'Mauriceia Rodrigues')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (34, '5.03.005', 'CATIMBAU', 'PROGRAMAS SOCIAIS', 'Vila do Bem - MALHADA GRANDE', 'A', '5.02',
   'VILA DO BEM - MALHADA GRANDE', 'Paulo Souza', 'Usar para despesas e folha da operação da Vila do Bem Malhada Grande (serviços locais, pequenas ações e consumos vinculados à vila). Serve para custo por localidade. Não usar para despesas gerais da unidade Catimbau.', 'Fernando Medeiros', 'Paulo Souza', 'Paulo Souza', 'Paulo Souza')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (35, '5.03.006', 'TORROES', 'PROGRAMAS SOCIAIS', 'Vila do Bem - XEXEU', 'A', '5.02',
   'VILA DO BEM - XEXEU', 'Mauriceia Rodrigues', 'Mesmo conceito, aplicado à Vila do Bem Xexeu.', 'Fernando Medeiros', 'Mauriceia Rodrigues', 'Mauriceia Rodrigues', 'Mauriceia Rodrigues')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (100, '5.04.001', 'SP', 'PROGRAMAS SOCIAIS', 'Campanha Sertao', 'A', '5.08',
   'NÃO APLICÁVEL', 'Filipe Dorneles', 'Usar para despesas de campanha específica “Sertão” (produção, comunicação, ações de campanha, materiais). Serve para apurar custo de campanha e retorno. Não usar para marketing institucional geral.', 'Fernando Medeiros', 'Mara Gardinali', 'Mara Gardinali', 'Alceu Caldeira')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (5, '5.04.002', 'SP', 'PROGRAMAS SOCIAIS', 'Desenvolvimento Institucional - Pessoa Fisica', 'A', '5.08',
   'CENTRAL SÃO PAULO', 'Filipe Dorneles', 'Usar para despesas e folha de captação e relacionamento com doadores PF (CRM, meios de pagamento, ações PF, atendimento, réguas e campanhas PF quando aplicável). Serve para KPI de captação PF. Não usar para marketing institucional amplo.', 'Fernando Medeiros', 'Filipe Dorneles', 'Filipe Dorneles', 'Fernando Medeiros')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (285, '5.04.003', 'SP', 'PROGRAMAS SOCIAIS', 'Desenvolvimento Institucional - Projetos', 'A', '5.08',
   'CENTRAL SÃO PAULO', 'Fernando Sanches', 'Usar para despesas e folha de captação/gestão de projetos e parcerias (propostas, prestações, desenvolvimento de projetos com financiadores). Serve para separar custos por “projetos/parcerias” do PF/PJ. Não usar para execução do projeto (usar o CC do projeto).', 'Fernando Medeiros', 'Mirlane Souza', 'Mirlane Souza', 'Fernando Sanches')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (306, '5.04.004', 'SP', 'PROGRAMAS SOCIAIS', 'Desenvolvimento Institucional - Pessoa Juridica', 'A', '5.08',
   'CENTRAL SÃO PAULO', 'Fernando Sanches', 'Usar para despesas e folha de captação e relacionamento com empresas (parcerias, propostas, visitas, contrapartidas institucionais). Serve para KPI de captação PJ. Não usar para comercial de produtos (usar Comercial).', 'Fernando Medeiros', 'Mirlane Souza', 'Mirlane Souza', 'Fernando Sanches')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (38, '5.05.002', 'CATIMBAU', 'PROGRAMAS SOCIAIS', 'Distribuicao - CAT', 'A', '5.07',
   'NÃO APLICÁVEL', 'Kathia Cruz', 'Usar para despesas e folha da distribuição social em Catimbau (logística de entrega, equipe de entrega, consumos da operação de distribuição). Serve para custo da entrega social. Não usar para armazenagem do CD (usar Centro de Distribuição - CAT).', 'André de Luca', 'Kathia Cruz', 'Kathia Cruz', 'Kathia Cruz')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (39, '5.05.003', 'CEARA', 'PROGRAMAS SOCIAIS', 'Distribuicao - CE', 'A', '5.07',
   'NÃO APLICÁVEL', 'Kathia Cruz', 'Mesmo conceito, aplicado ao Ceará.', 'André de Luca', 'Kathia Cruz', 'Kathia Cruz', 'Kathia Cruz')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (40, '5.05.004', 'INAJA', 'PROGRAMAS SOCIAIS', 'Distribuicao - INAJA', 'A', '5.07',
   'NÃO APLICÁVEL', 'Kathia Cruz', 'Mesmo conceito, aplicado a Inajá.', 'André de Luca', 'Kathia Cruz', 'Kathia Cruz', 'Kathia Cruz')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (41, '5.05.005', 'TORROES', 'PROGRAMAS SOCIAIS', 'Distribuicao - TORROES', 'A', '5.07',
   'NÃO APLICÁVEL', 'Kathia Cruz', 'Mesmo conceito, aplicado a Torrões.', 'André de Luca', 'Kathia Cruz', 'Kathia Cruz', 'Kathia Cruz')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (44, '5.06.001', 'CATIMBAU', 'PROGRAMAS SOCIAIS', 'Atendimento Medico - CAT', 'A', '5.04',
   'CIDADE DO BEM CATIMBAU', 'Maria Gonçalves', 'Usar para despesas e folha de atendimento médico em Catimbau (medicamentos, insumos, serviços médicos, manutenção específica da área de saúde). Serve para custo do atendimento médico por unidade. Não usar para odontologia (tem CC próprio).', 'André de Luca', 'Gestor da Unidade', 'Maria da Guia', 'Maria da Guia')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (45, '5.06.002', 'CEARA', 'PROGRAMAS SOCIAIS', 'Atendimento Medico - CE', 'A', '5.04',
   'CIDADE DO BEM CEARÁ', 'Maria Gonçalves', 'Mesmo conceito, aplicado ao Ceará.', 'André de Luca', 'Gestor da Unidade', 'Maria da Guia', 'Maria da Guia')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (46, '5.06.003', 'INAJA', 'PROGRAMAS SOCIAIS', 'Atendimento Medico - INAJA', 'A', '5.04',
   'CIDADE DO BEM INAJA', 'Maria Gonçalves', 'Mesmo conceito, aplicado a Inajá.', 'André de Luca', 'Gestor da Unidade', 'Maria da Guia', 'Maria da Guia')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (47, '5.06.004', 'TORROES', 'PROGRAMAS SOCIAIS', 'Atendimento Medico - TORROES', 'A', '5.04',
   'CIDADE DO BEM TORROES', 'Maria Gonçalves', 'Mesmo conceito, aplicado a Torrões.', 'André de Luca', 'Gestor da Unidade', 'Maria da Guia', 'Maria da Guia')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (49, '5.06.005', 'CATIMBAU', 'PROGRAMAS SOCIAIS', 'Atendimento Odontologico - CAT', 'A', '5.04',
   'CIDADE DO BEM CATIMBAU', 'Maria Gonçalves', 'Usar para despesas e folha de odontologia em Catimbau (insumos odontológicos, serviços, manutenção específica). Não usar para atendimento médico.', 'André de Luca', 'Gestor da Unidade', 'Maria da Guia', 'Maria da Guia')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (50, '5.06.006', 'CEARA', 'PROGRAMAS SOCIAIS', 'Atendimento Odontologico - CE', 'A', '5.04',
   'CIDADE DO BEM CEARÁ', 'Maria Gonçalves', 'Mesmo conceito, aplicado ao Ceará.', 'André de Luca', 'Gestor da Unidade', 'Maria da Guia', 'Maria da Guia')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (51, '5.06.007', 'INAJA', 'PROGRAMAS SOCIAIS', 'Atendimento Odontologico - INAJA', 'A', '5.04',
   'CIDADE DO BEM INAJA', 'Maria Gonçalves', 'Mesmo conceito, aplicado a Inajá.', 'André de Luca', 'Gestor da Unidade', 'Maria da Guia', 'Maria da Guia')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (52, '5.06.008', 'TORROES', 'PROGRAMAS SOCIAIS', 'Atendimento Odontologico - TORROES', 'A', '5.04',
   'CIDADE DO BEM TORROES', 'Maria Gonçalves', 'Mesmo conceito, aplicado a Torrões.', 'André de Luca', 'Gestor da Unidade', 'Maria da Guia', 'Maria da Guia')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (239, '5.06.009', 'SP', 'PROGRAMAS SOCIAIS', 'Gestao da Saude', 'A', '5.04',
   'CENTRAL SÃO PAULO', 'Maria Gonçalves', 'Usar para despesas e folha da coordenação/gestão central de saúde (protocolos, planejamento, contratos centralizados, indicadores). Serve para separar gestão de execução por unidade. Não usar para compra/consumo direto das unidades.', 'André de Luca', 'Gestor da Unidade', 'Maria da Guia', 'Maria da Guia')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (225, '5.07.001', 'CEARA', 'PROGRAMAS SOCIAIS', 'Praca Digital Agrovila - CE', 'A', '5.02',
   'CIDADE DO BEM CEARÁ', 'Aurora Dionisio', 'Usar para despesas e folha da operação da Praça Digital Agrovila (internet, equipamentos, manutenção, equipe local do projeto). Serve para custo por polo. Não usar para CT/escola.', 'Fernando Medeiros', 'Aurora Dionisio', 'Aurora Dionisio', 'Aurora Dionisio')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (226, '5.07.002', 'CEARA', 'PROGRAMAS SOCIAIS', 'Praca Digital Cajueiro - CE', 'A', '5.02',
   'CIDADE DO BEM CEARÁ', 'Aurora Dionisio', 'Mesmo conceito, aplicado ao polo Cajueiro.', 'Fernando Medeiros', 'Aurora Dionisio', 'Aurora Dionisio', 'Aurora Dionisio')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (227, '5.07.003', 'CATIMBAU', 'PROGRAMAS SOCIAIS', 'Praca Digital Catimbau - PE', 'A', '5.02',
   'CIDADE DO BEM CATIMBAU', 'Paulo Souza', 'Mesmo conceito, aplicado a Catimbau.', 'Fernando Medeiros', 'Paulo Souza', 'Paulo Souza', 'Paulo Souza')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (228, '5.07.004', 'TORROES', 'PROGRAMAS SOCIAIS', 'Praca Digital Torroes - AL', 'A', '5.02',
   'CIDADE DO BEM TORROES', 'Mauriceia Rodrigues', 'Mesmo conceito, aplicado a Torrões.', 'Fernando Medeiros', 'Mauriceia Rodrigues', 'Mauriceia Rodrigues', 'Mauriceia Rodrigues')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (267, '5.08.001', 'CEARA', 'PROGRAMAS SOCIAIS', 'Projeto Mudas - CE', 'A', '4.03',
   'CENTRO DE TRANSFORMAÇÃO CEARÁ', 'Aurora Dionisio', 'Usar para despesas e folha do projeto de mudas no Ceará (viveiro, insumos, equipe, logística do projeto). Serve para rastreabilidade e KPI do projeto. Não usar para campo do caju (CC Campo).', 'André de Luca', 'Kathia Cruz', 'Aurora Dionisio', 'Aurora Dionisio')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (268, '5.08.002', 'TORROES', 'PROGRAMAS SOCIAIS', 'Projeto Mudas - TORROES', 'A', '4.03',
   'CIDADE DO BEM TORROES', 'Mauriceia Rodrigues', 'Mesmo conceito, aplicado a Torrões.', 'André de Luca', 'Kathia Cruz', 'Mauriceia Rodrigues', 'Mauriceia Rodrigues')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (67, '5.08.003', 'CATIMBAU', 'PROGRAMAS SOCIAIS', 'Projeto Mudas - CAT', 'A', '4.03',
   'CIDADE DO BEM CATIMBAU', 'Paulo Souza', 'Mesmo conceito, aplicado a Catimbau.', 'André de Luca', 'Kathia Cruz', 'Paulo Souza', 'Paulo Souza')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (164, '5.08.004', 'INAJA', 'PROGRAMAS SOCIAIS', 'Projeto Mudas - Inaja', 'A', '4.03',
   'CIDADE DO BEM INAJA', 'Diogo Siqueira', 'Mesmo conceito, aplicado a Inajá.', 'André de Luca', 'Kathia Cruz', 'Diogo Siqueira', 'Diogo Siqueira')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (57, '5.09.001', 'SP', 'ÁREA PRODUTIVA', 'Bazar', 'A', '3.08',
   'BAZAR', 'Alexandre Lacorte', 'Usar para despesas e folha do bazar (operação, equipe, manutenção do espaço, consumos e taxas) e apuração do resultado do canal. Não usar para quiosque/e-commerce.', 'Fernando Medeiros', 'Alexandre Lacorte', 'Alexandre Lacorte', 'Alexandre Lacorte')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (58, '5.09.002', 'SP', 'ÁREA PRODUTIVA', 'Mini Emporio', 'A', '3.08',
   'BAZAR', 'Alexandre Lacorte', 'Usar para despesas e folha do mini empório (operação e apuração do resultado do canal). Não misturar com bazar se você quer DRE por canal.', 'Fernando Medeiros', 'Alexandre Lacorte', 'Alexandre Lacorte', 'Alexandre Lacorte')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (65, '5.10.001', 'CATIMBAU', 'ÁREA PRODUTIVA', 'Caju - CAT Campo', 'A', '3.09',
   'CAJU - CAT CAMPO', 'Paulo Souza', 'Usar para despesas e folha do campo/agro em Catimbau (insumos agrícolas, tratos culturais, colheita, serviços de campo, manutenção rural). Serve para custo por safra/unidade (KPI Campo). Não usar para fábrica (industrialização) nem para assistência social.', 'André de Luca', 'Kathia Cruz', 'Paulo Souza', 'Paulo Souza')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (66, '5.10.002', 'CEARA', 'ÁREA PRODUTIVA', 'Caju - CE Campo', 'A', '3.09',
   'CAJU - CE CAMPO', 'Aurora Dionisio', 'Mesmo conceito, aplicado ao Ceará.', 'André de Luca', 'Kathia Cruz', 'Aurora Dionisio', 'Aurora Dionisio')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (265, '5.10.003', 'INAJA', 'ÁREA PRODUTIVA', 'Campo Inaja - PE', 'A', '3.09',
   'CAMPO INAJA - PE', 'Diogo Siqueira', 'Usar para despesas e folha de campo/agro em Inajá (não necessariamente caju apenas, conforme operação local). Serve para separar agrícola de social/obras.', 'André de Luca', 'Kathia Cruz', 'Diogo Siqueira', 'Diogo Siqueira')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (331, '5.13.002', 'CATIMBAU', 'PROGRAMAS SOCIAIS', 'Frota - CAT', 'A', '5.05',
   'FROTA - CAT', 'Roberto Zambeli', 'Usar para despesas e folha da frota em Catimbau (manutenção, combustível quando centralizado, pneus, peças, licenciamento, serviços de oficina). Serve para custo de mobilidade por unidade. Não usar para viagens de equipe administrativa (reembolso tem natureza própria, mas CC depende do objetivo/área).', 'Fernando Medeiros', 'Gestor da Unidade', 'Eduardo Bahdour', 'Roberto Zambeli')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (333, '5.13.004', 'TORROES', 'PROGRAMAS SOCIAIS', 'Frota - TORROES', 'A', '5.05',
   'FROTA - TORROES', 'Roberto Zambeli', 'Mesmo conceito, aplicado a Torrões.', 'Fernando Medeiros', 'Gestor da Unidade', 'Eduardo Bahdour', 'Roberto Zambeli')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (334, '5.13.005', 'INAJA', 'PROGRAMAS SOCIAIS', 'Frota - INAJA', 'A', '5.05',
   'FROTA - INAJA', 'Roberto Zambeli', 'Mesmo conceito, aplicado a Inajá.', 'Fernando Medeiros', 'Gestor da Unidade', 'Eduardo Bahdour', 'Roberto Zambeli')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (332, '5.13.003', 'CEARA', 'PROGRAMAS SOCIAIS', 'Frota - CEARA', 'A', '5.05',
   'FROTA - CEARA', 'Roberto Zambeli', 'Mesmo conceito, aplicado ao Ceará.', 'Fernando Medeiros', 'Gestor da Unidade', 'Eduardo Bahdour', 'Roberto Zambeli')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (335, '5.13.006', 'SP', 'PROGRAMAS SOCIAIS', 'Frota - SP', 'A', '5.05',
   'FROTA - SP', 'Roberto Zambeli', 'Usar para despesas e folha da gestão central da frota (política, controles, rastreamento, contratos centralizados, planejamento, indicadores). Serve para separar “gestão” de “execução” das oficinas locais. Não usar para manutenção direta de veículos (usar Frota por unidade).', 'Fernando Medeiros', 'Gestor da Unidade', 'Eduardo Bahdour', 'Roberto Zambeli')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (338, '5.13.007', 'SAO DOMINGOS', 'PROGRAMAS SOCIAIS', 'Frota - Sao Domingos', 'A', '5.05',
   'FROTA - SD', 'Roberto Zambeli', 'Mesmo conceito, aplicado a São Domingos.', 'Fernando Medeiros', 'Gestor da Unidade', 'Eduardo Bahdour', 'Roberto Zambeli')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (329, '5.13.001', 'SP', 'PROGRAMAS SOCIAIS', 'Administracao de Frotas', 'A', '5.05',
   'FROTA - SP', 'Roberto Zambeli', 'Mesmo conceito, aplicado a São Domingos.', 'Fernando Medeiros', 'Eduardo Bahdour', 'Eduardo Bahdour', 'Roberto Zambeli')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;
INSERT INTO public.centros_custo
  (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg, setor_local,
   responsavel, objetivo, diretoria, requisitante1, requisitante2, requisitante3)
VALUES
  (310, '5.12.001', 'CATIMBAU', 'PROGRAMAS SOCIAIS', 'Auditoria Sertao', 'A', '5.01',
   'NÃO APLICÁVEL', 'Daniel Benedetti', 'Usar para despesas e folha da auditoria/controles internos voltados ao Sertão (auditorias, testes, deslocamentos de auditoria, ferramentas e rotinas de conformidade). Serve para consolidar custo de auditoria e rastreabilidade de apontamentos. Não usar para despesas operacionais das áreas auditadas.', 'Fernando Medeiros', 'Daniel Benedetti', 'Daniel Benedetti', 'Ubiratan Reis')
ON CONFLICT (codigo) DO UPDATE SET
  nome = EXCLUDED.nome, unidade = EXCLUDED.unidade,
  responsavel = EXCLUDED.responsavel, cd_grpg = EXCLUDED.cd_grpg;

-- 5. kpi_cc_vinculo — todos os CCs mapeados
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000101', 3, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000109', 345, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000102', 7, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000103', 280, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000104', 281, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000101', 307, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000105', 336, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000106', 4, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000106', 282, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000107', 6, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000108', 9, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000201', 13, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000201', 15, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000201', 19, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000201', 17, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000201', 344, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000201', 14, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000201', 16, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000201', 18, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000201', 11, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000201', 12, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000201', 343, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000201', 20, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000201', 21, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000201', 23, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000201', 22, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 76, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 78, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 79, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 77, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000308', 8, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 62, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 63, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 301, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 302, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 69, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 71, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 303, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 304, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 55, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 165, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 73, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 166, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 74, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 167, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000308', 60, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000308', 220, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000303', 176, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000404', 323, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 284, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 292, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000301', 305, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000401', 82, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000401', 84, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000401', 85, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000401', 86, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000511', 96, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000511', 99, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0001-0000-000000000403', 88, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0001-0000-000000000403', 89, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0001-0000-000000000403', 90, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0001-0000-000000000403', 91, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 170, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 316, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 317, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 318, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000404', 324, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000404', 325, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000404', 326, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000404', 327, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000404', 337, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000401', 160, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000401', 161, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000401', 162, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000401', 163, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000401', 235, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000401', 240, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000401', 328, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000507', 215, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000405', 217, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000405', 218, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000405', 230, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000405', 293, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000401', 173, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000401', 262, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000401', 277, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000401', 286, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0001-0000-000000000401', 279, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000507', 300, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 25, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 26, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 27, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 28, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 260, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000401', 269, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 276, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 308, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000507', 312, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000507', 313, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000507', 314, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000507', 315, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000510', 10, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000507', 37, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000507', 98, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 30, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 31, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 32, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 33, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 34, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 35, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000508', 100, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000508', 5, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000508', 285, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000508', 306, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000507', 38, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000507', 39, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000507', 40, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000507', 41, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000504', 44, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000504', 45, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000504', 46, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000504', 47, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000504', 49, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000504', 50, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000504', 51, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000504', 52, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000504', 239, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 225, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 226, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 227, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000502', 228, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000512', 267, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000512', 268, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000512', 67, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000512', 164, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000310', 57, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000310', 58, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0002-0000-000000000309', 65, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000311', 66, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000312', 265, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000505', 331, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000505', 333, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000505', 334, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000505', 332, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000505', 335, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000505', 338, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo)
VALUES ('d7f1a000-0000-0000-0000-000000000505', 329, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;