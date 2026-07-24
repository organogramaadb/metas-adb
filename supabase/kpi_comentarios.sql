-- ====================================================================
-- kpi_comentarios — Mural de comunicação Gestor ↔ Controladoria
-- Histórico rolante de comentários por KPI, exibido na aba Observações.
-- Execute UMA VEZ no SQL Editor do Supabase (projeto controladoria).
-- Depende de: kpis, kpi_responsaveis e das funções fn_meu_perfil()/
-- fn_meu_responsavel() já criadas pelo ddl.sql.
-- ====================================================================

CREATE TABLE IF NOT EXISTS public.kpi_comentarios (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  id_kpi       UUID NOT NULL REFERENCES public.kpis(id) ON DELETE CASCADE,
  autor_nome   TEXT NOT NULL,
  autor_email  TEXT,
  autor_papel  TEXT NOT NULL DEFAULT 'Gestor'
                 CHECK (autor_papel IN ('Controladoria','Gestor')),
  texto        TEXT NOT NULL,
  criado_em    TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_kpi_coment_kpi ON public.kpi_comentarios(id_kpi, criado_em);

COMMENT ON TABLE public.kpi_comentarios IS 'Mural de comentários por KPI: comunicação entre Controladoria (admin) e o gestor responsável.';

-- ── RLS ─────────────────────────────────────────────────────────────
ALTER TABLE public.kpi_comentarios ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS coment_admin    ON public.kpi_comentarios;
DROP POLICY IF EXISTS coment_resp_sel ON public.kpi_comentarios;
DROP POLICY IF EXISTS coment_resp_ins ON public.kpi_comentarios;

-- Admin/Diretoria N1: acesso total
CREATE POLICY coment_admin ON public.kpi_comentarios
  FOR ALL TO authenticated
  USING      (fn_meu_perfil() IN ('administrador','diretoria_n1'))
  WITH CHECK (fn_meu_perfil() IN ('administrador','diretoria_n1'));

-- Responsável do KPI: pode LER os comentários dos seus KPIs
CREATE POLICY coment_resp_sel ON public.kpi_comentarios
  FOR SELECT TO authenticated USING (
    EXISTS (
      SELECT 1 FROM public.kpi_responsaveis kr
      WHERE kr.id_kpi = kpi_comentarios.id_kpi
        AND kr.responsavel = fn_meu_responsavel()
    )
  );

-- Responsável do KPI: pode INSERIR comentários nos seus KPIs
CREATE POLICY coment_resp_ins ON public.kpi_comentarios
  FOR INSERT TO authenticated WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.kpi_responsaveis kr
      WHERE kr.id_kpi = kpi_comentarios.id_kpi
        AND kr.responsavel = fn_meu_responsavel()
    )
  );
