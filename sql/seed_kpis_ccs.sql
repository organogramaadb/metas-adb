-- ============================================================
-- METAS ADB — Seed: KPIs + Centros de Custo
-- Executar APÓS setup_supabase.sql
-- ============================================================

-- ── KPIs — 31 KPIs reais da ADB ──────────────────────────────
INSERT INTO kpis (id, codigo, nome, area, responsavel, diretoria, ativo) VALUES
  ('kpi-101', '1.01', 'Administração Central',           'Administração',            'Daniel Benedetti',    'Fernando Medeiros', true),
  ('kpi-102', '1.02', 'Recursos Humanos',                 'Administração',            'Gisele Carneiro',     'Fernando Medeiros', true),
  ('kpi-103', '1.03', 'Suprimentos',                      'Administração',            'Roberto Zambeli',     'Fernando Medeiros', true),
  ('kpi-104', '1.04', 'Administração Facilities',         'Administração',            'Roberto Zambeli',     'Fernando Medeiros', true),
  ('kpi-105', '1.05', 'Departamento Pessoal',             'Administração',            'Vaga',                'Fernando Medeiros', true),
  ('kpi-106', '1.06', 'Controladoria',                    'Administração',            'Daniel Benedetti',    'Fernando Medeiros', true),
  ('kpi-107', '1.07', 'Informática',                      'Administração',            'Alexandre Carrega',   'Fernando Medeiros', true),
  ('kpi-108', '1.08', 'Marketing',                        'Administração',            'Thays Aiala',         'André de Luca',     true),
  ('kpi-109', '1.09', 'Jurídico e Regulatórios',          'Administração',            'Ubiratan Reis',       'Fernando Medeiros', true),
  ('kpi-201', '2.01', 'Educação',                         'Programas Sociais',        'Alceu Caldeira',      'Alceu Caldeira',    true),
  ('kpi-301', '3.01', 'Produção',                         'Produção',                 'Roberto Barroso',     'Fernando Medeiros', true),
  ('kpi-303', '3.03', 'Logística',                        'Produção',                 'Edmilson Lima',       'Fernando Medeiros', true),
  ('kpi-308', '3.08', 'Comercial',                        'Produção',                 'Fernando Sanches',    'Fernando Medeiros', true),
  ('kpi-309', '3.09', 'Campo — CAT',                      'Produção',                 'Paulo Souza',         'André de Luca',     true),
  ('kpi-310', '3.10', 'Bazar',                            'Produção',                 'Alexandre Lacorte',   'Fernando Medeiros', true),
  ('kpi-311', '3.11', 'Campo — CE',                       'Produção',                 'Aurora Dionisio',     'André de Luca',     true),
  ('kpi-312', '3.12', 'Campo — Inajá',                    'Produção',                 'Diogo Siqueira',      'André de Luca',     true),
  ('kpi-401', '4.01', 'Obras e Projetos',                 'Projetos e Investimentos', 'Roberto Barroso',     'Fernando Medeiros', true),
  ('kpi-402', '4.02', 'Obras e Projetos — SD',            'Projetos e Investimentos', 'Roberto Barroso',     'Fernando Medeiros', true),
  ('kpi-403', '4.03', 'Água',                             'Projetos e Investimentos', 'Sergio Tamassia',     'Fernando Medeiros', true),
  ('kpi-404', '4.04', 'Centro de Distribuição',           'Programas Sociais',        'Reginaldo Queiroz',   'Fernando Medeiros', true),
  ('kpi-405', '4.05', 'Energia Solar',                    'Projetos e Investimentos', 'Sergio Tamassia',     'Fernando Medeiros', true),
  ('kpi-502', '5.02', 'Unidades',                         'Programas Sociais',        'Mauriceia Rodrigues', 'Fernando Medeiros', true),
  ('kpi-504', '5.04', 'Saúde',                            'Programas Sociais',        'Maria Gonçalves',     'André de Luca',     true),
  ('kpi-505', '5.05', 'Frota',                            'Programas Sociais',        'Roberto Zambeli',     'Fernando Medeiros', true),
  ('kpi-507', '5.07', 'Distribuição',                     'Projetos e Investimentos', 'Mirlane Sousa',       'Fernando Sanches',  true),
  ('kpi-508', '5.08', 'Desenvolvimento Inst. — PF',       'Programas Sociais',        'Filipe Dorneles',     'Fernando Medeiros', true),
  ('kpi-509', '5.09', 'Desenvolvimento Institucional',    'Programas Sociais',        'Fernando Sanches',    'Fernando Medeiros', true),
  ('kpi-510', '5.10', 'Central de Doação',                'Programas Sociais',        'Alexandre Lacorte',   'Fernando Medeiros', true),
  ('kpi-511', '5.11', 'Desenvolvimento Inst. — Eventos',  'Projetos e Investimentos', 'Alceu Caldeira',      'Fernando Medeiros', true),
  ('kpi-512', '5.12', 'Assistência Social',               'Programas Sociais',        'Aurora Dionisio',     'André de Luca',     true)
ON CONFLICT (id) DO NOTHING;

-- ── Centros de Custo ──────────────────────────────────────────
-- ATENÇÃO: os 193 INSERTs completos devem ser adicionados aqui
-- a partir dos dados do arquivo CTR_001_085_-_Centros_de_custos.xlsx
-- Estrutura de cada linha:
--
-- INSERT INTO centros_custo
--   (codigo, classificacao, unidade, pilar, nome, tipo, cd_grpg,
--    codigo_kpi, id_kpi, setor_local, responsavel, objetivo, diretoria, ativo)
-- VALUES
--   (3, '1.01.001', 'SP', 'ADMINISTRAÇÃO', 'Administracao Central - SP',
--    'A', '1.01', '1.01', 'kpi-101', NULL,
--    'Daniel Benedetti', 'Gestão e controle da administração central', 'Fernando Medeiros', true);
--
-- Cole aqui os 193 INSERTs extraídos do xlsx ↓
