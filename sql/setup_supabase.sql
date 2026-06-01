-- ============================================================
-- METAS ADB — Supabase Setup
-- Executar PRIMEIRO no SQL Editor do Supabase
-- ============================================================

-- ── Tabela: usuarios ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS usuarios (
  id         UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email      TEXT UNIQUE NOT NULL,
  nome       TEXT NOT NULL,
  perfil     TEXT NOT NULL CHECK (perfil IN ('Admin','Gestor','Consulta')),
  responsavel TEXT,
  ativo      BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ── Tabela: kpis ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS kpis (
  id          TEXT PRIMARY KEY,
  codigo      TEXT NOT NULL,
  nome        TEXT NOT NULL,
  area        TEXT,
  responsavel TEXT,
  diretoria   TEXT,
  descricao   TEXT,
  ativo       BOOLEAN DEFAULT true,
  created_at  TIMESTAMPTZ DEFAULT now(),
  updated_at  TIMESTAMPTZ DEFAULT now()
);

-- ── Tabela: metas ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS metas (
  id                  TEXT PRIMARY KEY,
  id_kpi              TEXT NOT NULL REFERENCES kpis(id) ON DELETE RESTRICT,
  codigo_kpi          TEXT,
  seq                 INTEGER DEFAULT 1,
  nome                TEXT NOT NULL,
  descricao           TEXT,
  responsavel         TEXT,
  diretoria           TEXT,
  tipo_formato        TEXT NOT NULL DEFAULT 'decimal'
                      CHECK (tipo_formato IN ('numero_inteiro','percentual','moeda','decimal')),
  unidade_medida      TEXT,
  bom_quando          TEXT NOT NULL DEFAULT 'Maior'
                      CHECK (bom_quando IN ('Maior','Menor')),
  peso                NUMERIC(5,4) DEFAULT 0,
  status              TEXT NOT NULL DEFAULT 'Ativa'
                      CHECK (status IN ('Ativa','Suspensa','Concluída')),
  obs                 TEXT,
  formula_atingimento TEXT NOT NULL DEFAULT 'real_sobre_meta'
                      CHECK (formula_atingimento IN ('real_sobre_meta','meta_sobre_real')),
  tipo_acumulado      TEXT NOT NULL DEFAULT 'soma'
                      CHECK (tipo_acumulado IN ('soma','media')),
  ult_at              TIMESTAMPTZ,
  ativo               BOOLEAN DEFAULT true,
  created_at          TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS metas_id_kpi_idx ON metas(id_kpi);
CREATE INDEX IF NOT EXISTS metas_seq_idx    ON metas(id_kpi, seq);

-- ── Tabela: metas_mensais ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS metas_mensais (
  id               TEXT PRIMARY KEY,
  id_meta          TEXT NOT NULL REFERENCES metas(id) ON DELETE CASCADE,
  ano              INTEGER NOT NULL DEFAULT 2026,
  mes              INTEGER NOT NULL CHECK (mes BETWEEN 1 AND 12),
  valor_meta       NUMERIC(18,6),
  valor_realizado  NUMERIC(18,6),
  obs              TEXT,
  updated_at       TIMESTAMPTZ DEFAULT now(),
  UNIQUE (id_meta, ano, mes)
);

CREATE INDEX IF NOT EXISTS mm_id_meta_idx ON metas_mensais(id_meta);
CREATE INDEX IF NOT EXISTS mm_ano_mes_idx ON metas_mensais(ano, mes);

-- ── Tabela: projetos ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS projetos (
  id                    TEXT PRIMARY KEY,
  id_kpi                TEXT REFERENCES kpis(id) ON DELETE SET NULL,
  id_meta               TEXT REFERENCES metas(id) ON DELETE SET NULL,
  nome                  TEXT NOT NULL,
  descricao             TEXT,
  responsavel           TEXT,
  status                TEXT DEFAULT 'Não iniciado'
                        CHECK (status IN ('Não iniciado','Em andamento','Em atraso','Concluído','Suspenso','Cancelado')),
  prioridade            TEXT DEFAULT 'Média'
                        CHECK (prioridade IN ('Alta','Média','Baixa')),
  prazo                 DATE,
  percentual_evolucao   NUMERIC(5,2) DEFAULT 0 CHECK (percentual_evolucao BETWEEN 0 AND 100),
  proxima_acao          TEXT,
  responsavel_acao      TEXT,
  obs                   TEXT,
  ativo                 BOOLEAN DEFAULT true,
  data_criacao          DATE DEFAULT CURRENT_DATE,
  data_atualizacao      DATE DEFAULT CURRENT_DATE,
  usuario_atualizacao   TEXT,
  created_at            TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS projetos_id_kpi_idx  ON projetos(id_kpi);
CREATE INDEX IF NOT EXISTS projetos_id_meta_idx ON projetos(id_meta);
CREATE INDEX IF NOT EXISTS projetos_status_idx  ON projetos(status);

-- ── Tabela: logs ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS logs (
  id           TEXT PRIMARY KEY,
  data_hora    TIMESTAMPTZ DEFAULT now(),
  usuario      TEXT NOT NULL,
  acao         TEXT NOT NULL,
  tabela       TEXT,
  id_registro  TEXT,
  campo        TEXT,
  antes        TEXT,
  depois       TEXT,
  obs          TEXT
);

CREATE INDEX IF NOT EXISTS logs_usuario_idx     ON logs(usuario);
CREATE INDEX IF NOT EXISTS logs_data_hora_idx   ON logs(data_hora DESC);
CREATE INDEX IF NOT EXISTS logs_id_registro_idx ON logs(id_registro);

-- ── Tabela: centros_custo ─────────────────────────────────────
CREATE TABLE IF NOT EXISTS centros_custo (
  codigo        INTEGER PRIMARY KEY,
  classificacao TEXT,
  unidade       TEXT,
  pilar         TEXT,
  nome          TEXT NOT NULL,
  tipo          TEXT,
  cd_grpg       TEXT,
  codigo_kpi    TEXT,
  id_kpi        TEXT REFERENCES kpis(id) ON DELETE SET NULL,
  setor_local   TEXT,
  responsavel   TEXT,
  objetivo      TEXT,
  diretoria     TEXT,
  ativo         BOOLEAN DEFAULT true,
  created_at    TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS cc_id_kpi_idx      ON centros_custo(id_kpi);
CREATE INDEX IF NOT EXISTS cc_unidade_idx     ON centros_custo(unidade);
CREATE INDEX IF NOT EXISTS cc_pilar_idx       ON centros_custo(pilar);
CREATE INDEX IF NOT EXISTS cc_responsavel_idx ON centros_custo(responsavel);

-- ── Habilitar RLS ─────────────────────────────────────────────
ALTER TABLE usuarios      ENABLE ROW LEVEL SECURITY;
ALTER TABLE kpis          ENABLE ROW LEVEL SECURITY;
ALTER TABLE metas         ENABLE ROW LEVEL SECURITY;
ALTER TABLE metas_mensais ENABLE ROW LEVEL SECURITY;
ALTER TABLE projetos      ENABLE ROW LEVEL SECURITY;
ALTER TABLE logs          ENABLE ROW LEVEL SECURITY;
ALTER TABLE centros_custo ENABLE ROW LEVEL SECURITY;

-- ── Funções auxiliares de permissão ──────────────────────────
CREATE OR REPLACE FUNCTION auth_perfil()
RETURNS TEXT LANGUAGE sql STABLE AS $$
  SELECT perfil FROM usuarios WHERE email = auth.email() AND ativo = true LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION auth_pode_editar()
RETURNS BOOLEAN LANGUAGE sql STABLE AS $$
  SELECT perfil IN ('Admin','Gestor') FROM usuarios
  WHERE email = auth.email() AND ativo = true LIMIT 1;
$$;

-- ── Políticas RLS: usuarios ───────────────────────────────────
CREATE POLICY "usuarios_select" ON usuarios FOR SELECT TO authenticated
  USING (email = auth.email() OR auth_perfil() = 'Admin');

CREATE POLICY "usuarios_insert" ON usuarios FOR INSERT TO authenticated
  WITH CHECK (auth_perfil() = 'Admin');

CREATE POLICY "usuarios_update" ON usuarios FOR UPDATE TO authenticated
  USING (auth_perfil() = 'Admin');

-- ── Políticas RLS: kpis ───────────────────────────────────────
CREATE POLICY "kpis_select" ON kpis FOR SELECT TO authenticated
  USING (
    auth_perfil() IN ('Admin','Consulta')
    OR responsavel = (SELECT nome FROM usuarios WHERE email = auth.email() LIMIT 1)
  );

CREATE POLICY "kpis_write" ON kpis FOR ALL TO authenticated
  USING (auth_perfil() = 'Admin')
  WITH CHECK (auth_perfil() = 'Admin');

-- ── Políticas RLS: metas ──────────────────────────────────────
CREATE POLICY "metas_select" ON metas FOR SELECT TO authenticated
  USING (
    auth_perfil() IN ('Admin','Consulta')
    OR EXISTS (
      SELECT 1 FROM kpis k
      JOIN usuarios u ON u.nome = k.responsavel
      WHERE k.id = metas.id_kpi AND u.email = auth.email()
    )
  );

CREATE POLICY "metas_write" ON metas FOR ALL TO authenticated
  USING (auth_pode_editar())
  WITH CHECK (auth_pode_editar());

-- ── Políticas RLS: metas_mensais ──────────────────────────────
CREATE POLICY "mm_select" ON metas_mensais FOR SELECT TO authenticated USING (true);

CREATE POLICY "mm_write" ON metas_mensais FOR ALL TO authenticated
  USING (auth_pode_editar())
  WITH CHECK (auth_pode_editar());

-- ── Políticas RLS: projetos ───────────────────────────────────
CREATE POLICY "proj_select" ON projetos FOR SELECT TO authenticated USING (true);

CREATE POLICY "proj_write" ON projetos FOR ALL TO authenticated
  USING (auth_pode_editar())
  WITH CHECK (auth_pode_editar());

-- ── Políticas RLS: logs ───────────────────────────────────────
CREATE POLICY "logs_select" ON logs FOR SELECT TO authenticated USING (true);

CREATE POLICY "logs_insert" ON logs FOR INSERT TO authenticated WITH CHECK (true);

-- ── Políticas RLS: centros_custo ──────────────────────────────
CREATE POLICY "cc_select" ON centros_custo FOR SELECT TO authenticated USING (true);

CREATE POLICY "cc_write" ON centros_custo FOR ALL TO authenticated
  USING (auth_perfil() = 'Admin')
  WITH CHECK (auth_perfil() = 'Admin');
