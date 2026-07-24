// ===================================================================
// data.js — Dados de demonstração
// Fonte: Tabela_Centros_Custos, Modelo METAS CLAUDE.xlsx
// ===================================================================

const LOGO_B64 = 'data:image/png;base64,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';

// ── Usuários ──────────────────────────────────────────────────────
const USUARIOS = [
  { email:'admin@amigosdobem.org.br',               senha:'admin', nome:'Administrador',     perfil:'Admin',       responsavel:'*',                 diretoria:'*',                 ativo:true },
  { email:'daniel.benedetti@amigosdobem.org.br',    senha:'admin', nome:'Daniel Benedetti',  perfil:'Admin',       responsavel:'Daniel Benedetti',  diretoria:'Fernando Medeiros', ativo:true },
  { email:'roberto.barroso@amigosdobem.org.br',     senha:'admin',        nome:'Roberto Barroso',          perfil:'Responsavel', responsavel:'Roberto Barroso',          diretoria:'Alcione Albanesi',  ativo:true },
  { email:'thiago.rufino@amigosdobem.org',           senha:'Rufino@123',   nome:'Thiago Gonçalves Rufino',  perfil:'Responsavel', responsavel:'Thiago Rufino',            diretoria:'Alcione Albanesi',  ativo:true },
  { email:'gisele.carneiro@amigosdobem.org.br',     senha:'admin', nome:'Gisele Carneiro',   perfil:'Responsavel', responsavel:'Gisele Carneiro',   diretoria:'Fernando Medeiros', ativo:true },
  { email:'alceu.caldeira@amigosdobem.org.br',      senha:'admin', nome:'Alceu Caldeira',    perfil:'DiretorN1',   responsavel:'Alceu Caldeira',    diretoria:'Alceu Caldeira',    ativo:true },
];

// ── KPIs ──────────────────────────────────────────────────────────
// 'area' usa o código do enum do banco (UPPERCASE) — areaLabel() converte para exibição
// 'responsaveis' é array: permite múltiplos responsáveis por KPI
const KPIS = [
  // ── INDICADORES ORGANIZACIONAIS (0.00) — exclusivo do Administrador ──
  // KPI institucional sem centro de custo próprio. Sempre o primeiro da lista.
  { id:'kpi-000', codigo:'0.00', nome:'INDICADORES ORGANIZACIONAIS', area:'ORGANIZACIONAL', responsaveis:['Daniel Benedetti'], diretoria:'Fernando Medeiros', descricao:'Metas institucionais consolidadas — visíveis apenas ao Administrador', ativo:true },
  // ── ADMINISTRATIVOS ────────────────────────────────────────────
  { id:'kpi-101', codigo:'1.01', nome:'KPI ADMINISTRACAO CENTRAL',       area:'ADMINISTRATIVOS',       responsaveis:['Daniel Benedetti'],   diretoria:'Fernando Medeiros', descricao:'Gestão dos custos administrativos centrais', ativo:true },
  { id:'kpi-102', codigo:'1.02', nome:'KPI RECURSOS HUMANOS',            area:'ADMINISTRATIVOS',       responsaveis:['Gisele Carneiro'],    diretoria:'Fernando Medeiros', descricao:'Gestão de pessoas, recrutamento e benefícios', ativo:true },
  { id:'kpi-103', codigo:'1.03', nome:'KPI SUPRIMENTOS',                 area:'ADMINISTRATIVOS',       responsaveis:['Roberto Zambeli'],    diretoria:'Fernando Medeiros', descricao:'Eficiência do ciclo de compras e fornecedores', ativo:true },
  { id:'kpi-104', codigo:'1.04', nome:'KPI ADMINISTRACAO FACILITIES',    area:'ADMINISTRATIVOS',       responsaveis:['Roberto Zambeli'],    diretoria:'Fernando Medeiros', descricao:'Operação predial e infraestrutura física central', ativo:true },
  { id:'kpi-105', codigo:'1.05', nome:'KPI DP',                          area:'ADMINISTRATIVOS',       responsaveis:[],                     diretoria:'Fernando Medeiros', descricao:'Processamento de folha e compliance trabalhista', ativo:true },
  { id:'kpi-106', codigo:'1.06', nome:'KPI CONTROLADORIA',               area:'ADMINISTRATIVOS',       responsaveis:['Daniel Benedetti'],   diretoria:'Fernando Medeiros', descricao:'Orçamento, forecast, controles internos e BI gerencial', ativo:true },
  { id:'kpi-107', codigo:'1.07', nome:'KPI INFORMATICA',                 area:'ADMINISTRATIVOS',       responsaveis:['Alexandre Carrega'],  diretoria:'Fernando Medeiros', descricao:'Suporte, infraestrutura e licenças de tecnologia', ativo:true },
  { id:'kpi-108', codigo:'1.08', nome:'KPI MARKETING',                   area:'ADMINISTRATIVOS',       responsaveis:['Thays Aiala'],        diretoria:'Fernando Medeiros', descricao:'Comunicação institucional e campanhas de marketing', ativo:true },
  { id:'kpi-109', codigo:'1.09', nome:'KPI JURIDICO E REGULATORIOS',     area:'ADMINISTRATIVOS',       responsaveis:['Ubiratan Reis'],      diretoria:'Fernando Medeiros', descricao:'Gestão jurídica e conformidade regulatória', ativo:true },
  // ── EDUCACAO ───────────────────────────────────────────────────
  { id:'kpi-201', codigo:'2.01', nome:'KPI EDUCACAO',                    area:'EDUCACAO',              responsaveis:['Alceu Caldeira'],     diretoria:'Alceu Caldeira',   descricao:'Centros de Transformação e programas educacionais', ativo:true },
  // ── AREA_PRODUTIVA ─────────────────────────────────────────────
  { id:'kpi-301', codigo:'3.01', nome:'KPI PRODUCAO',                    area:'AREA_PRODUTIVA',        responsaveis:['Roberto Barroso','Thiago Rufino'], diretoria:'Alcione Albanesi', descricao:'Produção de amêndoa e controle de custos industriais', ativo:true },
  { id:'kpi-303', codigo:'3.03', nome:'KPI LOGISTICA',                   area:'AREA_PRODUTIVA',        responsaveis:['Edmilson Lima'],      diretoria:'Alcione Albanesi', descricao:'Gestão da cadeia logística e distribuição', ativo:true },
  { id:'kpi-304', codigo:'3.04', nome:'KPI ADMINISTRACAO PRODUTIVO',     area:'AREA_PRODUTIVA',        responsaveis:[],                     diretoria:'Alcione Albanesi', descricao:'A definir', ativo:true },
  { id:'kpi-308', codigo:'3.08', nome:'KPI COMERCIAL',                   area:'AREA_PRODUTIVA',        responsaveis:['Fernando Sanches'],   diretoria:'Alcione Albanesi', descricao:'Vendas e relacionamento comercial', ativo:true },
  { id:'kpi-309-cat', codigo:'3.09', nome:'KPI CAMPO CAT',   area:'AREA_PRODUTIVA', responsaveis:['Paulo Souza'],    diretoria:'Alcione Albanesi', descricao:'Operações de campo — Catimbau (CC 65)', ativo:true },
  { id:'kpi-311',     codigo:'3.11', nome:'KPI CAMPO CE',   area:'AREA_PRODUTIVA', responsaveis:['Aurora Dionisio'],diretoria:'Alcione Albanesi', descricao:'Operações de campo — Ceará (CC 66)', ativo:true },
  { id:'kpi-312',     codigo:'3.12', nome:'KPI CAMPO INAJA',area:'AREA_PRODUTIVA', responsaveis:['Diogo Siqueira'], diretoria:'Alcione Albanesi', descricao:'Operações de campo — Inajá (CC 265)', ativo:true },
  { id:'kpi-310', codigo:'3.10', nome:'KPI BAZAR',                       area:'AREA_PRODUTIVA',        responsaveis:['Alexandre Lacorte'],  diretoria:'Alcione Albanesi', descricao:'Gestão das lojas bazar', ativo:true },
  // ── INVESTIMENTOS_SOCIAIS ──────────────────────────────────────
  { id:'kpi-401',  codigo:'4.01', nome:'KPI OBRAS E PROJETOS',           area:'INVESTIMENTOS_SOCIAIS', responsaveis:['Roberto Barroso','Sergio Tamassia'], diretoria:'André de Luca', descricao:'Gestão de obras e projetos sociais', ativo:true },
  { id:'kpi-402',  codigo:'4.02', nome:'KPI OBRAS E PROJETOS SD',        area:'INVESTIMENTOS_SOCIAIS', responsaveis:['Roberto Barroso'],    diretoria:'André de Luca',    descricao:'Obras e projetos — Sertão do Desenvolvimento (CC 279)', ativo:true },
  { id:'kpi-405',  codigo:'4.05', nome:'KPI ENERGIA',                   area:'INVESTIMENTOS_SOCIAIS', responsaveis:['Sergio Tamassia'],    diretoria:'André de Luca',    descricao:'Projetos de energia solar (CCs 217, 218, 230, 293)', ativo:true },
  { id:'kpi-403',  codigo:'4.03', nome:'KPI ASSISTENCIA SOCIAL',         area:'INVESTIMENTOS_SOCIAIS', responsaveis:['Aurora Dionisio','Diogo Siqueira','Mauriceia Rodrigues','Paulo Souza'], diretoria:'André de Luca', descricao:'Programas de assistência social', ativo:true },
  { id:'kpi-403a', codigo:'4.03', nome:'KPI AGUA',                       area:'INVESTIMENTOS_SOCIAIS', responsaveis:['Sergio Tamassia'],    diretoria:'André de Luca',    descricao:'Gestão de infraestrutura hídrica', ativo:true },
  { id:'kpi-404',  codigo:'4.04', nome:'KPI CENTRO DE DISTRIBUICAO',     area:'INVESTIMENTOS_SOCIAIS', responsaveis:['Reginaldo Queiroz'],  diretoria:'André de Luca',    descricao:'Operações do centro de distribuição', ativo:true },
  // ── PROGRAMAS_SOCIAIS ──────────────────────────────────────────
  { id:'kpi-501', codigo:'5.01', nome:'KPI ADMINISTRACAO SERTAO',        area:'PROGRAMAS_SOCIAIS',     responsaveis:[],                     diretoria:'Alceu Caldeira',   descricao:'A definir', ativo:true },
  { id:'kpi-502', codigo:'5.02', nome:'KPI UNIDADES',                    area:'PROGRAMAS_SOCIAIS',     responsaveis:['Aurora Dionisio','Daniel Benedetti','Diogo Siqueira','Kathia Cruz','Mauriceia Rodrigues','Paulo Souza'], diretoria:'Alceu Caldeira', descricao:'Gestão das unidades de atendimento', ativo:true },
  { id:'kpi-504', codigo:'5.04', nome:'KPI SAUDE',                       area:'PROGRAMAS_SOCIAIS',     responsaveis:['Maria Gonçalves'],    diretoria:'Alceu Caldeira',   descricao:'Programas e indicadores de saúde', ativo:true },
  { id:'kpi-505', codigo:'5.05', nome:'KPI FROTA',                       area:'PROGRAMAS_SOCIAIS',     responsaveis:['Roberto Zambeli'],    diretoria:'Alceu Caldeira',   descricao:'Gestão da frota de veículos', ativo:true },
  { id:'kpi-507', codigo:'5.07', nome:'KPI DISTRIBUICAO',                area:'PROGRAMAS_SOCIAIS',     responsaveis:['Kathia Cruz','Mirlane Sousa'], diretoria:'Alceu Caldeira', descricao:'Logística de distribuição social', ativo:true },
  { id:'kpi-508', codigo:'5.08', nome:'KPI DESENVOLVIMENTO INSTITUCIONAL', area:'PROGRAMAS_SOCIAIS',   responsaveis:['Alceu Caldeira','Fernando Sanches','Filipe Dorneles'], diretoria:'Alceu Caldeira', descricao:'Desenvolvimento institucional', ativo:true },
  { id:'kpi-510', codigo:'5.10', nome:'KPI CENTRAL DE DOACAO',           area:'PROGRAMAS_SOCIAIS',     responsaveis:['Alexandre Lacorte'],  diretoria:'Alceu Caldeira',   descricao:'Gestão da central de doações', ativo:true },
  { id:'kpi-511', codigo:'5.11', nome:'KPI DI EVENTOS',                area:'PROGRAMAS_SOCIAIS',     responsaveis:['Alceu Caldeira'],     diretoria:'Alceu Caldeira',   descricao:'Desenvolvimento Institucional — Eventos (CCs 96, 99)', ativo:true },
  { id:'kpi-512', codigo:'5.12', nome:'KPI ASSISTENCIA SOCIAL',          area:'PROGRAMAS_SOCIAIS',     responsaveis:['Aurora Dionisio','Diogo Siqueira','Mauriceia Rodrigues','Paulo Souza'], diretoria:'André de Luca', descricao:'Projetos sociais e assistência (CCs 67, 164, 267, 268)', ativo:true },
];

// ── Metas ─────────────────────────────────────────────────────────
// Chave: id_kpi + responsavel (conforme regra de governança)
const METAS = [
  // KPI 0.00 — Indicadores Organizacionais (demo)
  { id:'m-000-1', id_kpi:'kpi-000', codigo_kpi:'0.00', seq:1, nome:'Resultado Institucional Consolidado', descricao:'Superávit/déficit consolidado da instituição no exercício', responsavel:'Daniel Benedetti', diretoria:'Fernando Medeiros', tipo_formato:'monetario', unidade_medida:'R$', bom_quando:'maior', formula_atingimento:'real_sobre_meta', tipo_acumulado:'soma', peso:0.5, status:'Ativa', obs:'', ult_at:'23/07/2026', ativo:true },
  { id:'m-000-2', id_kpi:'kpi-000', codigo_kpi:'0.00', seq:2, nome:'Famílias Atendidas', descricao:'Total de famílias beneficiadas pelos programas sociais no período', responsavel:'Daniel Benedetti', diretoria:'Fernando Medeiros', tipo_formato:'inteiro', unidade_medida:'famílias', bom_quando:'maior', formula_atingimento:'real_sobre_meta', tipo_acumulado:'soma', peso:0.5, status:'Ativa', obs:'', ult_at:'23/07/2026', ativo:true },

  // KPI 1.01 — Administração Central
  { id:'m-101-1', id_kpi:'kpi-101', codigo_kpi:'1.01', seq:1, nome:'Controle de Despesas Adm.', descricao:'Manter despesas administrativas centrais dentro do orçamento aprovado', responsavel:'Daniel Benedetti', diretoria:'Fernando Medeiros', tipo_formato:'monetario', unidade_medida:'R$', bom_quando:'menor', formula_atingimento:'real_sobre_meta', tipo_acumulado:'soma',  peso:0.6, status:'Ativa', obs:'', ult_at:'26/05/2026', ativo:true },
  { id:'m-101-2', id_kpi:'kpi-101', codigo_kpi:'1.01', seq:2, nome:'Índice de Satisfação Interna', descricao:'Pesquisa de satisfação com serviços administrativos (NPS interno)', responsavel:'Daniel Benedetti', diretoria:'Fernando Medeiros', tipo_formato:'decimal', unidade_medida:'pontos', bom_quando:'maior', formula_atingimento:'real_sobre_meta', tipo_acumulado:'media', peso:0.4, status:'Ativa', obs:'', ult_at:'15/03/2026', ativo:true },

  // KPI 1.02 — Recursos Humanos
  { id:'m-102-1', id_kpi:'kpi-102', codigo_kpi:'1.02', seq:1, nome:'Taxa de Turnover', descricao:'Percentual de saídas voluntárias em relação ao quadro total', responsavel:'Gisele Carneiro', diretoria:'Fernando Medeiros', tipo_formato:'percentual', unidade_medida:'%', bom_quando:'menor', formula_atingimento:'real_sobre_meta', tipo_acumulado:'media', peso:0.4, status:'Ativa', obs:'', ult_at:'30/04/2026', ativo:true },
  { id:'m-102-2', id_kpi:'kpi-102', codigo_kpi:'1.02', seq:2, nome:'Posições Preenchidas', descricao:'Percentual de vagas preenchidas em relação ao headcount aprovado', responsavel:'Gisele Carneiro', diretoria:'Fernando Medeiros', tipo_formato:'percentual', unidade_medida:'%', bom_quando:'maior', formula_atingimento:'real_sobre_meta', tipo_acumulado:'media', peso:0.6, status:'Ativa', obs:'Vagas de campo apresentam maior dificuldade de preenchimento', ult_at:'30/04/2026', ativo:true },

  // KPI 3.01 — Produção (baseado em Modelo METAS CLAUDE.xlsx)
  { id:'m-301-1', id_kpi:'kpi-301', codigo_kpi:'3.01', seq:1, nome:'Despesas de Produção', descricao:'Controle total de despesas operacionais da unidade produtiva de amêndoa', responsavel:'Roberto Barroso', diretoria:'Alcione Albanesi', tipo_formato:'monetario', unidade_medida:'R$', bom_quando:'menor', formula_atingimento:'real_sobre_meta', tipo_acumulado:'soma',  peso:0.5, status:'Ativa', obs:'Impacto da alta do diesel e insumos no Q1', ult_at:'30/04/2026', ativo:true },
  { id:'m-301-2', id_kpi:'kpi-301', codigo_kpi:'3.01', seq:2, nome:'Custo Base Amêndoa', descricao:'Custo unitário médio da base amêndoa (produção própria + compra)', responsavel:'Roberto Barroso', diretoria:'Alcione Albanesi', tipo_formato:'decimal', unidade_medida:'R$/kg', bom_quando:'menor', formula_atingimento:'real_sobre_meta', tipo_acumulado:'media', peso:0.3, status:'Ativa', obs:'', ult_at:'30/04/2026', ativo:true },
  { id:'m-301-3', id_kpi:'kpi-301', codigo_kpi:'3.01', seq:3, nome:'Produção Total', descricao:'Volume total de amêndoa produzida no período (meta de produção)', responsavel:'Roberto Barroso', diretoria:'Alcione Albanesi', tipo_formato:'inteiro', unidade_medida:'kg', bom_quando:'maior', formula_atingimento:'real_sobre_meta', tipo_acumulado:'soma',  peso:0.2, status:'Ativa', obs:'Safra impactada por estiagem em mar/abr', ult_at:'30/04/2026', ativo:true },
];

// ── Metas Mensais ─────────────────────────────────────────────────
// ano, mes (1-12), valor_meta, valor_realizado (null = não apurado)
const METAS_MENSAIS = [
  // KPI 0.00 — Meta 1 (Resultado Institucional — Maior — Moeda)
  { id:'mm-000-1-1', id_meta:'m-000-1', ano:2026, mes:1, valor_meta:500000, valor_realizado:520000 },
  { id:'mm-000-1-2', id_meta:'m-000-1', ano:2026, mes:2, valor_meta:500000, valor_realizado:495000 },
  { id:'mm-000-1-3', id_meta:'m-000-1', ano:2026, mes:3, valor_meta:500000, valor_realizado:540000 },
  { id:'mm-000-1-4', id_meta:'m-000-1', ano:2026, mes:4, valor_meta:500000, valor_realizado:510000 },
  { id:'mm-000-1-5', id_meta:'m-000-1', ano:2026, mes:5, valor_meta:500000, valor_realizado:null   },
  { id:'mm-000-1-6', id_meta:'m-000-1', ano:2026, mes:6, valor_meta:500000, valor_realizado:null   },
  { id:'mm-000-1-7', id_meta:'m-000-1', ano:2026, mes:7, valor_meta:500000, valor_realizado:null   },
  { id:'mm-000-1-8', id_meta:'m-000-1', ano:2026, mes:8, valor_meta:500000, valor_realizado:null   },
  { id:'mm-000-1-9', id_meta:'m-000-1', ano:2026, mes:9, valor_meta:500000, valor_realizado:null   },
  { id:'mm-000-1-10',id_meta:'m-000-1', ano:2026, mes:10,valor_meta:500000, valor_realizado:null   },
  { id:'mm-000-1-11',id_meta:'m-000-1', ano:2026, mes:11,valor_meta:500000, valor_realizado:null   },
  { id:'mm-000-1-12',id_meta:'m-000-1', ano:2026, mes:12,valor_meta:500000, valor_realizado:null   },
  // KPI 0.00 — Meta 2 (Famílias Atendidas — Maior — Inteiro)
  { id:'mm-000-2-1', id_meta:'m-000-2', ano:2026, mes:1, valor_meta:1200, valor_realizado:1180 },
  { id:'mm-000-2-2', id_meta:'m-000-2', ano:2026, mes:2, valor_meta:1200, valor_realizado:1250 },
  { id:'mm-000-2-3', id_meta:'m-000-2', ano:2026, mes:3, valor_meta:1200, valor_realizado:1310 },
  { id:'mm-000-2-4', id_meta:'m-000-2', ano:2026, mes:4, valor_meta:1200, valor_realizado:1290 },
  { id:'mm-000-2-5', id_meta:'m-000-2', ano:2026, mes:5, valor_meta:1200, valor_realizado:null },
  { id:'mm-000-2-6', id_meta:'m-000-2', ano:2026, mes:6, valor_meta:1200, valor_realizado:null },
  { id:'mm-000-2-7', id_meta:'m-000-2', ano:2026, mes:7, valor_meta:1200, valor_realizado:null },
  { id:'mm-000-2-8', id_meta:'m-000-2', ano:2026, mes:8, valor_meta:1200, valor_realizado:null },
  { id:'mm-000-2-9', id_meta:'m-000-2', ano:2026, mes:9, valor_meta:1200, valor_realizado:null },
  { id:'mm-000-2-10',id_meta:'m-000-2', ano:2026, mes:10,valor_meta:1200, valor_realizado:null },
  { id:'mm-000-2-11',id_meta:'m-000-2', ano:2026, mes:11,valor_meta:1200, valor_realizado:null },
  { id:'mm-000-2-12',id_meta:'m-000-2', ano:2026, mes:12,valor_meta:1200, valor_realizado:null },

  // KPI 1.01 — Meta 1 (Despesas Adm. — Menor — Moeda)
  { id:'mm-101-1-1',  id_meta:'m-101-1', ano:2026, mes:1,  valor_meta:195000,  valor_realizado:182000 },
  { id:'mm-101-1-2',  id_meta:'m-101-1', ano:2026, mes:2,  valor_meta:195000,  valor_realizado:188000 },
  { id:'mm-101-1-3',  id_meta:'m-101-1', ano:2026, mes:3,  valor_meta:195000,  valor_realizado:201000 },
  { id:'mm-101-1-4',  id_meta:'m-101-1', ano:2026, mes:4,  valor_meta:195000,  valor_realizado:178000 },
  { id:'mm-101-1-5',  id_meta:'m-101-1', ano:2026, mes:5,  valor_meta:195000,  valor_realizado:null   },
  { id:'mm-101-1-6',  id_meta:'m-101-1', ano:2026, mes:6,  valor_meta:195000,  valor_realizado:null   },
  { id:'mm-101-1-7',  id_meta:'m-101-1', ano:2026, mes:7,  valor_meta:195000,  valor_realizado:null   },
  { id:'mm-101-1-8',  id_meta:'m-101-1', ano:2026, mes:8,  valor_meta:195000,  valor_realizado:null   },
  { id:'mm-101-1-9',  id_meta:'m-101-1', ano:2026, mes:9,  valor_meta:195000,  valor_realizado:null   },
  { id:'mm-101-1-10', id_meta:'m-101-1', ano:2026, mes:10, valor_meta:195000,  valor_realizado:null   },
  { id:'mm-101-1-11', id_meta:'m-101-1', ano:2026, mes:11, valor_meta:195000,  valor_realizado:null   },
  { id:'mm-101-1-12', id_meta:'m-101-1', ano:2026, mes:12, valor_meta:195000,  valor_realizado:null   },

  // KPI 1.01 — Meta 2 (Satisfação Interna — Maior — Decimal)
  { id:'mm-101-2-1',  id_meta:'m-101-2', ano:2026, mes:1,  valor_meta:7.5,  valor_realizado:null },
  { id:'mm-101-2-2',  id_meta:'m-101-2', ano:2026, mes:2,  valor_meta:7.5,  valor_realizado:null },
  { id:'mm-101-2-3',  id_meta:'m-101-2', ano:2026, mes:3,  valor_meta:7.5,  valor_realizado:8.1  },
  { id:'mm-101-2-4',  id_meta:'m-101-2', ano:2026, mes:4,  valor_meta:7.5,  valor_realizado:null },
  { id:'mm-101-2-5',  id_meta:'m-101-2', ano:2026, mes:5,  valor_meta:7.5,  valor_realizado:null },
  { id:'mm-101-2-6',  id_meta:'m-101-2', ano:2026, mes:6,  valor_meta:8.0,  valor_realizado:null },
  { id:'mm-101-2-7',  id_meta:'m-101-2', ano:2026, mes:7,  valor_meta:8.0,  valor_realizado:null },
  { id:'mm-101-2-8',  id_meta:'m-101-2', ano:2026, mes:8,  valor_meta:8.0,  valor_realizado:null },
  { id:'mm-101-2-9',  id_meta:'m-101-2', ano:2026, mes:9,  valor_meta:8.0,  valor_realizado:null },
  { id:'mm-101-2-10', id_meta:'m-101-2', ano:2026, mes:10, valor_meta:8.0,  valor_realizado:null },
  { id:'mm-101-2-11', id_meta:'m-101-2', ano:2026, mes:11, valor_meta:8.0,  valor_realizado:null },
  { id:'mm-101-2-12', id_meta:'m-101-2', ano:2026, mes:12, valor_meta:8.0,  valor_realizado:null },

  // KPI 1.02 — Meta 1 (Turnover — Menor — Percentual)
  { id:'mm-102-1-1',  id_meta:'m-102-1', ano:2026, mes:1,  valor_meta:0.02, valor_realizado:0.018 },
  { id:'mm-102-1-2',  id_meta:'m-102-1', ano:2026, mes:2,  valor_meta:0.02, valor_realizado:0.015 },
  { id:'mm-102-1-3',  id_meta:'m-102-1', ano:2026, mes:3,  valor_meta:0.02, valor_realizado:0.023 },
  { id:'mm-102-1-4',  id_meta:'m-102-1', ano:2026, mes:4,  valor_meta:0.02, valor_realizado:0.019 },
  { id:'mm-102-1-5',  id_meta:'m-102-1', ano:2026, mes:5,  valor_meta:0.02, valor_realizado:null  },
  { id:'mm-102-1-6',  id_meta:'m-102-1', ano:2026, mes:6,  valor_meta:0.02, valor_realizado:null  },
  { id:'mm-102-1-7',  id_meta:'m-102-1', ano:2026, mes:7,  valor_meta:0.02, valor_realizado:null  },
  { id:'mm-102-1-8',  id_meta:'m-102-1', ano:2026, mes:8,  valor_meta:0.02, valor_realizado:null  },
  { id:'mm-102-1-9',  id_meta:'m-102-1', ano:2026, mes:9,  valor_meta:0.02, valor_realizado:null  },
  { id:'mm-102-1-10', id_meta:'m-102-1', ano:2026, mes:10, valor_meta:0.02, valor_realizado:null  },
  { id:'mm-102-1-11', id_meta:'m-102-1', ano:2026, mes:11, valor_meta:0.02, valor_realizado:null  },
  { id:'mm-102-1-12', id_meta:'m-102-1', ano:2026, mes:12, valor_meta:0.02, valor_realizado:null  },

  // KPI 1.02 — Meta 2 (Posições Preenchidas — Maior — Percentual)
  { id:'mm-102-2-1',  id_meta:'m-102-2', ano:2026, mes:1,  valor_meta:0.95, valor_realizado:0.88 },
  { id:'mm-102-2-2',  id_meta:'m-102-2', ano:2026, mes:2,  valor_meta:0.95, valor_realizado:0.91 },
  { id:'mm-102-2-3',  id_meta:'m-102-2', ano:2026, mes:3,  valor_meta:0.95, valor_realizado:0.89 },
  { id:'mm-102-2-4',  id_meta:'m-102-2', ano:2026, mes:4,  valor_meta:0.95, valor_realizado:0.92 },
  { id:'mm-102-2-5',  id_meta:'m-102-2', ano:2026, mes:5,  valor_meta:0.95, valor_realizado:null },
  { id:'mm-102-2-6',  id_meta:'m-102-2', ano:2026, mes:6,  valor_meta:0.95, valor_realizado:null },
  { id:'mm-102-2-7',  id_meta:'m-102-2', ano:2026, mes:7,  valor_meta:0.95, valor_realizado:null },
  { id:'mm-102-2-8',  id_meta:'m-102-2', ano:2026, mes:8,  valor_meta:0.95, valor_realizado:null },
  { id:'mm-102-2-9',  id_meta:'m-102-2', ano:2026, mes:9,  valor_meta:0.95, valor_realizado:null },
  { id:'mm-102-2-10', id_meta:'m-102-2', ano:2026, mes:10, valor_meta:0.95, valor_realizado:null },
  { id:'mm-102-2-11', id_meta:'m-102-2', ano:2026, mes:11, valor_meta:0.95, valor_realizado:null },
  { id:'mm-102-2-12', id_meta:'m-102-2', ano:2026, mes:12, valor_meta:0.95, valor_realizado:null },

  // KPI 3.01 — Meta 1 (Despesas Produção — Menor — Moeda)
  { id:'mm-301-1-1',  id_meta:'m-301-1', ano:2026, mes:1,  valor_meta:2700000, valor_realizado:2876890 },
  { id:'mm-301-1-2',  id_meta:'m-301-1', ano:2026, mes:2,  valor_meta:2100000, valor_realizado:2339421 },
  { id:'mm-301-1-3',  id_meta:'m-301-1', ano:2026, mes:3,  valor_meta:2500000, valor_realizado:2687405 },
  { id:'mm-301-1-4',  id_meta:'m-301-1', ano:2026, mes:4,  valor_meta:2200000, valor_realizado:2349045 },
  { id:'mm-301-1-5',  id_meta:'m-301-1', ano:2026, mes:5,  valor_meta:2400000, valor_realizado:null    },
  { id:'mm-301-1-6',  id_meta:'m-301-1', ano:2026, mes:6,  valor_meta:2300000, valor_realizado:null    },
  { id:'mm-301-1-7',  id_meta:'m-301-1', ano:2026, mes:7,  valor_meta:2400000, valor_realizado:null    },
  { id:'mm-301-1-8',  id_meta:'m-301-1', ano:2026, mes:8,  valor_meta:2300000, valor_realizado:null    },
  { id:'mm-301-1-9',  id_meta:'m-301-1', ano:2026, mes:9,  valor_meta:2500000, valor_realizado:null    },
  { id:'mm-301-1-10', id_meta:'m-301-1', ano:2026, mes:10, valor_meta:2600000, valor_realizado:null    },
  { id:'mm-301-1-11', id_meta:'m-301-1', ano:2026, mes:11, valor_meta:2700000, valor_realizado:null    },
  { id:'mm-301-1-12', id_meta:'m-301-1', ano:2026, mes:12, valor_meta:2800000, valor_realizado:null    },

  // KPI 3.01 — Meta 2 (Custo Base Amêndoa — Menor — Decimal)
  { id:'mm-301-2-1',  id_meta:'m-301-2', ano:2026, mes:1,  valor_meta:42.6, valor_realizado:41.1 },
  { id:'mm-301-2-2',  id_meta:'m-301-2', ano:2026, mes:2,  valor_meta:42.6, valor_realizado:41.7 },
  { id:'mm-301-2-3',  id_meta:'m-301-2', ano:2026, mes:3,  valor_meta:42.6, valor_realizado:42.3 },
  { id:'mm-301-2-4',  id_meta:'m-301-2', ano:2026, mes:4,  valor_meta:45.0, valor_realizado:44.9 },
  { id:'mm-301-2-5',  id_meta:'m-301-2', ano:2026, mes:5,  valor_meta:45.0, valor_realizado:null },
  { id:'mm-301-2-6',  id_meta:'m-301-2', ano:2026, mes:6,  valor_meta:45.0, valor_realizado:null },
  { id:'mm-301-2-7',  id_meta:'m-301-2', ano:2026, mes:7,  valor_meta:45.0, valor_realizado:null },
  { id:'mm-301-2-8',  id_meta:'m-301-2', ano:2026, mes:8,  valor_meta:45.0, valor_realizado:null },
  { id:'mm-301-2-9',  id_meta:'m-301-2', ano:2026, mes:9,  valor_meta:45.0, valor_realizado:null },
  { id:'mm-301-2-10', id_meta:'m-301-2', ano:2026, mes:10, valor_meta:45.0, valor_realizado:null },
  { id:'mm-301-2-11', id_meta:'m-301-2', ano:2026, mes:11, valor_meta:45.0, valor_realizado:null },
  { id:'mm-301-2-12', id_meta:'m-301-2', ano:2026, mes:12, valor_meta:45.0, valor_realizado:null },

  // KPI 3.01 — Meta 3 (Produção Total — Maior — Inteiro)
  { id:'mm-301-3-1',  id_meta:'m-301-3', ano:2026, mes:1,  valor_meta:25200, valor_realizado:21509 },
  { id:'mm-301-3-2',  id_meta:'m-301-3', ano:2026, mes:2,  valor_meta:25200, valor_realizado:16414 },
  { id:'mm-301-3-3',  id_meta:'m-301-3', ano:2026, mes:3,  valor_meta:25200, valor_realizado:15233 },
  { id:'mm-301-3-4',  id_meta:'m-301-3', ano:2026, mes:4,  valor_meta:25200, valor_realizado:28879 },
  { id:'mm-301-3-5',  id_meta:'m-301-3', ano:2026, mes:5,  valor_meta:26248, valor_realizado:null  },
  { id:'mm-301-3-6',  id_meta:'m-301-3', ano:2026, mes:6,  valor_meta:26248, valor_realizado:null  },
  { id:'mm-301-3-7',  id_meta:'m-301-3', ano:2026, mes:7,  valor_meta:26248, valor_realizado:null  },
  { id:'mm-301-3-8',  id_meta:'m-301-3', ano:2026, mes:8,  valor_meta:26248, valor_realizado:null  },
  { id:'mm-301-3-9',  id_meta:'m-301-3', ano:2026, mes:9,  valor_meta:26248, valor_realizado:null  },
  { id:'mm-301-3-10', id_meta:'m-301-3', ano:2026, mes:10, valor_meta:26248, valor_realizado:null  },
  { id:'mm-301-3-11', id_meta:'m-301-3', ano:2026, mes:11, valor_meta:26248, valor_realizado:null  },
  { id:'mm-301-3-12', id_meta:'m-301-3', ano:2026, mes:12, valor_meta:26248, valor_realizado:null  },
];

// ── Projetos ──────────────────────────────────────────────────────
const PROJETOS = [
  { id:'p-1', id_meta:'m-301-1', id_kpi:'kpi-301', nome:'Redução de Custos Operacionais — Fase 1',       descricao:'Mapeamento e eliminação de desperdícios na linha de produção. Inclui revisão de contratos de insumos e renegociação com fornecedores.',    responsavel:'Roberto Barroso', status:'Em andamento', prazo:'2026-06-30', percentual_evolucao:45, prioridade:'Alta',  proxima_acao:'Reunião de alinhamento com equipe de produção para revisar processo de colheita', responsavel_acao:'Filipe Dorneles',    obs:'Negociação com fornecedor de diesel em andamento', ativo:true, data_criacao:'2026-01-15', data_atualizacao:'2026-04-10', usuario_atualizacao:'roberto.barroso@amigosdobem.org.br' },
  { id:'p-2', id_meta:'m-301-3', id_kpi:'kpi-301', nome:'Expansão da Capacidade Produtiva — Sertão Norte', descricao:'Implantação de novo módulo de beneficiamento para aumentar a capacidade de processamento de amêndoa.',                                     responsavel:'Roberto Barroso', status:'Não iniciado', prazo:'2026-09-30', percentual_evolucao:0,  prioridade:'Média', proxima_acao:'Elaborar projeto executivo e solicitar orçamentos',                              responsavel_acao:'Roberto Barroso',    obs:'Aguardando aprovação orçamentária da Diretoria',   ativo:true, data_criacao:'2026-02-01', data_atualizacao:'2026-02-01', usuario_atualizacao:'roberto.barroso@amigosdobem.org.br' },
  { id:'p-3', id_meta:'m-301-2', id_kpi:'kpi-301', nome:'Otimização do Processo de Beneficiamento',       descricao:'Revisão do fluxo de beneficiamento para reduzir perdas e custo unitário da amêndoa processada.',                                          responsavel:'Filipe Dorneles',  status:'Em andamento', prazo:'2026-07-31', percentual_evolucao:70, prioridade:'Alta',  proxima_acao:'Validar novo layout do galpão com o setor de engenharia',                       responsavel_acao:'Edmilson Lima',      obs:'Fase de testes concluída com resultado positivo',   ativo:true, data_criacao:'2026-01-20', data_atualizacao:'2026-04-25', usuario_atualizacao:'roberto.barroso@amigosdobem.org.br' },
  { id:'p-4', id_meta:'m-101-1', id_kpi:'kpi-101', nome:'Revisão de Contratos de Fornecedores Adm.',      descricao:'Renegociação dos principais contratos de serviços administrativos para redução de custos fixos.',                                           responsavel:'Daniel Benedetti', status:'Concluído',    prazo:'2026-03-31', percentual_evolucao:100,prioridade:'Alta',  proxima_acao:'Monitorar execução dos novos contratos',                                       responsavel_acao:'Roberto Zambeli',    obs:'Economia estimada de R$ 48 mil/ano',               ativo:true, data_criacao:'2026-01-05', data_atualizacao:'2026-03-28', usuario_atualizacao:'daniel.benedetti@amigosdobem.org.br' },
  { id:'p-5', id_meta:'m-102-2', id_kpi:'kpi-102', nome:'Banco de Talentos — Campo',                     descricao:'Criação de banco de talentos para agilizar preenchimento de vagas operacionais no Sertão.',                                              responsavel:'Gisele Carneiro',  status:'Em andamento', prazo:'2026-08-31', percentual_evolucao:30, prioridade:'Média', proxima_acao:'Publicar vagas nos canais regionais parceiros',                                 responsavel_acao:'Kathia Cruz',        obs:'Parceria com SINE local em negociação',            ativo:true, data_criacao:'2026-03-10', data_atualizacao:'2026-04-15', usuario_atualizacao:'gisele.carneiro@amigosdobem.org.br' },
];

// ── Logs (mock inicial) ───────────────────────────────────────────
const LOGS = [
  { id:'log-1', data_hora:'2026-04-30 14:22', usuario:'roberto.barroso@amigosdobem.org.br', acao:'UPDATE', tabela:'metas_mensais', id_registro:'mm-301-3-4', campo:'valor_realizado', antes:'null', depois:'28879',   obs:'' },
  { id:'log-2', data_hora:'2026-04-30 14:20', usuario:'roberto.barroso@amigosdobem.org.br', acao:'UPDATE', tabela:'metas_mensais', id_registro:'mm-301-1-4', campo:'valor_realizado', antes:'null', depois:'2349045', obs:'' },
  { id:'log-3', data_hora:'2026-04-30 14:18', usuario:'roberto.barroso@amigosdobem.org.br', acao:'UPDATE', tabela:'metas_mensais', id_registro:'mm-301-2-4', campo:'valor_realizado', antes:'null', depois:'44.9',    obs:'' },
  { id:'log-4', data_hora:'2026-03-28 09:15', usuario:'daniel.benedetti@amigosdobem.org.br', acao:'UPDATE', tabela:'projetos',     id_registro:'p-4',         campo:'status',          antes:'Em andamento', depois:'Concluído', obs:'' },
];

// ── Comentários do KPI (mural Controladoria ↔ Gestor) — demo ──────
const COMENTARIOS = [
  { id:'c-1', id_kpi:'kpi-301', autor_nome:'Roberto Barroso',  autor_email:'roberto.barroso@amigosdobem.org.br',  autor_papel:'Gestor',        texto:'Solicito revisão da meta de Despesas de Produção de maio — o diesel subiu acima do previsto.', criado_em:'2026-05-04T13:20:00' },
  { id:'c-2', id_kpi:'kpi-301', autor_nome:'Daniel Benedetti', autor_email:'daniel.benedetti@amigosdobem.org.br', autor_papel:'Controladoria', texto:'Recebido, Roberto. Vou analisar o realizado de abril e retorno com a proposta de ajuste.', criado_em:'2026-05-04T15:05:00' },
];

// ── Estado mútavel (in-memory durante a sessão) ───────────────────
// Em modo demo os arrays são populados com os dados acima.
// Em modo live (Supabase) api.js substitui o conteúdo após login.
let DB = {
  usuario:      null,
  kpis:         [],
  metas:        JSON.parse(JSON.stringify(METAS)),
  metasMensais: JSON.parse(JSON.stringify(METAS_MENSAIS)),
  projetos:     JSON.parse(JSON.stringify(PROJETOS)),
  logs:         JSON.parse(JSON.stringify(LOGS)),
  comentarios:  JSON.parse(JSON.stringify(COMENTARIOS)),
};
