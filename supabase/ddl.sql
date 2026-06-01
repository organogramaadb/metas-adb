-- ====================================================================
-- Supabase DDL — Acompanhamento de Metas Amigos do Bem
-- Execute este script no SQL Editor do Supabase (uma única vez)
-- Versão: 2026-06 | Compatível com PostgreSQL 15+
-- ====================================================================

-- ── Extensão ────────────────────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ====================================================================
-- TABELAS
-- ====================================================================

-- ── usuarios ─────────────────────────────────────────────────────────
-- Perfil estendido vinculado a auth.users (mesmo UUID)
CREATE TABLE IF NOT EXISTS public.usuarios (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nome                TEXT NOT NULL,
  email               TEXT UNIQUE NOT NULL,
  perfil_acesso       TEXT NOT NULL CHECK (perfil_acesso IN ('administrador','diretoria_n1','diretor','responsavel')),
  responsavel_vinculado TEXT,        -- nome exato como aparece em kpi_responsaveis.responsavel
  diretoria_vinculada TEXT,
  ativo               BOOLEAN DEFAULT TRUE,
  data_criacao        TIMESTAMPTZ DEFAULT NOW(),
  ultimo_login        TIMESTAMPTZ,
  criado_por          UUID REFERENCES public.usuarios(id) ON DELETE SET NULL
);
COMMENT ON TABLE  public.usuarios                    IS 'Perfil estendido. Auth primário em auth.users (mesmo UUID).';
COMMENT ON COLUMN public.usuarios.responsavel_vinculado IS 'Nome exato correspondente a kpi_responsaveis.responsavel. Usado pelo RLS.';

-- ── kpis ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.kpis (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo          TEXT NOT NULL,               -- ex: "4.01" — NÃO é unique
  nome            TEXT NOT NULL,               -- ex: "KPI OBRAS E PROJETOS SD"
  nome_completo   TEXT NOT NULL UNIQUE,        -- ex: "4.01 - KPI OBRAS E PROJETOS SD"
  area            TEXT NOT NULL CHECK (area IN (
                    'ADMINISTRATIVOS','EDUCACAO','AREA_PRODUTIVA',
                    'INVESTIMENTOS_SOCIAIS','PROGRAMAS_SOCIAIS')),
  descricao       TEXT,
  ordem_exibicao  INTEGER,
  ativo           BOOLEAN DEFAULT TRUE,
  criado_em       TIMESTAMPTZ DEFAULT NOW()
);
COMMENT ON COLUMN public.kpis.codigo        IS 'Número base (ex: 4.01). Não é unique — KPIs distintos podem compartilhar o mesmo código.';
COMMENT ON COLUMN public.kpis.nome_completo IS 'Identificador único para exibição. Use sempre este campo na interface, nunca apenas o codigo.';

-- ── kpi_responsaveis ─────────────────────────────────────────────────
-- Tabela N:M: um KPI pode ter múltiplos responsáveis
CREATE TABLE IF NOT EXISTS public.kpi_responsaveis (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_kpi      UUID NOT NULL REFERENCES public.kpis(id) ON DELETE CASCADE,
  responsavel TEXT NOT NULL,          -- nome exato (case-sensitive) — deve bater com usuarios.responsavel_vinculado
  diretor     TEXT,
  ativo       BOOLEAN DEFAULT TRUE,
  UNIQUE(id_kpi, responsavel)
);
COMMENT ON COLUMN public.kpi_responsaveis.responsavel IS 'Nome exato. Deve ser idêntico a usuarios.responsavel_vinculado para o RLS funcionar.';

-- ── centros_custo ─────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.centros_custo (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  codigo        INTEGER UNIQUE,
  classificacao TEXT,
  unidade       TEXT,                 -- SP, CATIMBAU, CEARA, INAJA, TORROES
  pilar         TEXT,
  nome          TEXT NOT NULL,
  tipo          CHAR(1) CHECK (tipo IN ('A','S')),  -- A=analítico, S=sintético
  cd_grpg       TEXT,                 -- código de agrupamento de KPI
  id_kpi        UUID REFERENCES public.kpis(id) ON DELETE SET NULL,
  setor_local   TEXT,
  responsavel   TEXT,
  objetivo      TEXT,
  diretoria     TEXT,
  requisitante1 TEXT,
  requisitante2 TEXT,
  requisitante3 TEXT,
  ativo         BOOLEAN DEFAULT TRUE
);

-- ── metas ─────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.metas (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_kpi              UUID NOT NULL REFERENCES public.kpis(id) ON DELETE CASCADE,
  id_kpi_responsavel  UUID NOT NULL REFERENCES public.kpi_responsaveis(id) ON DELETE RESTRICT,
  numero_meta         INTEGER NOT NULL,        -- 1, 2, 3... por KPI+responsável
  nome_curto          TEXT NOT NULL,
  descricao           TEXT,
  metrica             TEXT,
  unidade_medida      TEXT,
  tipo_formato        TEXT NOT NULL CHECK (tipo_formato IN ('inteiro','percentual','monetario','decimal')),
  bom_quando          TEXT NOT NULL CHECK (bom_quando IN ('maior','menor')),
  peso                NUMERIC(5,2) NOT NULL,
  criterio_pontuacao  TEXT,
  formula_atingimento TEXT DEFAULT 'real_sobre_meta',  -- real_sobre_meta | meta_sobre_real
  tipo_acumulado      TEXT DEFAULT 'soma',              -- soma | media
  status_meta         TEXT DEFAULT 'ativa' CHECK (status_meta IN ('ativa','suspensa','encerrada')),
  ano                 INTEGER NOT NULL DEFAULT EXTRACT(YEAR FROM NOW())::INTEGER,
  ativo               BOOLEAN DEFAULT TRUE,
  criado_em           TIMESTAMPTZ DEFAULT NOW(),
  atualizado_em       TIMESTAMPTZ DEFAULT NOW(),
  atualizado_por      UUID REFERENCES public.usuarios(id) ON DELETE SET NULL
);

-- ── metas_mensais ─────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.metas_mensais (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_meta             UUID NOT NULL REFERENCES public.metas(id) ON DELETE CASCADE,
  ano                 INTEGER NOT NULL,
  mes                 INTEGER NOT NULL CHECK (mes BETWEEN 1 AND 12),
  valor_meta          NUMERIC(18,4),
  valor_realizado     NUMERIC(18,4),           -- NULL = mês ainda não encerrado
  origem_realizado    TEXT DEFAULT 'manual' CHECK (origem_realizado IN ('manual','erp','n8n')),
  data_atualizacao    TIMESTAMPTZ DEFAULT NOW(),
  usuario_atualizacao UUID REFERENCES public.usuarios(id) ON DELETE SET NULL,
  UNIQUE(id_meta, ano, mes)
);
COMMENT ON COLUMN public.metas_mensais.origem_realizado IS 'erp = dado bloqueado para edição manual; lock aplicado pela RLS e pela UI.';

-- ── kpi_cc_vinculo ────────────────────────────────────────────────────
-- Coração da integração ERP: mapeia quais CCs alimentam cada KPI
CREATE TABLE IF NOT EXISTS public.kpi_cc_vinculo (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_kpi            UUID NOT NULL REFERENCES public.kpis(id) ON DELETE CASCADE,
  codigo_cc         INTEGER NOT NULL REFERENCES public.centros_custo(codigo) ON DELETE RESTRICT,
  tipo_vinculo      TEXT DEFAULT 'direto' CHECK (tipo_vinculo IN ('direto','rateio','informativo')),
  percentual_rateio NUMERIC(5,2) DEFAULT 100,
  ativo             BOOLEAN DEFAULT TRUE,
  UNIQUE(id_kpi, codigo_cc)
);
COMMENT ON TABLE public.kpi_cc_vinculo IS 'Valor realizado do KPI = SUM(saldo_cc) dos CCs vinculados. Configurável pelo admin.';

-- ── projetos ─────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.projetos (
  id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_meta             UUID NOT NULL REFERENCES public.metas(id) ON DELETE CASCADE,
  nome                TEXT NOT NULL,
  descricao           TEXT,
  responsavel         TEXT,
  status              TEXT DEFAULT 'nao_iniciado' CHECK (status IN (
                        'nao_iniciado','em_andamento','em_atraso','concluido','suspenso','cancelado')),
  prazo               DATE,
  percentual_evolucao NUMERIC(5,2) DEFAULT 0,
  prioridade          TEXT CHECK (prioridade IN ('baixa','media','alta','critica')),
  proxima_acao        TEXT,
  responsavel_acao    TEXT,
  observacoes         TEXT,
  ativo               BOOLEAN DEFAULT TRUE,
  criado_em           TIMESTAMPTZ DEFAULT NOW(),
  atualizado_em       TIMESTAMPTZ DEFAULT NOW(),
  atualizado_por      UUID REFERENCES public.usuarios(id) ON DELETE SET NULL
);

-- ── parametros_pontuacao ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.parametros_pontuacao (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_kpi           UUID REFERENCES public.kpis(id) ON DELETE CASCADE,  -- NULL = regra global
  nome_criterio    TEXT,
  faixa_minima     NUMERIC(6,2),
  faixa_maxima     NUMERIC(6,2),
  pontuacao        NUMERIC(5,2),
  teto_atingimento NUMERIC(6,2),
  ativo            BOOLEAN DEFAULT TRUE
);
COMMENT ON COLUMN public.parametros_pontuacao.id_kpi IS 'NULL = regra global aplicada a todos os KPIs sem regra específica.';

-- ── logs_auditoria ────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.logs_auditoria (
  id              BIGSERIAL PRIMARY KEY,
  data_hora       TIMESTAMPTZ DEFAULT NOW(),
  id_usuario      UUID REFERENCES public.usuarios(id) ON DELETE SET NULL,
  nome_usuario    TEXT,
  acao            TEXT NOT NULL,          -- INSERT | UPDATE | DELETE
  tabela_afetada  TEXT NOT NULL,
  id_registro     TEXT,                   -- TEXT para aceitar UUID e BigInt
  campo_alterado  TEXT,
  valor_anterior  TEXT,
  valor_novo      TEXT,
  ip_origem       TEXT,
  sessao_id       TEXT
);

-- ====================================================================
-- ÍNDICES
-- ====================================================================
CREATE INDEX IF NOT EXISTS idx_kpi_resp_kpi       ON public.kpi_responsaveis(id_kpi);
CREATE INDEX IF NOT EXISTS idx_kpi_resp_nome      ON public.kpi_responsaveis(responsavel);
CREATE INDEX IF NOT EXISTS idx_metas_kpi          ON public.metas(id_kpi);
CREATE INDEX IF NOT EXISTS idx_metas_resp         ON public.metas(id_kpi_responsavel);
CREATE INDEX IF NOT EXISTS idx_metas_ano          ON public.metas(ano);
CREATE INDEX IF NOT EXISTS idx_mm_meta            ON public.metas_mensais(id_meta);
CREATE INDEX IF NOT EXISTS idx_mm_ano_mes         ON public.metas_mensais(ano, mes);
CREATE INDEX IF NOT EXISTS idx_proj_meta          ON public.projetos(id_meta);
CREATE INDEX IF NOT EXISTS idx_logs_hora          ON public.logs_auditoria(data_hora DESC);
CREATE INDEX IF NOT EXISTS idx_logs_usuario       ON public.logs_auditoria(id_usuario);
CREATE INDEX IF NOT EXISTS idx_cc_codigo          ON public.centros_custo(codigo);
CREATE INDEX IF NOT EXISTS idx_kpi_cc_kpi         ON public.kpi_cc_vinculo(id_kpi);
CREATE INDEX IF NOT EXISTS idx_usuarios_email     ON public.usuarios(email);
CREATE INDEX IF NOT EXISTS idx_usuarios_resp      ON public.usuarios(responsavel_vinculado);

-- ====================================================================
-- TRIGGERS DE AUDITORIA
-- Gerados pelo banco — garante rastreabilidade mesmo via integração direta
-- ====================================================================

CREATE OR REPLACE FUNCTION public.fn_audit_log()
RETURNS TRIGGER LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO public.logs_auditoria (acao, tabela_afetada, id_registro, valor_anterior, valor_novo)
    VALUES ('INSERT', TG_TABLE_NAME, NEW.id::TEXT, NULL, row_to_json(NEW)::TEXT);
  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO public.logs_auditoria (acao, tabela_afetada, id_registro, valor_anterior, valor_novo)
    VALUES ('UPDATE', TG_TABLE_NAME, NEW.id::TEXT, row_to_json(OLD)::TEXT, row_to_json(NEW)::TEXT);
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO public.logs_auditoria (acao, tabela_afetada, id_registro, valor_anterior, valor_novo)
    VALUES ('DELETE', TG_TABLE_NAME, OLD.id::TEXT, row_to_json(OLD)::TEXT, NULL);
  END IF;
  RETURN COALESCE(NEW, OLD);
END;
$$;

DROP TRIGGER IF EXISTS trg_audit_metas_mensais ON public.metas_mensais;
CREATE TRIGGER trg_audit_metas_mensais
  AFTER INSERT OR UPDATE OR DELETE ON public.metas_mensais
  FOR EACH ROW EXECUTE FUNCTION public.fn_audit_log();

DROP TRIGGER IF EXISTS trg_audit_projetos ON public.projetos;
CREATE TRIGGER trg_audit_projetos
  AFTER INSERT OR UPDATE OR DELETE ON public.projetos
  FOR EACH ROW EXECUTE FUNCTION public.fn_audit_log();

DROP TRIGGER IF EXISTS trg_audit_metas ON public.metas;
CREATE TRIGGER trg_audit_metas
  AFTER INSERT OR UPDATE OR DELETE ON public.metas
  FOR EACH ROW EXECUTE FUNCTION public.fn_audit_log();

-- Trigger: atualiza atualizado_em automaticamente
CREATE OR REPLACE FUNCTION public.fn_set_atualizado_em()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.atualizado_em = NOW();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_metas_atualizado_em ON public.metas;
CREATE TRIGGER trg_metas_atualizado_em
  BEFORE UPDATE ON public.metas
  FOR EACH ROW EXECUTE FUNCTION public.fn_set_atualizado_em();

DROP TRIGGER IF EXISTS trg_projetos_atualizado_em ON public.projetos;
CREATE TRIGGER trg_projetos_atualizado_em
  BEFORE UPDATE ON public.projetos
  FOR EACH ROW EXECUTE FUNCTION public.fn_set_atualizado_em();

-- ====================================================================
-- ROW LEVEL SECURITY (RLS)
-- ====================================================================

ALTER TABLE public.kpis             ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.kpi_responsaveis ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.metas            ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.metas_mensais    ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projetos         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.usuarios         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.logs_auditoria   ENABLE ROW LEVEL SECURITY;

-- Funções helper de perfil (chamadas pelo RLS — SECURITY DEFINER evita recursão)
CREATE OR REPLACE FUNCTION public.fn_meu_perfil()
RETURNS TEXT LANGUAGE sql SECURITY DEFINER STABLE SET search_path = public AS $$
  SELECT perfil_acesso FROM public.usuarios WHERE id = auth.uid() LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION public.fn_meu_responsavel()
RETURNS TEXT LANGUAGE sql SECURITY DEFINER STABLE SET search_path = public AS $$
  SELECT responsavel_vinculado FROM public.usuarios WHERE id = auth.uid() LIMIT 1;
$$;

CREATE OR REPLACE FUNCTION public.fn_minha_diretoria()
RETURNS TEXT LANGUAGE sql SECURITY DEFINER STABLE SET search_path = public AS $$
  SELECT diretoria_vinculada FROM public.usuarios WHERE id = auth.uid() LIMIT 1;
$$;

-- ── KPIs: todos os autenticados leem ─────────────────────────────────
DROP POLICY IF EXISTS kpis_leitura        ON public.kpis;
DROP POLICY IF EXISTS kpis_admin_escrita  ON public.kpis;

CREATE POLICY kpis_leitura ON public.kpis
  FOR SELECT TO authenticated USING (ativo = TRUE);

CREATE POLICY kpis_admin_escrita ON public.kpis
  FOR ALL TO authenticated
  USING (fn_meu_perfil() IN ('administrador','diretoria_n1'));

-- ── kpi_responsaveis: todos leem ─────────────────────────────────────
DROP POLICY IF EXISTS kr_leitura       ON public.kpi_responsaveis;
DROP POLICY IF EXISTS kr_admin_escrita ON public.kpi_responsaveis;

CREATE POLICY kr_leitura ON public.kpi_responsaveis
  FOR SELECT TO authenticated USING (ativo = TRUE);

CREATE POLICY kr_admin_escrita ON public.kpi_responsaveis
  FOR ALL TO authenticated
  USING (fn_meu_perfil() IN ('administrador','diretoria_n1'));

-- ── metas ─────────────────────────────────────────────────────────────
DROP POLICY IF EXISTS metas_admin     ON public.metas;
DROP POLICY IF EXISTS metas_resp_sel  ON public.metas;
DROP POLICY IF EXISTS metas_resp_upd  ON public.metas;

CREATE POLICY metas_admin ON public.metas
  FOR ALL TO authenticated
  USING (fn_meu_perfil() IN ('administrador','diretoria_n1'));

CREATE POLICY metas_resp_sel ON public.metas
  FOR SELECT TO authenticated USING (
    EXISTS (
      SELECT 1 FROM public.kpi_responsaveis kr
      WHERE kr.id = metas.id_kpi_responsavel
        AND kr.responsavel = fn_meu_responsavel()
    )
  );

CREATE POLICY metas_resp_upd ON public.metas
  FOR UPDATE TO authenticated USING (
    EXISTS (
      SELECT 1 FROM public.kpi_responsaveis kr
      WHERE kr.id = metas.id_kpi_responsavel
        AND kr.responsavel = fn_meu_responsavel()
    )
  );

-- ── metas_mensais ─────────────────────────────────────────────────────
DROP POLICY IF EXISTS mm_admin    ON public.metas_mensais;
DROP POLICY IF EXISTS mm_resp_sel ON public.metas_mensais;
DROP POLICY IF EXISTS mm_resp_upd ON public.metas_mensais;

CREATE POLICY mm_admin ON public.metas_mensais
  FOR ALL TO authenticated
  USING (fn_meu_perfil() IN ('administrador','diretoria_n1'));

CREATE POLICY mm_resp_sel ON public.metas_mensais
  FOR SELECT TO authenticated USING (
    EXISTS (
      SELECT 1 FROM public.metas m
      JOIN public.kpi_responsaveis kr ON kr.id = m.id_kpi_responsavel
      WHERE m.id = metas_mensais.id_meta
        AND kr.responsavel = fn_meu_responsavel()
    )
  );

-- Responsável só edita realizado de origem 'manual' (ERP é bloqueado)
CREATE POLICY mm_resp_upd ON public.metas_mensais
  FOR UPDATE TO authenticated USING (
    metas_mensais.origem_realizado = 'manual'
    AND EXISTS (
      SELECT 1 FROM public.metas m
      JOIN public.kpi_responsaveis kr ON kr.id = m.id_kpi_responsavel
      WHERE m.id = metas_mensais.id_meta
        AND kr.responsavel = fn_meu_responsavel()
    )
  );

-- ── projetos ─────────────────────────────────────────────────────────
DROP POLICY IF EXISTS proj_admin    ON public.projetos;
DROP POLICY IF EXISTS proj_resp_sel ON public.projetos;
DROP POLICY IF EXISTS proj_resp_all ON public.projetos;

CREATE POLICY proj_admin ON public.projetos
  FOR ALL TO authenticated
  USING (fn_meu_perfil() IN ('administrador','diretoria_n1'));

CREATE POLICY proj_resp_sel ON public.projetos
  FOR SELECT TO authenticated USING (
    EXISTS (
      SELECT 1 FROM public.metas m
      JOIN public.kpi_responsaveis kr ON kr.id = m.id_kpi_responsavel
      WHERE m.id = projetos.id_meta
        AND kr.responsavel = fn_meu_responsavel()
    )
  );

CREATE POLICY proj_resp_all ON public.projetos
  FOR ALL TO authenticated USING (
    EXISTS (
      SELECT 1 FROM public.metas m
      JOIN public.kpi_responsaveis kr ON kr.id = m.id_kpi_responsavel
      WHERE m.id = projetos.id_meta
        AND kr.responsavel = fn_meu_responsavel()
    )
  );

-- ── usuarios ─────────────────────────────────────────────────────────
DROP POLICY IF EXISTS usuarios_self_sel   ON public.usuarios;
DROP POLICY IF EXISTS usuarios_admin_all  ON public.usuarios;

CREATE POLICY usuarios_self_sel ON public.usuarios
  FOR SELECT TO authenticated
  USING (id = auth.uid() OR fn_meu_perfil() IN ('administrador','diretoria_n1'));

CREATE POLICY usuarios_admin_all ON public.usuarios
  FOR ALL TO authenticated
  USING (fn_meu_perfil() = 'administrador');

-- ── logs_auditoria: só admins leem ──────────────────────────────────
DROP POLICY IF EXISTS logs_admin ON public.logs_auditoria;

CREATE POLICY logs_admin ON public.logs_auditoria
  FOR SELECT TO authenticated
  USING (fn_meu_perfil() IN ('administrador','diretoria_n1'));

-- Permite ao sistema inserir logs (service role ou triggers)
CREATE POLICY logs_insert ON public.logs_auditoria
  FOR INSERT TO authenticated WITH CHECK (TRUE);
