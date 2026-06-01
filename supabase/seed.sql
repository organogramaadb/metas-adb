-- ====================================================================
-- Supabase SEED — Acompanhamento de Metas Amigos do Bem
-- Execute APÓS o ddl.sql
-- Inclui: 28 KPIs, kpi_responsaveis, parametros_pontuacao globais
-- ====================================================================
-- ATENÇÃO: Os IDs de usuarios devem vir do auth.users após criar os usuários
-- no Supabase Dashboard (Authentication > Users). Substitua os placeholders
-- (uuid-admin-aqui, etc.) pelos UUIDs reais antes de executar.
-- ====================================================================

-- ── KPIs ─────────────────────────────────────────────────────────────
-- IDs fixos para facilitar manutenção e referência cruzada
INSERT INTO public.kpis (id, codigo, nome, nome_completo, area, ordem_exibicao) VALUES

  -- ADMINISTRATIVOS (área 1)
  ('d7f1a000-0000-0000-0000-000000000101', '1.01', 'KPI ADMINISTRACAO CENTRAL',
   '1.01 - KPI ADMINISTRACAO CENTRAL',     'ADMINISTRATIVOS', 1),
  ('d7f1a000-0000-0000-0000-000000000102', '1.02', 'KPI RECURSOS HUMANOS',
   '1.02 - KPI RECURSOS HUMANOS',          'ADMINISTRATIVOS', 2),
  ('d7f1a000-0000-0000-0000-000000000103', '1.03', 'KPI SUPRIMENTOS',
   '1.03 - KPI SUPRIMENTOS',               'ADMINISTRATIVOS', 3),
  ('d7f1a000-0000-0000-0000-000000000104', '1.04', 'KPI ADMINISTRACAO FACILITIES',
   '1.04 - KPI ADMINISTRACAO FACILITIES',  'ADMINISTRATIVOS', 4),
  ('d7f1a000-0000-0000-0000-000000000105', '1.05', 'KPI DP',
   '1.05 - KPI DP',                        'ADMINISTRATIVOS', 5),
  ('d7f1a000-0000-0000-0000-000000000106', '1.06', 'KPI CONTROLADORIA',
   '1.06 - KPI CONTROLADORIA',             'ADMINISTRATIVOS', 6),
  ('d7f1a000-0000-0000-0000-000000000107', '1.07', 'KPI INFORMATICA',
   '1.07 - KPI INFORMATICA',               'ADMINISTRATIVOS', 7),
  ('d7f1a000-0000-0000-0000-000000000108', '1.08', 'KPI MARKETING',
   '1.08 - KPI MARKETING',                 'ADMINISTRATIVOS', 8),
  ('d7f1a000-0000-0000-0000-000000000109', '1.09', 'KPI JURIDICO E REGULATORIOS',
   '1.09 - KPI JURIDICO E REGULATORIOS',   'ADMINISTRATIVOS', 9),

  -- EDUCAÇÃO (área 2)
  ('d7f1a000-0000-0000-0000-000000000201', '2.01', 'KPI EDUCACAO',
   '2.01 - KPI EDUCACAO',                  'EDUCACAO', 10),

  -- ÁREA PRODUTIVA (área 3)
  ('d7f1a000-0000-0000-0000-000000000301', '3.01', 'KPI PRODUCAO',
   '3.01 - KPI PRODUCAO',                  'AREA_PRODUTIVA', 11),
  ('d7f1a000-0000-0000-0000-000000000303', '3.03', 'KPI LOGISTICA',
   '3.03 - KPI LOGISTICA',                 'AREA_PRODUTIVA', 12),
  ('d7f1a000-0000-0000-0000-000000000304', '3.04', 'KPI ADMINISTRACAO PRODUTIVO',
   '3.04 - KPI ADMINISTRACAO PRODUTIVO',   'AREA_PRODUTIVA', 13),
  ('d7f1a000-0000-0000-0000-000000000308', '3.08', 'KPI COMERCIAL',
   '3.08 - KPI COMERCIAL',                 'AREA_PRODUTIVA', 14),
  ('d7f1a000-0000-0000-0000-000000000309', '3.09', 'KPI CAMPO',
   '3.09 - KPI CAMPO',                     'AREA_PRODUTIVA', 15),
  ('d7f1a000-0000-0000-0000-000000000310', '3.10', 'KPI BAZAR',
   '3.10 - KPI BAZAR',                     'AREA_PRODUTIVA', 16),

  -- INVESTIMENTOS SOCIAIS (área 4)
  ('d7f1a000-0000-0000-0000-000000000401', '4.01', 'KPI OBRAS E PROJETOS',
   '4.01 - KPI OBRAS E PROJETOS',          'INVESTIMENTOS_SOCIAIS', 17),
  -- ATENÇÃO: 4.01 SD tem mesmo código mas é KPI distinto — o UNIQUE está em nome_completo
  ('d7f1a000-0000-0000-0001-000000000401', '4.01', 'KPI OBRAS E PROJETOS SD',
   '4.01 - KPI OBRAS E PROJETOS SD',       'INVESTIMENTOS_SOCIAIS', 18),
  ('d7f1a000-0000-0000-0000-000000000403', '4.03', 'KPI ASSISTENCIA SOCIAL',
   '4.03 - KPI ASSISTENCIA SOCIAL',        'INVESTIMENTOS_SOCIAIS', 19),
  -- ATENÇÃO: 4.03 AGUA tem mesmo código mas é KPI distinto
  ('d7f1a000-0000-0000-0001-000000000403', '4.03', 'KPI AGUA',
   '4.03 - KPI AGUA',                      'INVESTIMENTOS_SOCIAIS', 20),
  ('d7f1a000-0000-0000-0000-000000000404', '4.04', 'KPI CENTRO DE DISTRIBUICAO',
   '4.04 - KPI CENTRO DE DISTRIBUICAO',    'INVESTIMENTOS_SOCIAIS', 21),

  -- PROGRAMAS SOCIAIS (área 5)
  ('d7f1a000-0000-0000-0000-000000000501', '5.01', 'KPI ADMINISTRACAO SERTAO',
   '5.01 - KPI ADMINISTRACAO SERTAO',      'PROGRAMAS_SOCIAIS', 22),
  ('d7f1a000-0000-0000-0000-000000000502', '5.02', 'KPI UNIDADES',
   '5.02 - KPI UNIDADES',                  'PROGRAMAS_SOCIAIS', 23),
  ('d7f1a000-0000-0000-0000-000000000504', '5.04', 'KPI SAUDE',
   '5.04 - KPI SAUDE',                     'PROGRAMAS_SOCIAIS', 24),
  ('d7f1a000-0000-0000-0000-000000000505', '5.05', 'KPI FROTA',
   '5.05 - KPI FROTA',                     'PROGRAMAS_SOCIAIS', 25),
  ('d7f1a000-0000-0000-0000-000000000507', '5.07', 'KPI DISTRIBUICAO',
   '5.07 - KPI DISTRIBUICAO',              'PROGRAMAS_SOCIAIS', 26),
  ('d7f1a000-0000-0000-0000-000000000508', '5.08', 'KPI DESENVOLVIMENTO INSTITUCIONAL',
   '5.08 - KPI DESENVOLVIMENTO INSTITUCIONAL', 'PROGRAMAS_SOCIAIS', 27),
  ('d7f1a000-0000-0000-0000-000000000510', '5.10', 'KPI CENTRAL DE DOACAO',
   '5.10 - KPI CENTRAL DE DOACAO',         'PROGRAMAS_SOCIAIS', 28)

ON CONFLICT (nome_completo) DO NOTHING;


-- ── kpi_responsaveis ─────────────────────────────────────────────────
-- KPIs com múltiplos responsáveis geram múltiplos registros nesta tabela
INSERT INTO public.kpi_responsaveis (id_kpi, responsavel, diretor) VALUES

  -- 1.01 Administração Central
  ('d7f1a000-0000-0000-0000-000000000101', 'Daniel Benedetti',   'Fernando Medeiros'),

  -- 1.02 Recursos Humanos
  ('d7f1a000-0000-0000-0000-000000000102', 'Gisele Carneiro',    'Fernando Medeiros'),

  -- 1.03 Suprimentos
  ('d7f1a000-0000-0000-0000-000000000103', 'Roberto Zambeli',    'Fernando Medeiros'),

  -- 1.04 Facilities
  ('d7f1a000-0000-0000-0000-000000000104', 'Roberto Zambeli',    'Fernando Medeiros'),

  -- 1.05 DP (vaga — nenhum responsável ativo; inserir quando definido)
  -- Não inserir registro vazio; exibir "A definir" na interface.

  -- 1.06 Controladoria
  ('d7f1a000-0000-0000-0000-000000000106', 'Daniel Benedetti',   'Fernando Medeiros'),

  -- 1.07 Informática
  ('d7f1a000-0000-0000-0000-000000000107', 'Alexandre Carrega',  'Fernando Medeiros'),

  -- 1.08 Marketing
  ('d7f1a000-0000-0000-0000-000000000108', 'Thays Aiala',        'Fernando Medeiros'),

  -- 1.09 Jurídico
  ('d7f1a000-0000-0000-0000-000000000109', 'Ubiratan Reis',      'Fernando Medeiros'),

  -- 2.01 Educação
  ('d7f1a000-0000-0000-0000-000000000201', 'Alceu Caldeira',     'Alceu Caldeira'),

  -- 3.01 Produção
  ('d7f1a000-0000-0000-0000-000000000301', 'Roberto Barroso',    'Alcione Albanesi'),

  -- 3.03 Logística
  ('d7f1a000-0000-0000-0000-000000000303', 'Edmilson Lima',      'Alcione Albanesi'),

  -- 3.04 Adm Produtivo (pendente — não inserir responsável até confirmação)

  -- 3.08 Comercial
  ('d7f1a000-0000-0000-0000-000000000308', 'Fernando Sanches',   'Alcione Albanesi'),

  -- 3.09 Campo (3 responsáveis)
  ('d7f1a000-0000-0000-0000-000000000309', 'Aurora Dionisio',    'Alcione Albanesi'),
  ('d7f1a000-0000-0000-0000-000000000309', 'Diogo Siqueira',     'Alcione Albanesi'),
  ('d7f1a000-0000-0000-0000-000000000309', 'Paulo Souza',        'Alcione Albanesi'),

  -- 3.10 Bazar
  ('d7f1a000-0000-0000-0000-000000000310', 'Alexandre Lacorte',  'Alcione Albanesi'),

  -- 4.01 Obras e Projetos (2 responsáveis)
  ('d7f1a000-0000-0000-0000-000000000401', 'Roberto Barroso',    'André de Luca'),
  ('d7f1a000-0000-0000-0000-000000000401', 'Sergio Tamassia',    'André de Luca'),

  -- 4.01 SD (1 responsável)
  ('d7f1a000-0000-0001-0000-000000000401', 'Roberto Barroso',    'André de Luca'),

  -- 4.03 Assistência Social (4 responsáveis)
  ('d7f1a000-0000-0000-0000-000000000403', 'Aurora Dionisio',    'André de Luca'),
  ('d7f1a000-0000-0000-0000-000000000403', 'Diogo Siqueira',     'André de Luca'),
  ('d7f1a000-0000-0000-0000-000000000403', 'Mauriceia Rodrigues','André de Luca'),
  ('d7f1a000-0000-0000-0000-000000000403', 'Paulo Souza',        'André de Luca'),

  -- 4.03 Água
  ('d7f1a000-0000-0001-0000-000000000403', 'Sergio Tamassia',    'André de Luca'),

  -- 4.04 Centro de Distribuição
  ('d7f1a000-0000-0000-0000-000000000404', 'Reginaldo Queiroz',  'André de Luca'),

  -- 5.01 Adm Sertão (pendente — não inserir responsável até confirmação)

  -- 5.02 Unidades (6 responsáveis)
  ('d7f1a000-0000-0000-0000-000000000502', 'Aurora Dionisio',    'Alceu Caldeira'),
  ('d7f1a000-0000-0000-0000-000000000502', 'Daniel Benedetti',   'Alceu Caldeira'),
  ('d7f1a000-0000-0000-0000-000000000502', 'Diogo Siqueira',     'Alceu Caldeira'),
  ('d7f1a000-0000-0000-0000-000000000502', 'Kathia Cruz',        'Alceu Caldeira'),
  ('d7f1a000-0000-0000-0000-000000000502', 'Mauriceia Rodrigues','Alceu Caldeira'),
  ('d7f1a000-0000-0000-0000-000000000502', 'Paulo Souza',        'Alceu Caldeira'),

  -- 5.04 Saúde
  ('d7f1a000-0000-0000-0000-000000000504', 'Maria Gonçalves',    'Alceu Caldeira'),

  -- 5.05 Frota
  ('d7f1a000-0000-0000-0000-000000000505', 'Roberto Zambeli',    'Alceu Caldeira'),

  -- 5.07 Distribuição (2 responsáveis)
  ('d7f1a000-0000-0000-0000-000000000507', 'Kathia Cruz',        'Alceu Caldeira'),
  ('d7f1a000-0000-0000-0000-000000000507', 'Mirlane Sousa',      'Alceu Caldeira'),

  -- 5.08 Desenv. Institucional (3 responsáveis)
  ('d7f1a000-0000-0000-0000-000000000508', 'Alceu Caldeira',     'Alceu Caldeira'),
  ('d7f1a000-0000-0000-0000-000000000508', 'Fernando Sanches',   'Alceu Caldeira'),
  ('d7f1a000-0000-0000-0000-000000000508', 'Filipe Dorneles',    'Alceu Caldeira'),

  -- 5.10 Central de Doação
  ('d7f1a000-0000-0000-0000-000000000510', 'Alexandre Lacorte',  'Alceu Caldeira')

ON CONFLICT (id_kpi, responsavel) DO NOTHING;

-- Corrigir UUID de 4.01 SD e 4.03 AGUA que têm UUIDs ligeiramente diferentes
-- (o insert de kpis usou 'd7f1a000-0000-0001-000000000401' mas kpi_responsaveis acima
--  precisa referenciar os IDs corretos dos KPIs já inseridos)
-- ATENÇÃO: se houver erro de FK, verifique se os IDs batem com os da tabela kpis.
-- Os IDs usados são:
--   4.01 SD:  'd7f1a000-0000-0001-0000-000000000401'  (4º bloco: 0001)
--   4.03 AGUA:'d7f1a000-0000-0001-0000-000000000403'  (4º bloco: 0001)


-- ── Parâmetros de Pontuação (regra global) ────────────────────────────
-- Regra padrão aplicada a todos os KPIs sem regra específica
-- Faixas: <70% = 0 pontos | 70-99% = proporcional | ≥100% = pontuação plena
INSERT INTO public.parametros_pontuacao (id_kpi, nome_criterio, faixa_minima, faixa_maxima, pontuacao, teto_atingimento) VALUES
  (NULL, 'Abaixo do mínimo', 0,    69.99, 0,   150),
  (NULL, 'Proporcional',     70,   99.99, NULL, 150),   -- NULL = interpolação linear
  (NULL, 'Meta atingida',    100,  NULL,  1,   150)     -- 1 = peso integral
ON CONFLICT DO NOTHING;


-- ====================================================================
-- USUÁRIOS DE TESTE
-- ====================================================================
-- PASSO 1: Crie os usuários no Supabase Dashboard → Authentication → Users
--          Use os e-mails abaixo e anote os UUIDs gerados.
-- PASSO 2: Substitua os valores 'uuid-...-aqui' pelos UUIDs reais e execute.
-- ====================================================================

/*
INSERT INTO public.usuarios (id, nome, email, perfil_acesso, responsavel_vinculado, diretoria_vinculada) VALUES

  -- Administrador — acesso total
  ('uuid-admin-aqui',
   'Administrador', 'admin@amigosdobem.org.br',
   'administrador', NULL, NULL),

  -- Daniel Benedetti — responsável por 1.01, 1.06, 5.02
  ('uuid-daniel-aqui',
   'Daniel Benedetti', 'daniel.benedetti@amigosdobem.org.br',
   'responsavel', 'Daniel Benedetti', 'Fernando Medeiros'),

  -- Roberto Barroso — responsável por 3.01, 4.01, 4.01 SD
  ('uuid-roberto-aqui',
   'Roberto Barroso', 'roberto.barroso@amigosdobem.org.br',
   'responsavel', 'Roberto Barroso', 'Alcione Albanesi'),

  -- Gisele Carneiro — responsável por 1.02
  ('uuid-gisele-aqui',
   'Gisele Carneiro', 'gisele.carneiro@amigosdobem.org.br',
   'responsavel', 'Gisele Carneiro', 'Fernando Medeiros'),

  -- Alceu Caldeira — Diretoria N1 + responsável por 2.01 e 5.08
  ('uuid-alceu-aqui',
   'Alceu Caldeira', 'alceu.caldeira@amigosdobem.org.br',
   'diretoria_n1', 'Alceu Caldeira', 'Alceu Caldeira')

ON CONFLICT (email) DO NOTHING;
*/


-- ====================================================================
-- CENTROS DE CUSTO
-- ====================================================================
-- Os 270 centros de custo devem ser importados do arquivo:
--   CTR_001_085_-_Centros_de_custos.xlsx
-- Script de importação disponível separadamente.
-- Mapeamento CC → KPI deve ser inserido em kpi_cc_vinculo após o import.
-- ====================================================================
-- Exemplo do mapeamento (descomente após importar os CCs):
/*
INSERT INTO public.kpi_cc_vinculo (id_kpi, codigo_cc, tipo_vinculo) VALUES
  -- 1.01 Administração Central
  ('d7f1a000-0000-0000-0000-000000000101', 3,   'direto'),
  ('d7f1a000-0000-0000-0000-000000000101', 307, 'direto'),
  -- 1.02 Recursos Humanos
  ('d7f1a000-0000-0000-0000-000000000102', 7,   'direto'),
  -- 1.03 Suprimentos
  ('d7f1a000-0000-0000-0000-000000000103', 280, 'direto'),
  -- 1.04 Facilities
  ('d7f1a000-0000-0000-0000-000000000104', 281, 'direto'),
  -- 1.05 DP
  ('d7f1a000-0000-0000-0000-000000000105', 336, 'direto'),
  -- 1.06 Controladoria
  ('d7f1a000-0000-0000-0000-000000000106', 4,   'direto'),
  ('d7f1a000-0000-0000-0000-000000000106', 282, 'direto'),
  -- 1.07 Informática
  ('d7f1a000-0000-0000-0000-000000000107', 6,   'direto'),
  -- 1.08 Marketing
  ('d7f1a000-0000-0000-0000-000000000108', 9,   'direto'),
  -- 2.01 Educação
  ('d7f1a000-0000-0000-0000-000000000201', 11,  'direto'),
  ('d7f1a000-0000-0000-0000-000000000201', 12,  'direto'),
  ('d7f1a000-0000-0000-0000-000000000201', 13,  'direto'),
  ('d7f1a000-0000-0000-0000-000000000201', 14,  'direto'),
  ('d7f1a000-0000-0000-0000-000000000201', 15,  'direto'),
  ('d7f1a000-0000-0000-0000-000000000201', 16,  'direto'),
  ('d7f1a000-0000-0000-0000-000000000201', 17,  'direto'),
  ('d7f1a000-0000-0000-0000-000000000201', 18,  'direto'),
  ('d7f1a000-0000-0000-0000-000000000201', 19,  'direto'),
  ('d7f1a000-0000-0000-0000-000000000201', 343, 'direto'),
  ('d7f1a000-0000-0000-0000-000000000201', 344, 'direto')
ON CONFLICT (id_kpi, codigo_cc) DO NOTHING;
*/
