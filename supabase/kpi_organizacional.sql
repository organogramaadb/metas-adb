-- ====================================================================
-- KPI 0.00 — INDICADORES ORGANIZACIONAIS
-- Card institucional exclusivo do Administrador, sem centro de custo próprio.
-- Execute UMA VEZ no SQL Editor do Supabase (projeto controladoria).
-- ====================================================================
-- O que este script faz:
--   1. Libera a nova área 'ORGANIZACIONAL' no CHECK da tabela kpis
--   2. Cria o KPI 0.00 (ordem_exibicao = 0 → sempre o primeiro da lista)
--   3. Cria o responsável do KPI (necessário para que metas possam ser
--      cadastradas — a tabela metas exige id_kpi_responsavel)
--
-- Visibilidade: o KPI 0.00 fica oculto para não-administradores pela
-- própria interface (canSeeKPI). As METAS ficam protegidas por RLS —
-- só o administrador (ou o responsável 'Daniel Benedetti') as enxerga.
-- ====================================================================

-- 1. Permitir a área ORGANIZACIONAL ---------------------------------
ALTER TABLE public.kpis DROP CONSTRAINT IF EXISTS kpis_area_check;
ALTER TABLE public.kpis ADD  CONSTRAINT kpis_area_check CHECK (area IN (
  'ORGANIZACIONAL',
  'ADMINISTRATIVOS','EDUCACAO','AREA_PRODUTIVA',
  'INVESTIMENTOS_SOCIAIS','PROGRAMAS_SOCIAIS'));

-- 2. Criar o KPI 0.00 (idempotente via nome_completo UNIQUE) --------
INSERT INTO public.kpis (codigo, nome, nome_completo, area, descricao, ordem_exibicao, ativo)
VALUES (
  '0.00',
  'INDICADORES ORGANIZACIONAIS',
  '0.00 - INDICADORES ORGANIZACIONAIS',
  'ORGANIZACIONAL',
  'Metas institucionais consolidadas — visíveis apenas ao Administrador',
  0,
  TRUE)
ON CONFLICT (nome_completo) DO UPDATE
  SET area = EXCLUDED.area,
      ordem_exibicao = EXCLUDED.ordem_exibicao,
      ativo = TRUE;

-- 3. Responsável do KPI (obrigatório para cadastrar metas) ----------
INSERT INTO public.kpi_responsaveis (id_kpi, responsavel, diretor, ativo)
SELECT id, 'Daniel Benedetti', 'Fernando Medeiros', TRUE
FROM public.kpis
WHERE nome_completo = '0.00 - INDICADORES ORGANIZACIONAIS'
ON CONFLICT (id_kpi, responsavel) DO UPDATE SET ativo = TRUE;

-- Conferência ------------------------------------------------------
SELECT k.codigo, k.nome, k.area, k.ordem_exibicao,
       string_agg(r.responsavel, ', ') AS responsaveis
FROM public.kpis k
LEFT JOIN public.kpi_responsaveis r ON r.id_kpi = k.id AND r.ativo
WHERE k.nome_completo = '0.00 - INDICADORES ORGANIZACIONAIS'
GROUP BY k.codigo, k.nome, k.area, k.ordem_exibicao;
