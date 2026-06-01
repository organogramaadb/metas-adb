-- ============================================================
-- METAS ADB — Seed: Usuários, Metas, Metas Mensais, Projetos
-- Executar APÓS seed_kpis_ccs.sql
-- ATENÇÃO: criar os usuários em Authentication → Users no
-- dashboard do Supabase ANTES de executar este script
-- (o e-mail deve bater exatamente com o campo email abaixo)
-- ============================================================

-- ── Usuários ──────────────────────────────────────────────────
INSERT INTO usuarios (email, nome, perfil, responsavel, ativo) VALUES
  ('admin@amigosdobem.org.br',               'Administrador',       'Admin',    NULL,                  true),
  ('daniel.benedetti@amigosdobem.org.br',    'Daniel Benedetti',    'Gestor',   'Daniel Benedetti',    true),
  ('roberto.barroso@amigosdobem.org.br',     'Roberto Barroso',     'Gestor',   'Roberto Barroso',     true),
  ('gisele.carneiro@amigosdobem.org.br',     'Gisele Carneiro',     'Gestor',   'Gisele Carneiro',     true),
  ('alceu.caldeira@amigosdobem.org.br',      'Alceu Caldeira',      'Gestor',   'Alceu Caldeira',      true),
  ('alexandre.carrega@amigosdobem.org.br',   'Alexandre Carrega',   'Gestor',   'Alexandre Carrega',   true),
  ('alexandre.lacorte@amigosdobem.org.br',   'Alexandre Lacorte',   'Gestor',   'Alexandre Lacorte',   true),
  ('aurora.dionisio@amigosdobem.org.br',     'Aurora Dionisio',     'Gestor',   'Aurora Dionisio',     true),
  ('diogo.siqueira@amigosdobem.org.br',      'Diogo Siqueira',      'Gestor',   'Diogo Siqueira',      true),
  ('edmilson.lima@amigosdobem.org.br',       'Edmilson Lima',       'Gestor',   'Edmilson Lima',       true),
  ('fernando.sanches@amigosdobem.org.br',    'Fernando Sanches',    'Gestor',   'Fernando Sanches',    true),
  ('filipe.dorneles@amigosdobem.org.br',     'Filipe Dorneles',     'Gestor',   'Filipe Dorneles',     true),
  ('kathia.cruz@amigosdobem.org.br',         'Kathia Cruz',         'Gestor',   'Kathia Cruz',         true),
  ('maria.goncalves@amigosdobem.org.br',     'Maria Gonçalves',     'Gestor',   'Maria Gonçalves',     true),
  ('mauriceia.rodrigues@amigosdobem.org.br', 'Mauriceia Rodrigues', 'Gestor',   'Mauriceia Rodrigues', true),
  ('mirlane.sousa@amigosdobem.org.br',       'Mirlane Sousa',       'Gestor',   'Mirlane Sousa',       true),
  ('paulo.souza@amigosdobem.org.br',         'Paulo Souza',         'Gestor',   'Paulo Souza',         true),
  ('reginaldo.queiroz@amigosdobem.org.br',   'Reginaldo Queiroz',   'Gestor',   'Reginaldo Queiroz',   true),
  ('roberto.zambeli@amigosdobem.org.br',     'Roberto Zambeli',     'Gestor',   'Roberto Zambeli',     true),
  ('sergio.tamassia@amigosdobem.org.br',     'Sergio Tamassia',     'Gestor',   'Sergio Tamassia',     true),
  ('thays.aiala@amigosdobem.org.br',         'Thays Aiala',         'Gestor',   'Thays Aiala',         true),
  ('ubiratan.reis@amigosdobem.org.br',       'Ubiratan Reis',       'Gestor',   'Ubiratan Reis',       true),
  ('consulta@amigosdobem.org.br',            'Usuário Consulta',    'Consulta', NULL,                  true)
ON CONFLICT (email) DO NOTHING;

-- ── Metas ─────────────────────────────────────────────────────
INSERT INTO metas
  (id, id_kpi, codigo_kpi, seq, nome, descricao, responsavel, diretoria,
   tipo_formato, unidade_medida, bom_quando, peso, status, obs, ult_at, ativo,
   formula_atingimento, tipo_acumulado)
VALUES
  ('m-101-1','kpi-101','1.01',1,
   'Controle de Despesas Adm.',
   'Manter despesas administrativas centrais dentro do orçamento aprovado',
   'Daniel Benedetti','Fernando Medeiros',
   'moeda','R$','Menor',0.6,'Ativa','','2026-05-26',true,'real_sobre_meta','soma'),

  ('m-101-2','kpi-101','1.01',2,
   'Índice de Satisfação Interna',
   'Pesquisa de satisfação com serviços administrativos (NPS interno)',
   'Daniel Benedetti','Fernando Medeiros',
   'decimal','pontos','Maior',0.4,'Ativa','','2026-03-15',true,'real_sobre_meta','media'),

  ('m-102-1','kpi-102','1.02',1,
   'Taxa de Turnover',
   'Percentual de saídas voluntárias em relação ao quadro total',
   'Gisele Carneiro','Fernando Medeiros',
   'percentual','%','Menor',0.4,'Ativa','','2026-04-30',true,'real_sobre_meta','media'),

  ('m-102-2','kpi-102','1.02',2,
   'Posições Preenchidas',
   'Percentual de vagas preenchidas em relação ao headcount aprovado',
   'Gisele Carneiro','Fernando Medeiros',
   'percentual','%','Maior',0.6,'Ativa',
   'Vagas de campo apresentam maior dificuldade','2026-04-30',true,'real_sobre_meta','media'),

  ('m-301-1','kpi-301','3.01',1,
   'Despesas de Produção',
   'Controle total de despesas operacionais da unidade produtiva de amêndoa',
   'Roberto Barroso','Fernando Medeiros',
   'moeda','R$','Menor',0.5,'Ativa',
   'Impacto da alta do diesel e insumos no Q1','2026-04-30',true,'real_sobre_meta','soma'),

  ('m-301-2','kpi-301','3.01',2,
   'Custo Base Amêndoa',
   'Custo unitário médio da base amêndoa (produção própria + compra)',
   'Roberto Barroso','Fernando Medeiros',
   'decimal','R$/kg','Menor',0.3,'Ativa','','2026-04-30',true,'real_sobre_meta','media'),

  ('m-301-3','kpi-301','3.01',3,
   'Produção Total',
   'Volume total de amêndoa produzida no período (meta de produção)',
   'Roberto Barroso','Fernando Medeiros',
   'numero_inteiro','kg','Maior',0.2,'Ativa',
   'Safra impactada por estiagem em mar/abr','2026-04-30',true,'real_sobre_meta','soma')
ON CONFLICT (id) DO NOTHING;

-- ── Metas Mensais (84 registros) ──────────────────────────────
INSERT INTO metas_mensais (id, id_meta, ano, mes, valor_meta, valor_realizado) VALUES
  -- KPI 1.01 — Meta 1 (Despesas Adm. — Menor — Moeda)
  ('mm-101-1-1',  'm-101-1', 2026,  1, 195000, 182000),
  ('mm-101-1-2',  'm-101-1', 2026,  2, 195000, 188000),
  ('mm-101-1-3',  'm-101-1', 2026,  3, 195000, 201000),
  ('mm-101-1-4',  'm-101-1', 2026,  4, 195000, 178000),
  ('mm-101-1-5',  'm-101-1', 2026,  5, 195000, NULL),
  ('mm-101-1-6',  'm-101-1', 2026,  6, 195000, NULL),
  ('mm-101-1-7',  'm-101-1', 2026,  7, 195000, NULL),
  ('mm-101-1-8',  'm-101-1', 2026,  8, 195000, NULL),
  ('mm-101-1-9',  'm-101-1', 2026,  9, 195000, NULL),
  ('mm-101-1-10', 'm-101-1', 2026, 10, 195000, NULL),
  ('mm-101-1-11', 'm-101-1', 2026, 11, 195000, NULL),
  ('mm-101-1-12', 'm-101-1', 2026, 12, 195000, NULL),

  -- KPI 1.01 — Meta 2 (Satisfação Interna — Maior — Decimal)
  ('mm-101-2-1',  'm-101-2', 2026,  1, 7.5, NULL),
  ('mm-101-2-2',  'm-101-2', 2026,  2, 7.5, NULL),
  ('mm-101-2-3',  'm-101-2', 2026,  3, 7.5, 8.1),
  ('mm-101-2-4',  'm-101-2', 2026,  4, 7.5, NULL),
  ('mm-101-2-5',  'm-101-2', 2026,  5, 7.5, NULL),
  ('mm-101-2-6',  'm-101-2', 2026,  6, 8.0, NULL),
  ('mm-101-2-7',  'm-101-2', 2026,  7, 8.0, NULL),
  ('mm-101-2-8',  'm-101-2', 2026,  8, 8.0, NULL),
  ('mm-101-2-9',  'm-101-2', 2026,  9, 8.0, NULL),
  ('mm-101-2-10', 'm-101-2', 2026, 10, 8.0, NULL),
  ('mm-101-2-11', 'm-101-2', 2026, 11, 8.0, NULL),
  ('mm-101-2-12', 'm-101-2', 2026, 12, 8.0, NULL),

  -- KPI 1.02 — Meta 1 (Turnover — Menor — Percentual)
  ('mm-102-1-1',  'm-102-1', 2026,  1, 0.02, 0.018),
  ('mm-102-1-2',  'm-102-1', 2026,  2, 0.02, 0.015),
  ('mm-102-1-3',  'm-102-1', 2026,  3, 0.02, 0.023),
  ('mm-102-1-4',  'm-102-1', 2026,  4, 0.02, 0.019),
  ('mm-102-1-5',  'm-102-1', 2026,  5, 0.02, NULL),
  ('mm-102-1-6',  'm-102-1', 2026,  6, 0.02, NULL),
  ('mm-102-1-7',  'm-102-1', 2026,  7, 0.02, NULL),
  ('mm-102-1-8',  'm-102-1', 2026,  8, 0.02, NULL),
  ('mm-102-1-9',  'm-102-1', 2026,  9, 0.02, NULL),
  ('mm-102-1-10', 'm-102-1', 2026, 10, 0.02, NULL),
  ('mm-102-1-11', 'm-102-1', 2026, 11, 0.02, NULL),
  ('mm-102-1-12', 'm-102-1', 2026, 12, 0.02, NULL),

  -- KPI 1.02 — Meta 2 (Posições Preenchidas — Maior — Percentual)
  ('mm-102-2-1',  'm-102-2', 2026,  1, 0.95, 0.88),
  ('mm-102-2-2',  'm-102-2', 2026,  2, 0.95, 0.91),
  ('mm-102-2-3',  'm-102-2', 2026,  3, 0.95, 0.89),
  ('mm-102-2-4',  'm-102-2', 2026,  4, 0.95, 0.92),
  ('mm-102-2-5',  'm-102-2', 2026,  5, 0.95, NULL),
  ('mm-102-2-6',  'm-102-2', 2026,  6, 0.95, NULL),
  ('mm-102-2-7',  'm-102-2', 2026,  7, 0.95, NULL),
  ('mm-102-2-8',  'm-102-2', 2026,  8, 0.95, NULL),
  ('mm-102-2-9',  'm-102-2', 2026,  9, 0.95, NULL),
  ('mm-102-2-10', 'm-102-2', 2026, 10, 0.95, NULL),
  ('mm-102-2-11', 'm-102-2', 2026, 11, 0.95, NULL),
  ('mm-102-2-12', 'm-102-2', 2026, 12, 0.95, NULL),

  -- KPI 3.01 — Meta 1 (Despesas Produção — Menor — Moeda)
  ('mm-301-1-1',  'm-301-1', 2026,  1, 2700000, 2876890),
  ('mm-301-1-2',  'm-301-1', 2026,  2, 2100000, 2339421),
  ('mm-301-1-3',  'm-301-1', 2026,  3, 2500000, 2687405),
  ('mm-301-1-4',  'm-301-1', 2026,  4, 2200000, 2349045),
  ('mm-301-1-5',  'm-301-1', 2026,  5, 2400000, NULL),
  ('mm-301-1-6',  'm-301-1', 2026,  6, 2300000, NULL),
  ('mm-301-1-7',  'm-301-1', 2026,  7, 2400000, NULL),
  ('mm-301-1-8',  'm-301-1', 2026,  8, 2300000, NULL),
  ('mm-301-1-9',  'm-301-1', 2026,  9, 2500000, NULL),
  ('mm-301-1-10', 'm-301-1', 2026, 10, 2600000, NULL),
  ('mm-301-1-11', 'm-301-1', 2026, 11, 2700000, NULL),
  ('mm-301-1-12', 'm-301-1', 2026, 12, 2800000, NULL),

  -- KPI 3.01 — Meta 2 (Custo Base Amêndoa — Menor — Decimal)
  ('mm-301-2-1',  'm-301-2', 2026,  1, 42.6, 41.1),
  ('mm-301-2-2',  'm-301-2', 2026,  2, 42.6, 41.7),
  ('mm-301-2-3',  'm-301-2', 2026,  3, 42.6, 42.3),
  ('mm-301-2-4',  'm-301-2', 2026,  4, 45.0, 44.9),
  ('mm-301-2-5',  'm-301-2', 2026,  5, 45.0, NULL),
  ('mm-301-2-6',  'm-301-2', 2026,  6, 45.0, NULL),
  ('mm-301-2-7',  'm-301-2', 2026,  7, 45.0, NULL),
  ('mm-301-2-8',  'm-301-2', 2026,  8, 45.0, NULL),
  ('mm-301-2-9',  'm-301-2', 2026,  9, 45.0, NULL),
  ('mm-301-2-10', 'm-301-2', 2026, 10, 45.0, NULL),
  ('mm-301-2-11', 'm-301-2', 2026, 11, 45.0, NULL),
  ('mm-301-2-12', 'm-301-2', 2026, 12, 45.0, NULL),

  -- KPI 3.01 — Meta 3 (Produção Total — Maior — Inteiro)
  ('mm-301-3-1',  'm-301-3', 2026,  1, 25200, 21509),
  ('mm-301-3-2',  'm-301-3', 2026,  2, 25200, 16414),
  ('mm-301-3-3',  'm-301-3', 2026,  3, 25200, 15233),
  ('mm-301-3-4',  'm-301-3', 2026,  4, 25200, 28879),
  ('mm-301-3-5',  'm-301-3', 2026,  5, 26248, NULL),
  ('mm-301-3-6',  'm-301-3', 2026,  6, 26248, NULL),
  ('mm-301-3-7',  'm-301-3', 2026,  7, 26248, NULL),
  ('mm-301-3-8',  'm-301-3', 2026,  8, 26248, NULL),
  ('mm-301-3-9',  'm-301-3', 2026,  9, 26248, NULL),
  ('mm-301-3-10', 'm-301-3', 2026, 10, 26248, NULL),
  ('mm-301-3-11', 'm-301-3', 2026, 11, 26248, NULL),
  ('mm-301-3-12', 'm-301-3', 2026, 12, 26248, NULL)
ON CONFLICT (id_meta, ano, mes) DO NOTHING;

-- ── Projetos ──────────────────────────────────────────────────
INSERT INTO projetos
  (id, id_kpi, id_meta, nome, descricao, responsavel,
   status, prioridade, prazo, percentual_evolucao,
   proxima_acao, responsavel_acao, obs,
   ativo, data_criacao, data_atualizacao, usuario_atualizacao)
VALUES
  ('p-1','kpi-301','m-301-1',
   'Redução de Custos Operacionais — Fase 1',
   'Mapeamento e eliminação de desperdícios na linha de produção. Inclui revisão de contratos de insumos e renegociação com fornecedores.',
   'Roberto Barroso',
   'Em andamento','Alta','2026-06-30',45,
   'Reunião de alinhamento com equipe de produção para revisar processo de colheita',
   'Filipe Dorneles','Negociação com fornecedor de diesel em andamento',
   true,'2026-01-15','2026-04-10','roberto.barroso@amigosdobem.org.br'),

  ('p-2','kpi-301','m-301-3',
   'Expansão da Capacidade Produtiva — Sertão Norte',
   'Implantação de novo módulo de beneficiamento para aumentar a capacidade de processamento de amêndoa.',
   'Roberto Barroso',
   'Não iniciado','Média','2026-09-30',0,
   'Elaborar projeto executivo e solicitar orçamentos',
   'Roberto Barroso','Aguardando aprovação orçamentária da Diretoria',
   true,'2026-02-01','2026-02-01','roberto.barroso@amigosdobem.org.br'),

  ('p-3','kpi-301','m-301-2',
   'Otimização do Processo de Beneficiamento',
   'Revisão do fluxo de beneficiamento para reduzir perdas e custo unitário da amêndoa processada.',
   'Filipe Dorneles',
   'Em andamento','Alta','2026-07-31',70,
   'Validar novo layout do galpão com o setor de engenharia',
   'Edmilson Lima','Fase de testes concluída com resultado positivo',
   true,'2026-01-20','2026-04-25','roberto.barroso@amigosdobem.org.br'),

  ('p-4','kpi-101','m-101-1',
   'Revisão de Contratos de Fornecedores Adm.',
   'Renegociação dos principais contratos de serviços administrativos para redução de custos fixos.',
   'Daniel Benedetti',
   'Concluído','Alta','2026-03-31',100,
   'Monitorar execução dos novos contratos',
   'Roberto Zambeli','Economia estimada de R$ 48 mil/ano',
   true,'2026-01-05','2026-03-28','daniel.benedetti@amigosdobem.org.br'),

  ('p-5','kpi-102','m-102-2',
   'Banco de Talentos — Campo',
   'Criação de banco de talentos para agilizar preenchimento de vagas operacionais no Sertão.',
   'Gisele Carneiro',
   'Em andamento','Média','2026-08-31',30,
   'Publicar vagas nos canais regionais parceiros',
   'Kathia Cruz','Parceria com SINE local em negociação',
   true,'2026-03-10','2026-04-15','gisele.carneiro@amigosdobem.org.br')
ON CONFLICT (id) DO NOTHING;
