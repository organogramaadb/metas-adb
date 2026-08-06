-- ====================================================================
-- Acumulado manual da Meta — nova opção "Entrada Manual" no campo
-- Acumulado (tipo_acumulado), além de "Somar" e "Média".
-- Execute UMA VEZ no SQL Editor do Supabase (projeto metas-adb).
-- ====================================================================
-- O que este script faz:
--   Adiciona duas colunas em public.metas para guardar o valor acumulado
--   digitado manualmente (uma para o planejado/meta, outra para o
--   realizado) — usadas só quando tipo_acumulado = 'manual'.
--
-- Seguro: colunas novas, NULL por padrão, não afetam metas existentes
-- (elas continuam com tipo_acumulado 'soma'/'media' e ignoram estes campos).
-- Não há CHECK constraint em tipo_acumulado hoje, então o valor 'manual'
-- não precisa de nenhuma alteração adicional de schema para ser aceito.
-- ====================================================================

ALTER TABLE public.metas ADD COLUMN IF NOT EXISTS acumulado_meta_manual      NUMERIC(18,4);
ALTER TABLE public.metas ADD COLUMN IF NOT EXISTS acumulado_realizado_manual NUMERIC(18,4);

COMMENT ON COLUMN public.metas.acumulado_meta_manual IS
  'Valor acumulado da META informado manualmente. Só é usado quando metas.tipo_acumulado = ''manual''; nos demais modos fica NULL e o acumulado é calculado a partir de metas_mensais.';
COMMENT ON COLUMN public.metas.acumulado_realizado_manual IS
  'Valor acumulado do REALIZADO informado manualmente. Só é usado quando metas.tipo_acumulado = ''manual''; nos demais modos fica NULL e o acumulado é calculado a partir de metas_mensais.';

-- Conferência
SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'metas'
  AND column_name IN ('acumulado_meta_manual', 'acumulado_realizado_manual');
