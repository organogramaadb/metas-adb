-- Total metas: 53 | Total metas_mensais: 517
-- ================================================================
-- IMPORT: metas + metas_mensais — gerado de Modelo KPI 2026_v3.xlsx
-- ================================================================


-- ── KPI 1.01 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000101';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 1.01: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('5f1c41d9-9e1c-40a6-a534-9f42bcd19bee', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 0.8, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '5f1c41d9-9e1c-40a6-a534-9f42bcd19bee';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('16434986-16db-4cf0-b1e7-220e42c2910e', v_meta_id, 2026, 1, -788350.047894, -963236.75, 'erp'),
    ('dbb98738-befe-4818-95f9-296fecd4e1b2', v_meta_id, 2026, 2, -769635.046894, -856949.68, 'erp'),
    ('c98b1c3e-064b-43bf-872e-b6f62d27eedc', v_meta_id, 2026, 3, -767707.812294, -808501.85, 'erp'),
    ('7b7a7fe3-eb41-4859-a5ce-f8482bee586c', v_meta_id, 2026, 4, -794449.284494, NULL, 'manual'),
    ('272e0307-650e-4468-a85a-3efc6fc02966', v_meta_id, 2026, 5, -773957.750894, NULL, 'manual'),
    ('72d33543-8480-4298-bc9b-5019cd5043c6', v_meta_id, 2026, 6, -795329.796894, NULL, 'manual'),
    ('4039710f-b6ff-4c3e-85f7-c1d91f2168fb', v_meta_id, 2026, 7, -829399.992449, NULL, 'manual'),
    ('b4a8759a-23ce-4567-aeae-2736d5016669', v_meta_id, 2026, 8, -810069.312894, NULL, 'manual'),
    ('1024b736-c2bb-4464-bff2-2c556e658d96', v_meta_id, 2026, 9, -812219.793614, NULL, 'manual'),
    ('2451c549-436b-40fa-9580-5962d8116560', v_meta_id, 2026, 10, -816015.617644, NULL, 'manual'),
    ('86cab03e-8abd-4c63-9693-2b37c8b16d58', v_meta_id, 2026, 11, -762352.406894, NULL, 'manual'),
    ('dc61f889-0810-4ddd-b954-2641d59d33e6', v_meta_id, 2026, 12, -842030.360894, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 2: % Custo Administrativo
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('69905991-875c-4e51-a406-3151e25fd82b', v_kpi_id, v_kr_id, 2,
    '% Custo Administrativo', 'Representatividade da Torre administrativa sobre o total de despesas operacionais da Torre',
    'percentual', 'menor', 0.2, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '69905991-875c-4e51-a406-3151e25fd82b';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('5e285216-e3bc-4522-aaf2-76d4a79580f9', v_meta_id, 2026, 1, 0.15, -6452566.102215, 'erp'),
    ('992629aa-71f5-44fa-9903-0feecb83279e', v_meta_id, 2026, 2, 0.15, -6530789.03, 'erp'),
    ('5535dbb3-4bd1-4c45-9706-a82f6bba87ed', v_meta_id, 2026, 3, 0.15, -9100882.29, 'erp'),
    ('38341e92-231b-47a8-859e-d0693993dce0', v_meta_id, 2026, 4, 0.15, NULL, 'manual'),
    ('b27fbaca-e501-4b5f-8083-bbe56de51808', v_meta_id, 2026, 5, 0.15, NULL, 'manual'),
    ('7923135e-bd8c-4d37-af3b-34ebb8ebb47c', v_meta_id, 2026, 6, 0.15, NULL, 'manual'),
    ('6a13ae33-9c94-4626-92c0-cdf98b943c5c', v_meta_id, 2026, 7, 0.15, NULL, 'manual'),
    ('864da54a-c627-4fdb-883b-5432f08c700c', v_meta_id, 2026, 8, 0.15, NULL, 'manual'),
    ('656c99e7-df54-4f23-99b7-65b7e548f933', v_meta_id, 2026, 9, 0.15, NULL, 'manual'),
    ('d76e96fb-8a14-4699-8238-4d1af5983737', v_meta_id, 2026, 10, 0.15, NULL, 'manual'),
    ('3965bf86-22c0-459b-be94-4f2654b3ac29', v_meta_id, 2026, 11, 0.15, NULL, 'manual'),
    ('4f4bf71e-8c1a-4a82-b60a-8d8b2e490197', v_meta_id, 2026, 12, 0.15, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 1.02 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000102';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 1.02: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('4caa3e52-8e1c-4955-a449-80dcc2c7fb84', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 0.8, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '4caa3e52-8e1c-4955-a449-80dcc2c7fb84';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('f61ae104-064f-4018-8ace-a67738cdd53e', v_meta_id, 2026, 1, -21893.270597, -52018.8625, 'erp'),
    ('1d606225-3b7d-4e30-9d38-d67b72fa0766', v_meta_id, 2026, 2, -21893.270597, -24402.361116, 'erp'),
    ('549a521f-a3e8-4301-aeca-0eb7ca1c7526', v_meta_id, 2026, 3, -22331.690897, -25496.720355, 'erp'),
    ('1437c106-dfb9-4f29-8337-ab6fe22fa5d1', v_meta_id, 2026, 4, -22002.060597, NULL, 'manual'),
    ('667ae89b-69ca-4202-8629-b75ba033f781', v_meta_id, 2026, 5, -21906.860597, NULL, 'manual'),
    ('c11dbb1c-224f-4a37-b285-4bbda4aa515b', v_meta_id, 2026, 6, -22053.860597, NULL, 'manual'),
    ('6ae90beb-6d15-4f42-946d-c20755a4e680', v_meta_id, 2026, 7, -22053.860597, NULL, 'manual'),
    ('070be038-a05b-4633-9a37-6f828d38ae4a', v_meta_id, 2026, 8, -21611.910597, NULL, 'manual'),
    ('11df1a58-bfcc-408b-b204-bb6ae64c2884', v_meta_id, 2026, 9, -22013.514597, NULL, 'manual'),
    ('a6c5f281-ef14-46a9-9337-d7a3f4359fe2', v_meta_id, 2026, 10, -21611.910597, NULL, 'manual'),
    ('ebf72cfb-d3be-44af-8851-5e7d34d18159', v_meta_id, 2026, 11, -21611.910597, NULL, 'manual'),
    ('acd22d88-dd98-4806-9b08-3d9d07ba0254', v_meta_id, 2026, 12, -21890.210597, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 2: Processos Seletivos Vagas Preenchidas
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('5a8f682a-170e-4bc0-a46b-2fd9ceeb0145', v_kpi_id, v_kr_id, 2,
    'Processos Seletivos Vagas Preenchidas', 'Número de Vagas e seleção concluídas',
    'inteiro', 'maior', 0.2, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '5a8f682a-170e-4bc0-a46b-2fd9ceeb0145';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('937adce8-9385-4f8c-b61b-c1abebc21bd5', v_meta_id, 2026, 1, 22.0, 12.0, 'erp'),
    ('4be158d0-667d-4b63-9858-d8ce20051eac', v_meta_id, 2026, 2, 25.0, 18.0, 'erp'),
    ('aa590ac3-4465-44fc-bf4e-a333ea65ce53', v_meta_id, 2026, 3, 26.0, 22.0, 'erp')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 1.03 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000103';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 1.03: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('cf9aa22d-222d-46af-a87d-9948e6284f3f', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 0.8, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := 'cf9aa22d-222d-46af-a87d-9948e6284f3f';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('9bf833c0-acd6-4754-8bc4-0809319b8622', v_meta_id, 2026, 1, -49063.238889, -50223.163993, 'erp'),
    ('7bd33d35-3ae2-4159-ae73-47449e825c71', v_meta_id, 2026, 2, -49594.614889, -39232.166163, 'erp'),
    ('8dfc10f3-6f46-4d7f-bc5a-a97e8a000dcd', v_meta_id, 2026, 3, -49063.238889, -41389.462006, 'erp'),
    ('53f18194-9952-4718-a510-b79666c59800', v_meta_id, 2026, 4, -49063.238889, NULL, 'manual'),
    ('8e8ac953-686e-4186-8989-40d60c661915', v_meta_id, 2026, 5, -49358.188889, NULL, 'manual'),
    ('2610e1e6-b636-4cd9-a0ac-4aac16361031', v_meta_id, 2026, 6, -50051.360889, NULL, 'manual'),
    ('478fb16e-08dc-4666-92fb-c3fca23ff713', v_meta_id, 2026, 7, -49155.498889, NULL, 'manual'),
    ('0b99917b-6e3c-4273-b11d-e9e4a366fcb4', v_meta_id, 2026, 8, -49063.238889, NULL, 'manual'),
    ('007c8038-8394-4ceb-9b61-f0f25d564338', v_meta_id, 2026, 9, -49358.188889, NULL, 'manual'),
    ('42c35c1e-902e-4aa2-948b-465851694e54', v_meta_id, 2026, 10, -51471.939889, NULL, 'manual'),
    ('d96a2161-3a8c-44e2-b90f-0839ff785218', v_meta_id, 2026, 11, -49063.238889, NULL, 'manual'),
    ('f72319cc-9623-4835-8c79-5bb0d5bec4ed', v_meta_id, 2026, 12, -49063.238889, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 2: Custo Aquisição Castanha
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('a4d5a53e-2b08-4f7a-9bd2-d9cfe240e0eb', v_kpi_id, v_kr_id, 2,
    'Custo Aquisição Castanha', 'Preço castanha in natura',
    'decimal', 'menor', 0.2, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := 'a4d5a53e-2b08-4f7a-9bd2-d9cfe240e0eb';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('5891bf91-f7e0-41fd-b261-6e40b4c500a8', v_meta_id, 2026, 1, 5.8, NULL, 'manual'),
    ('ee4ffd52-09e1-4a78-a7e7-71a6ce79e6c6', v_meta_id, 2026, 2, 5.8, NULL, 'manual'),
    ('b55db232-656e-4db9-a1d3-2198e5d74c0b', v_meta_id, 2026, 3, 5.8, NULL, 'manual'),
    ('3413d161-0c61-4124-8851-14f3a67519b0', v_meta_id, 2026, 9, 5.8, NULL, 'manual'),
    ('fe4d747f-2fc4-4338-87e0-e28432a9a0d1', v_meta_id, 2026, 10, 5.8, NULL, 'manual'),
    ('f5eaf7a0-d065-4d75-a442-fc813f96bb3c', v_meta_id, 2026, 11, 5.8, NULL, 'manual'),
    ('df649077-e8c2-4169-9a64-983e079e307f', v_meta_id, 2026, 12, 5.8, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 3: Tempo de Cotação
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('ee10fccb-63a5-4cc1-8b8e-7a4ce46ead3a', v_kpi_id, v_kr_id, 3,
    'Tempo de Cotação', 'Prazo Médio de Cotação geral',
    'decimal', 'maior', 0.0, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := 'ee10fccb-63a5-4cc1-8b8e-7a4ce46ead3a';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('043cdbe1-953e-447d-9af5-b74e0fc4bf46', v_meta_id, 2026, 1, 5.5, NULL, 'manual'),
    ('64f274ff-cb87-466b-9bd5-97180c09841b', v_meta_id, 2026, 2, 5.5, NULL, 'manual'),
    ('4893559d-338a-4e76-aa36-2a64cf053dc5', v_meta_id, 2026, 3, 5.5, NULL, 'manual'),
    ('21ea5c4c-16ce-46d0-927b-6d3d698f4922', v_meta_id, 2026, 4, 5.5, NULL, 'manual'),
    ('2bb21f95-c861-47a8-8222-d759b9ae6504', v_meta_id, 2026, 5, 5.5, NULL, 'manual'),
    ('82721ff2-7db5-4152-a316-f5fca33aa21c', v_meta_id, 2026, 6, 5.5, NULL, 'manual'),
    ('725124af-9c14-432d-8d09-8625be59a7a0', v_meta_id, 2026, 7, 5.5, NULL, 'manual'),
    ('149b5483-f114-48be-8251-6860b072ee58', v_meta_id, 2026, 8, 5.5, NULL, 'manual'),
    ('faead1fe-ff83-4ff8-830b-9666c87eeb2f', v_meta_id, 2026, 9, 5.5, NULL, 'manual'),
    ('8604c271-8296-4c70-8cb4-4e57b7bd1fb2', v_meta_id, 2026, 10, 5.5, NULL, 'manual'),
    ('0d37ca4f-a9ae-4e37-b0ab-a24bcf6d9b2d', v_meta_id, 2026, 11, 5.5, NULL, 'manual'),
    ('29768070-74b8-4ca9-ac48-351cf7af2955', v_meta_id, 2026, 12, 5.5, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 1.04 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000104';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 1.04: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('5534db85-e96e-4427-b1fa-bd389f3cb4f8', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 1.0, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '5534db85-e96e-4427-b1fa-bd389f3cb4f8';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('3f88b7ed-5fc0-4474-a682-00a9dd917e74', v_meta_id, 2026, 1, -99399.567583, -160925.310526, 'erp'),
    ('4d5b12e7-207c-439c-bbe5-9b45f27a60ae', v_meta_id, 2026, 2, -98970.610583, -210066.418445, 'erp'),
    ('935d9bb9-5d97-4e88-a1d2-5b70849e0326', v_meta_id, 2026, 3, -101119.255583, -152992.722803, 'erp'),
    ('b8cdab1d-b794-4b87-8d70-eafe79e6c34a', v_meta_id, 2026, 4, -101085.401583, NULL, 'manual'),
    ('9498d17c-a0cd-42e8-980d-e51c92679e39', v_meta_id, 2026, 5, -106099.321583, NULL, 'manual'),
    ('0d1222e9-e466-48b4-910d-c79607749a6e', v_meta_id, 2026, 6, -107499.610083, NULL, 'manual'),
    ('84d23613-5e00-4f12-9eaa-4751766485f2', v_meta_id, 2026, 7, -100785.546583, NULL, 'manual'),
    ('373d4ca0-00f3-4db4-85b5-e2ad1e32c6f9', v_meta_id, 2026, 8, -101004.016583, NULL, 'manual'),
    ('6f1f04fa-de8f-4db2-b436-8460ac1119eb', v_meta_id, 2026, 9, -99111.597583, NULL, 'manual'),
    ('b7edae7e-e35d-4c7d-afdf-129a25364659', v_meta_id, 2026, 10, -99171.597583, NULL, 'manual'),
    ('79ea7b87-6ef4-4f55-8faa-0cc55b9efae8', v_meta_id, 2026, 11, -101205.319583, NULL, 'manual'),
    ('96b156b8-ccec-4004-93d7-16d95f9da87b', v_meta_id, 2026, 12, -100582.547583, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 1.05 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000105';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 1.05: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('15ba371f-93ea-4283-8bcb-9e8bbb035e0b', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 1.0, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '15ba371f-93ea-4283-8bcb-9e8bbb035e0b';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('c3085bf7-82e4-4466-806c-fb3cfd60f542', v_meta_id, 2026, 1, -29831.977778, -11043.2, 'erp'),
    ('62a114ff-3faa-4d1b-b0f8-6a0f93b832c9', v_meta_id, 2026, 2, -29831.977778, -22150.474464, 'erp'),
    ('bea54fca-6efa-4f92-b44a-5004d79caabd', v_meta_id, 2026, 3, -29831.977778, -24421.343282, 'erp'),
    ('b8d82b7a-549c-4c52-875d-80a4248d26e3', v_meta_id, 2026, 4, -29831.977778, NULL, 'manual'),
    ('b2e5c9e4-de9e-453a-82b9-55fe2db1d5fa', v_meta_id, 2026, 5, -29831.977778, NULL, 'manual'),
    ('e80159ac-aa3c-4cda-98ad-4fd489e476c7', v_meta_id, 2026, 6, -29831.977778, NULL, 'manual'),
    ('1ddd66ff-bfa4-4bf1-81a7-2b2903cad728', v_meta_id, 2026, 7, -29831.977778, NULL, 'manual'),
    ('bfc55827-af58-4caa-a6d6-b39044bdb992', v_meta_id, 2026, 8, -29831.977778, NULL, 'manual'),
    ('e563e952-011b-4e5a-86d7-c10cac096803', v_meta_id, 2026, 9, -29831.977778, NULL, 'manual'),
    ('2ce219d2-2b43-4fc0-ac9d-a746e64c3d84', v_meta_id, 2026, 10, -29831.977778, NULL, 'manual'),
    ('1669fcba-3de6-4e43-92bb-8df3d1ceb7a3', v_meta_id, 2026, 11, -29831.977778, NULL, 'manual'),
    ('a8d6aa0f-f3e3-45ef-8f70-3a632d2d9992', v_meta_id, 2026, 12, -29831.977778, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 1.06 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000106';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 1.06: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('395c88b7-0977-401a-a79a-1b6a83323d50', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 0.6, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '395c88b7-0977-401a-a79a-1b6a83323d50';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('fedde110-00a2-45c1-a2b8-55056f30443f', v_meta_id, 2026, 1, -89426.568611, -113221.217528, 'erp'),
    ('0141bf9e-51e8-4cc1-9e71-cbedededb355', v_meta_id, 2026, 2, -89697.234611, -96135.064826, 'erp'),
    ('cc461b4c-8859-44b1-918b-e1746ae4cf1e', v_meta_id, 2026, 3, -91378.584611, -101121.482568, 'erp'),
    ('2c0825e3-c2f8-4cd8-8b75-4bba581d7019', v_meta_id, 2026, 4, -90851.654611, NULL, 'manual'),
    ('01c940fa-3c32-4abc-83b9-aada07da2cb1', v_meta_id, 2026, 5, -89849.547611, NULL, 'manual'),
    ('7fbb3a0f-16ad-42fc-9794-5c4f45e26080', v_meta_id, 2026, 6, -89920.589611, NULL, 'manual'),
    ('d31c349d-bed6-4141-b978-fbd516c35060', v_meta_id, 2026, 7, -92704.797611, NULL, 'manual'),
    ('af8f3c61-d982-4858-8b17-49b663df87bb', v_meta_id, 2026, 8, -92965.508611, NULL, 'manual'),
    ('4a41d2d3-3441-4f84-9f85-86c8bd59db67', v_meta_id, 2026, 9, -107536.289611, NULL, 'manual'),
    ('12877214-77fe-45be-84c6-9e1a7e9c567e', v_meta_id, 2026, 10, -106894.721611, NULL, 'manual'),
    ('18fb5409-68c9-4e7d-a67f-6adbd483dc3f', v_meta_id, 2026, 11, -90351.102611, NULL, 'manual'),
    ('f4afdef8-f3a8-4703-a5d5-68da66e87216', v_meta_id, 2026, 12, -89892.883611, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 2: Calendário de Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('3941cd7f-e273-41eb-8944-86b5e0eba96b', v_kpi_id, v_kr_id, 2,
    'Calendário de Acompanhamento Orçamentário', 'Cumprimento da Agenda de Acompanhamento Orçamentário e introdução de procedimento de controle de despesas com os Gestores.',
    'percentual', 'menor', 0.2, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '3941cd7f-e273-41eb-8944-86b5e0eba96b';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('16966d0d-6978-4062-beda-8cf7d4846ac6', v_meta_id, 2026, 4, 1.0, NULL, 'manual'),
    ('acf61291-2fff-494e-9232-dfe1037033bd', v_meta_id, 2026, 5, 1.0, NULL, 'manual'),
    ('0d673235-2664-451f-a3f3-b27978df7016', v_meta_id, 2026, 6, 1.0, NULL, 'manual'),
    ('5eafbe3a-8327-4970-9ecb-2b62b0a33dfc', v_meta_id, 2026, 7, 1.0, NULL, 'manual'),
    ('d568231a-a118-4bcb-9681-435052dfa969', v_meta_id, 2026, 8, 1.0, NULL, 'manual'),
    ('fbb30d31-5a6a-4d73-ae07-76ee820dca40', v_meta_id, 2026, 9, 1.0, NULL, 'manual'),
    ('6c71f488-2096-4567-b01f-2a9e92dce615', v_meta_id, 2026, 10, 1.0, NULL, 'manual'),
    ('0122a9b7-ebb1-49b0-a302-d583febf3796', v_meta_id, 2026, 11, 1.0, NULL, 'manual'),
    ('4c7685ed-dc52-472a-9ea1-77081628d29c', v_meta_id, 2026, 12, 1.0, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 3: Calendário Auditorias
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('3854ff37-e7a0-4e64-996d-ea6ed021063f', v_kpi_id, v_kr_id, 3,
    'Calendário Auditorias', 'Comprimento das agendas de Auditorias Internas',
    'decimal', 'maior', 0.2, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '3854ff37-e7a0-4e64-996d-ea6ed021063f';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('7b263b2f-89fe-4a8a-8289-d62f659261e1', v_meta_id, 2026, 3, 4.0, 2.0, 'erp'),
    ('eac3304c-2934-45bf-809a-333c9c98d2a7', v_meta_id, 2026, 4, NULL, 2.0, 'erp'),
    ('4ec381a6-2b78-427c-9fc7-d40cf8da3353', v_meta_id, 2026, 5, 4.0, NULL, 'manual'),
    ('18250588-d799-413f-bf53-5df7a4456943', v_meta_id, 2026, 7, 4.0, NULL, 'manual'),
    ('40edd3d6-34ec-4eb1-824f-b75e5ad8f750', v_meta_id, 2026, 9, 4.0, NULL, 'manual'),
    ('da1acfea-2f08-4f65-aa94-dd089a869b02', v_meta_id, 2026, 11, 4.0, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 1.07 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000107';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 1.07: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('5d50ae4a-2b77-4988-8925-eb7f6fd8b90b', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 1.0, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '5d50ae4a-2b77-4988-8925-eb7f6fd8b90b';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('27802351-afed-41e2-a84f-7fd30be999c6', v_meta_id, 2026, 1, -154251.334672, -138967.680735, 'erp'),
    ('79234846-379d-4907-a392-6d9f8c50f7dc', v_meta_id, 2026, 2, -207094.130497, -186508.33738, 'erp'),
    ('bb8cd4d3-e092-4632-bbac-caa7b5bcc5c4', v_meta_id, 2026, 3, -178740.794872, -231732.437373, 'erp'),
    ('ce8e88e3-2c12-4d3c-a97b-90671697f126', v_meta_id, 2026, 4, -182035.856422, NULL, 'manual'),
    ('2a270233-e513-4ca5-82c1-640fdebe6d9d', v_meta_id, 2026, 5, -180850.650672, NULL, 'manual'),
    ('4c836997-ee3a-4ba7-9953-2df9f4f6c5e6', v_meta_id, 2026, 6, -181090.235647, NULL, 'manual'),
    ('0da8ab8c-bba0-4717-8f16-bc2914f2d649', v_meta_id, 2026, 7, -256527.361647, NULL, 'manual'),
    ('54dd2642-167d-47fc-b1b3-c92eddf92f03', v_meta_id, 2026, 8, -154069.785347, NULL, 'manual'),
    ('e6b9f109-fe57-4845-8181-0bf80522cde1', v_meta_id, 2026, 9, -184194.816247, NULL, 'manual'),
    ('987a8a71-8467-432a-94e5-19c7158aec24', v_meta_id, 2026, 10, -190780.648522, NULL, 'manual'),
    ('aa15ff33-6ebc-46db-9e0e-ef001aa3fcd9', v_meta_id, 2026, 11, -154757.073322, NULL, 'manual'),
    ('81d49fe0-1bff-475f-996c-ffa4de8be4ea', v_meta_id, 2026, 12, -186483.202322, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 1.08 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000108';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 1.08: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('e86da822-bb39-4b5a-85b0-ae44551c8745', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 1.0, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := 'e86da822-bb39-4b5a-85b0-ae44551c8745';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('2b6443f6-1900-4352-bbaf-23c84ab42277', v_meta_id, 2026, 1, -196284.588475, -140504.780791, 'erp'),
    ('0072b13e-2e65-4942-b746-5a2b109f9d48', v_meta_id, 2026, 2, -118739.27449, -73053.086797, 'erp'),
    ('b12579d8-b55e-4b89-90e1-7cd4a2349544', v_meta_id, 2026, 3, -120181.004345, -110290.42606, 'erp'),
    ('b2c8ab88-ea61-4669-b262-3ced73b87a73', v_meta_id, 2026, 4, -141210.645585, NULL, 'manual'),
    ('1d037fa2-3afc-4368-a85e-9f46393e1a26', v_meta_id, 2026, 5, -103640.231595, NULL, 'manual'),
    ('0331f204-53ba-4d48-a75d-2289b9fd37f5', v_meta_id, 2026, 6, -117526.558225, NULL, 'manual'),
    ('5cdb4a7d-6085-4851-b44c-12b8a0dc6e1c', v_meta_id, 2026, 7, -109396.100655, NULL, 'manual'),
    ('60b1ecd0-92ed-4e53-a47c-ec016a3f350f', v_meta_id, 2026, 8, -108276.840615, NULL, 'manual'),
    ('95e3686d-7f02-434f-8bde-5d0623cfa658', v_meta_id, 2026, 9, -108593.469845, NULL, 'manual'),
    ('79456834-b895-4d56-8bb8-719058f13b12', v_meta_id, 2026, 10, -122584.0976, NULL, 'manual'),
    ('dd8def01-71d1-464f-b510-864562089990', v_meta_id, 2026, 11, -114603.940325, NULL, 'manual'),
    ('cea0d3fe-8505-4fd9-a3dc-a0147870c68a', v_meta_id, 2026, 12, -155891.357745, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 2.01 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000201';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 2.01: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('77c61d45-3559-4c51-a75a-9dfec4e5e3a2', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 0.8, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '77c61d45-3559-4c51-a75a-9dfec4e5e3a2';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('63bda738-5c84-4a6c-a81d-cc7cfcf4db05', v_meta_id, 2026, 1, -1086405.602335, -906672.78824, 'erp'),
    ('f171a496-37d0-4935-bb48-33e437a34569', v_meta_id, 2026, 2, -969659.008264, -558876.843348, 'erp'),
    ('5d48640b-e170-473c-bc16-ecbfd21d394f', v_meta_id, 2026, 3, -998567.277864, -895098.483204, 'erp'),
    ('7f8ff464-5235-4073-a1d1-d0f9f82f1e56', v_meta_id, 2026, 4, -1040758.122757, NULL, 'manual'),
    ('54f7c684-1fc8-474b-921c-87632bbf0859', v_meta_id, 2026, 5, -1032071.978623, NULL, 'manual'),
    ('ea51b334-0e6b-40e0-9afe-919075d3e93b', v_meta_id, 2026, 6, -1065984.120034, NULL, 'manual'),
    ('cb0b991c-46f5-4fbf-9c6e-b479fee13b88', v_meta_id, 2026, 7, -1056574.536579, NULL, 'manual'),
    ('ba9209b3-7ad9-43f7-b908-50300d9f9ccc', v_meta_id, 2026, 8, -1148556.015423, NULL, 'manual'),
    ('770b4686-ee80-45cc-8415-9ae8d15aa4d7', v_meta_id, 2026, 9, -1230918.881437, NULL, 'manual'),
    ('a41324dd-ab22-4bdd-abac-eea41584769a', v_meta_id, 2026, 10, -1166580.296152, NULL, 'manual'),
    ('d1d30896-5377-4f79-8f6a-7e1270748a2a', v_meta_id, 2026, 11, -1157519.911661, NULL, 'manual'),
    ('1e893fb7-b9fe-46fa-a54f-c02bd0a27c28', v_meta_id, 2026, 12, -1342924.547144, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 3: Frequência de Alunos
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('82ac353a-ecfb-4394-b62d-3d447de0b00e', v_kpi_id, v_kr_id, 3,
    'Frequência de Alunos', 'Indice de Ocupação das Aulas por parte dos alunos',
    'percentual', 'menor', 0.1, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '82ac353a-ecfb-4394-b62d-3d447de0b00e';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('c20bad74-1f90-4e39-af45-037e54018622', v_meta_id, 2026, 1, 0.8, 0.78, 'erp'),
    ('8f8d0eb5-8fe1-4292-bfa7-614fa874d875', v_meta_id, 2026, 2, 0.8, 0.82, 'erp'),
    ('71e0309f-bbf5-4fd2-8ad2-f2f7647a076f', v_meta_id, 2026, 3, 0.8, 0.81, 'erp'),
    ('e2b68120-0b27-4bd4-b3b6-2e4fbd0c8472', v_meta_id, 2026, 4, 0.8, NULL, 'manual'),
    ('85b99f9d-c97c-468f-8c1f-c92604687b34', v_meta_id, 2026, 5, 0.8, NULL, 'manual'),
    ('469f411f-4a25-4c82-a612-d12edc120a55', v_meta_id, 2026, 6, 0.8, NULL, 'manual'),
    ('a65dc6cb-3486-411a-aa62-fa4f711f5bb7', v_meta_id, 2026, 7, 0.8, NULL, 'manual'),
    ('680af254-00df-47d5-a734-3433c459e87d', v_meta_id, 2026, 8, 0.8, NULL, 'manual'),
    ('d24e649d-9c1b-4373-9ab4-8e05930d8a36', v_meta_id, 2026, 9, 0.8, NULL, 'manual'),
    ('e8b4b93f-9b76-415b-bd40-a96f2ee05acd', v_meta_id, 2026, 10, 0.8, NULL, 'manual'),
    ('e7e711cd-f05a-4e9e-adf6-e56f661ae038', v_meta_id, 2026, 11, 0.8, NULL, 'manual'),
    ('b7ef4d0c-38f8-487f-9de7-465401f4a80b', v_meta_id, 2026, 12, 0.8, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 3.01 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000301';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 3.01: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('c515498b-0587-4eae-802d-fdcb33bf83fd', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 0.5, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := 'c515498b-0587-4eae-802d-fdcb33bf83fd';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('1ab8b65f-eaa7-4651-b9b9-d4ae0b340adb', v_meta_id, 2026, 1, -2637787.192545, -2876890.0, 'erp'),
    ('a7710c91-3a1c-4583-a948-740b94208b44', v_meta_id, 2026, 2, -1917066.004119, -2339421.0, 'erp'),
    ('6538a92b-9ccb-49fe-98da-57e683313dda', v_meta_id, 2026, 3, -2378405.416024, -2687405.0, 'erp'),
    ('d60bd941-6c6b-4f08-b4d5-a63cf6f7ad4c', v_meta_id, 2026, 4, -2016718.524263, -2349045.0, 'erp'),
    ('2ba751aa-9864-4086-9387-afd97b0309ee', v_meta_id, 2026, 5, -2109120.124259, NULL, 'manual'),
    ('8bf20c5a-0d49-43a0-801d-187ec007f562', v_meta_id, 2026, 6, -2064741.003309, NULL, 'manual'),
    ('e360a2fc-595f-4c03-b3dd-9f28df9a7de5', v_meta_id, 2026, 7, -2133026.453909, NULL, 'manual'),
    ('a96d026d-fcaa-46ba-8f04-d6a2a17805dc', v_meta_id, 2026, 8, -1986680.432109, NULL, 'manual'),
    ('876c6901-4248-4dde-ad51-dfce9cada68a', v_meta_id, 2026, 9, -2462914.446638, NULL, 'manual'),
    ('d69919f3-cd2c-4d25-b513-04e58b213018', v_meta_id, 2026, 10, -3034457.939659, NULL, 'manual'),
    ('066dc93d-d36d-4032-8386-3510a63a95b4', v_meta_id, 2026, 11, -3990526.257864, NULL, 'manual'),
    ('d9a5be46-1f26-46c6-a602-813054354c13', v_meta_id, 2026, 12, -4808414.277106, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 2: Custo Base Amêndoa
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('b3fba3d0-4a72-43f3-a995-ec7a3be666d1', v_kpi_id, v_kr_id, 2,
    'Custo Base Amêndoa', 'Custo Unitário da Base Amêndoa Média de todas as bases, considerando produção ou compra de Bases.',
    'decimal', 'menor', 0.3, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := 'b3fba3d0-4a72-43f3-a995-ec7a3be666d1';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('ab916201-a529-498b-9706-c81e5a5bf505', v_meta_id, 2026, 1, 42.6, 41.11, 'erp'),
    ('6f04ea61-c623-4410-bfb7-2e0fdb81f728', v_meta_id, 2026, 2, 42.6, 41.69, 'erp'),
    ('a0ea0ba1-5048-4f9c-9f4a-eafbfa317741', v_meta_id, 2026, 3, 42.6, 46.33, 'erp'),
    ('d37b202a-c403-4c00-bf59-f323a02605b4', v_meta_id, 2026, 4, 45.0, 47.55, 'erp'),
    ('f6b8d804-3ff0-4869-a75c-c3b64654db52', v_meta_id, 2026, 5, 45.0, NULL, 'manual'),
    ('636156d1-64e4-485c-b4bf-36ca2886df1f', v_meta_id, 2026, 6, 45.0, NULL, 'manual'),
    ('a3293467-a5e9-4c83-8fa4-72a5c401551b', v_meta_id, 2026, 7, 45.0, NULL, 'manual'),
    ('5f5c222b-2f03-4f84-bf49-44f22474d930', v_meta_id, 2026, 8, 45.0, NULL, 'manual'),
    ('28c9e4b9-c387-4c48-9739-c691d7bdce91', v_meta_id, 2026, 9, 45.0, NULL, 'manual'),
    ('777672dd-97c3-431e-99de-10c939e258f7', v_meta_id, 2026, 10, 45.0, NULL, 'manual'),
    ('56a406e5-a47f-4772-8a75-db6c1625e86e', v_meta_id, 2026, 11, 45.0, NULL, 'manual'),
    ('9fb178ea-e503-488b-8a7a-ff529fb76f24', v_meta_id, 2026, 12, 45.0, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 3: Produção total
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('a97e3e24-58d4-44cf-8b48-4f8355f1e007', v_kpi_id, v_kr_id, 3,
    'Produção total', 'Atingimento de Meta de Produção Amêndoa',
    'inteiro', 'maior', 0.2, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := 'a97e3e24-58d4-44cf-8b48-4f8355f1e007';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('383d74f0-4948-47d9-b526-fdcbc4ad479b', v_meta_id, 2026, 1, 25200.0, 21509.0, 'erp'),
    ('40802393-011f-4808-9f52-02b7e31703b0', v_meta_id, 2026, 2, 25200.0, 16414.0, 'erp'),
    ('e11c5474-5604-45fd-b2c2-2f5daed55fb2', v_meta_id, 2026, 3, 25200.0, 15233.0, 'erp'),
    ('5f6344bb-7658-42da-9543-6030124fa508', v_meta_id, 2026, 4, 25200.0, 28879.0, 'erp'),
    ('49e5602a-ee61-4450-a676-a56e37869cea', v_meta_id, 2026, 5, 25200.0, NULL, 'manual'),
    ('3ed67ef6-ba6f-4c35-a981-2d8eab49caab', v_meta_id, 2026, 6, 25200.0, NULL, 'manual'),
    ('2b3e5d74-fc33-4ab1-9922-c8a7e4663584', v_meta_id, 2026, 7, 26248.0, NULL, 'manual'),
    ('ab266c73-b6f2-4a8b-826c-facf889e4b62', v_meta_id, 2026, 8, 26248.0, NULL, 'manual'),
    ('deb58106-0281-4280-98c4-9d912d178fd7', v_meta_id, 2026, 9, 26248.0, NULL, 'manual'),
    ('26f74e83-6bb4-499b-aa9f-83ef530b75bb', v_meta_id, 2026, 10, 26248.0, NULL, 'manual'),
    ('eaff3c11-3be5-4c0b-8558-ecabfeab5cad', v_meta_id, 2026, 11, 26248.0, NULL, 'manual'),
    ('a1132740-62b3-44fc-a234-0129f57b8508', v_meta_id, 2026, 12, 26248.0, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 3.03 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000303';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 3.03: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('b7142498-7919-41da-b835-cc2cbf1e3a19', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 0.6, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := 'b7142498-7919-41da-b835-cc2cbf1e3a19';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('7e2270eb-4752-4986-9cc0-11b3872e63f7', v_meta_id, 2026, 1, -219736.235319, -216222.721798, 'erp'),
    ('37bd3cbf-02be-4c83-be44-c072febc92a9', v_meta_id, 2026, 2, -298171.439319, -324923.64604, 'erp'),
    ('ebd678e3-8187-454f-a851-11ccb933d1f2', v_meta_id, 2026, 3, -226629.531119, -189380.762578, 'erp'),
    ('89f32633-c7fe-4ff7-9f33-1814cc165cd9', v_meta_id, 2026, 4, -153861.450919, NULL, 'manual'),
    ('c548126b-1029-4260-be98-b82950076aa4', v_meta_id, 2026, 5, -224348.955119, NULL, 'manual'),
    ('a81fe8a1-b488-4291-9cb3-f860680308b0', v_meta_id, 2026, 6, -166861.735719, NULL, 'manual'),
    ('98e16bf5-f4dd-4c97-b852-93f0becadd01', v_meta_id, 2026, 7, -139728.165199, NULL, 'manual'),
    ('05499dd3-29eb-4213-8c8d-d3c2f5cddde8', v_meta_id, 2026, 8, -119787.349519, NULL, 'manual'),
    ('e005372f-c4c1-46f4-b2fd-cee3754b580f', v_meta_id, 2026, 9, -219460.950519, NULL, 'manual'),
    ('4af6b12a-177d-4acc-9faf-b290a691926e', v_meta_id, 2026, 10, -203979.515119, NULL, 'manual'),
    ('6e77c698-d289-4d54-ae05-59819dfa20d4', v_meta_id, 2026, 11, -230083.324919, NULL, 'manual'),
    ('9244a2ef-0f3c-4070-8114-b2ff93dffc27', v_meta_id, 2026, 12, -279163.811839, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 2: Frete %
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('523df7a9-47d1-4d8a-8f3d-30bbc88971ab', v_kpi_id, v_kr_id, 2,
    'Frete %', 'Frete % Sobre Venda Contratado + Carro da Casa',
    'monetario', 'menor', 0.2, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '523df7a9-47d1-4d8a-8f3d-30bbc88971ab';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('409467ba-bcc1-4500-955f-b211c510f0e3', v_meta_id, 2026, 1, -149858.424, -107618.9, 'erp'),
    ('c53457b6-ebe6-49c6-8826-bd2c4312d53d', v_meta_id, 2026, 2, -227842.74, -250050.02, 'erp'),
    ('9d8e5b72-5bff-4379-8a86-feac32b81cfb', v_meta_id, 2026, 3, -149747.1948, -108434.95, 'erp'),
    ('79b570f4-8e59-40b5-916f-784bf70bbe85', v_meta_id, 2026, 4, -76772.7396, 0.0, 'erp'),
    ('8bbcf48e-73f6-422b-a21c-6d8f5c5776df', v_meta_id, 2026, 5, -148892.6448, 0.0, 'erp'),
    ('3e92c1c3-67c5-44fa-bc04-2370a44b4fdb', v_meta_id, 2026, 6, -85701.8124, 0.0, 'erp'),
    ('339171c4-29b5-4a58-bb8d-e7111cc06cd5', v_meta_id, 2026, 7, -64581.4728, 0.0, 'erp'),
    ('d537f4af-10db-4c2b-94bc-d52410680b60', v_meta_id, 2026, 8, -49774.3488, 0.0, 'erp'),
    ('6594a16e-e850-40f5-83bd-9fd0216426cd', v_meta_id, 2026, 9, -148391.082, 0.0, 'erp'),
    ('5ff0845b-1b52-4570-9762-730dbf90db88', v_meta_id, 2026, 10, -131673.924, 0.0, 'erp'),
    ('cb2db315-6e0a-4a88-8e66-8a4a0dc8277e', v_meta_id, 2026, 11, -154847.3436, 0.0, 'erp'),
    ('a7c9d6cf-31d0-4bfe-96bf-451b157c38fa', v_meta_id, 2026, 12, -205821.6912, 0.0, 'erp')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 3.08 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000308';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 3.08: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Atingimento de Faturamento
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('2e206971-9355-4778-8014-bfa0728cc610', v_kpi_id, v_kr_id, 1,
    'Atingimento de Faturamento', 'Relação do Faturamento Realizado x Faturamento do Planejamento, Vendas Brutas da DRE Produtiva. Indicador percetual de atingimento. Todos os Canais + Bazar',
    'monetario', 'maior', 0.6, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '2e206971-9355-4778-8014-bfa0728cc610';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('22b993fe-cc0a-4a56-8d0c-0cdd9a8ded8c', v_meta_id, 2026, 1, 2896250.0, 3225195.0, 'erp'),
    ('3b1d603e-9c75-422d-8448-73647f4bb3ae', v_meta_id, 2026, 2, 3230000.0, 4016225.0, 'erp'),
    ('873ec5d1-9e27-4bba-93b6-e8ac8ba659b9', v_meta_id, 2026, 3, 3698000.0, 4376131.0, 'erp')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 2: ROL
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('d496e45e-e3f3-4810-bf7e-68f250bcc952', v_kpi_id, v_kr_id, 2,
    'ROL', 'Atingimento de ROL estabelecido para as Operações Comerciais com vendas de todas as Categorias',
    'percentual', 'maior', 0.3, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := 'd496e45e-e3f3-4810-bf7e-68f250bcc952';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('ba1afaab-3e99-41e6-aad4-29e432fbc5a0', v_meta_id, 2026, 1, 0.12, 0.155125, 'erp'),
    ('ce18e118-cb9a-42c8-a855-cad6dc313e6e', v_meta_id, 2026, 2, 0.12, 0.138685, 'erp'),
    ('cea71618-6bbe-4c8a-bc1f-c5302ec7ca55', v_meta_id, 2026, 3, 0.12, 0.21884, 'erp')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 3: Reduzir dependencia Grandes Redes
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('ee0754e9-0510-4f44-8b50-6eb8aef5b673', v_kpi_id, v_kr_id, 3,
    'Reduzir dependencia Grandes Redes', 'Diminuir a dependência de Grandes Players de acordo com a meta escalonada estabelecida',
    'percentual', 'menor', 0.1, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := 'ee0754e9-0510-4f44-8b50-6eb8aef5b673';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('5da2ca15-b47f-4674-a7e2-fedc256d3d61', v_meta_id, 2026, 1, 0.45, 0.4533, 'erp'),
    ('e507d75c-73b0-4b95-8b6f-acbebf88aa78', v_meta_id, 2026, 2, 0.45, 0.4744, 'erp'),
    ('5b72a05b-da7c-4cad-ba6e-f5c403714945', v_meta_id, 2026, 3, 0.45, 0.4624, 'erp'),
    ('25001a2d-2156-4160-b507-759429d5f398', v_meta_id, 2026, 4, 0.4, NULL, 'manual'),
    ('80ee94cb-dea5-48a8-808f-8ffcf7aa4dd1', v_meta_id, 2026, 5, 0.4, NULL, 'manual'),
    ('0fa41a67-9982-42f4-9f9a-b68c32b81698', v_meta_id, 2026, 6, 0.4, NULL, 'manual'),
    ('d6e5411b-09e7-46ea-aa12-ab0119340294', v_meta_id, 2026, 7, 0.35, NULL, 'manual'),
    ('d27fc04e-02f9-47d5-bcf9-a24a2448090b', v_meta_id, 2026, 8, 0.35, NULL, 'manual'),
    ('c627c0bb-86a3-4e03-85fd-8368612d4549', v_meta_id, 2026, 9, 0.35, NULL, 'manual'),
    ('20cb43d2-74b8-4b34-8552-e5f4c60022b2', v_meta_id, 2026, 10, 0.3, NULL, 'manual'),
    ('e188a040-45b4-4007-9431-1067a22ab8c6', v_meta_id, 2026, 11, 0.3, NULL, 'manual'),
    ('19cb6687-4ec4-430b-b81f-8ef9597c296b', v_meta_id, 2026, 12, 0.3, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 3.09 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000309';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 3.09: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('c4a044b7-65f9-49ae-9bc7-646dd4fa8116', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 0.8, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := 'c4a044b7-65f9-49ae-9bc7-646dd4fa8116';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('b1ce4bb4-7109-4f68-89b1-47e6c57503fc', v_meta_id, 2026, 1, -150356.928903, -177942.26, 'erp'),
    ('6566f23c-da8c-4b1c-b421-a02d1b41264c', v_meta_id, 2026, 2, -131292.740903, -299337.53, 'erp'),
    ('adfc672b-0c11-47f6-9026-967532dc4fcb', v_meta_id, 2026, 3, -139090.769903, -142348.6, 'erp'),
    ('e7e88f4f-a8ba-4644-93ee-2d00b2342c87', v_meta_id, 2026, 4, -154666.230658, NULL, 'manual'),
    ('7d191a9c-5124-4352-a82b-7d9ae30a7379', v_meta_id, 2026, 5, -145520.635903, NULL, 'manual'),
    ('e69c2ed8-909f-4ae6-9e7b-ddbac4d40bf6', v_meta_id, 2026, 6, -150788.377903, NULL, 'manual'),
    ('744633be-0be2-4a76-a2ad-6efacded771f', v_meta_id, 2026, 7, -193231.86817, NULL, 'manual'),
    ('4e4241e1-5d8a-469f-84dd-bf287e80f65d', v_meta_id, 2026, 8, -194666.316903, NULL, 'manual'),
    ('68b4daf2-9ecb-476c-ac34-217cd55a3c61', v_meta_id, 2026, 9, -151322.866184, NULL, 'manual'),
    ('6577fe4e-f2a3-4161-94bd-f7b8c317ac06', v_meta_id, 2026, 10, -139523.712903, NULL, 'manual'),
    ('acd6e9f8-bc00-48ca-9cbc-f55d896de239', v_meta_id, 2026, 11, -171717.047903, NULL, 'manual'),
    ('e2ae25e1-618e-4b61-8b4f-3510b6398123', v_meta_id, 2026, 12, -189306.461903, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 2: Rentabilidade Campo
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('c980a9e1-ead4-4763-a1ec-9938a2b0f245', v_kpi_id, v_kr_id, 2,
    'Rentabilidade Campo', 'Resultado do Campo x Investimentos',
    'monetario', 'maior', 0.3, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := 'c980a9e1-ead4-4763-a1ec-9938a2b0f245';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('ff66a032-b917-4c4d-8cfd-7b27f0dd0941', v_meta_id, 2026, 1, 129643.071097, 163619.74, 'erp'),
    ('037b5861-be13-403b-91ea-088b3049626e', v_meta_id, 2026, 2, 148707.259097, 102536.97, 'erp'),
    ('011af584-87d3-451d-9b79-e2b5536be21d', v_meta_id, 2026, 3, -139090.769903, -44185.6, 'erp')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 3: Produtividade Campo
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('ab76d114-07d7-4ba3-bede-12a2a7071dd1', v_kpi_id, v_kr_id, 3,
    'Produtividade Campo', 'Meta de Resultado de produtividade de Castanha do Campo',
    'inteiro', 'maior', 0.3, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := 'ab76d114-07d7-4ba3-bede-12a2a7071dd1';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('6f461b41-3be0-4031-8072-7bd556416df2', v_meta_id, 2026, 1, 50000.0, 56550.0, 'erp'),
    ('95a46f8c-9ba8-4507-85f8-0b201dca74ae', v_meta_id, 2026, 2, 50000.0, 65200.0, 'erp'),
    ('caf412a5-6ec1-4e35-ab11-ab6c42fca74b', v_meta_id, 2026, 3, 0.0, 16345.0, 'erp'),
    ('e5daf1de-750f-4a12-92aa-6fca0cd47568', v_meta_id, 2026, 10, 80000.0, NULL, 'manual'),
    ('0d513fe4-c62e-462f-b776-a116f1e1e004', v_meta_id, 2026, 11, 100000.0, NULL, 'manual'),
    ('9e79e191-0b93-403a-8484-19fa7628e579', v_meta_id, 2026, 12, 100000.0, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 3.10 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000310';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 3.10: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('9d684d5e-ff2b-47c5-a4b1-9ceb6a50fb75', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 0.3, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '9d684d5e-ff2b-47c5-a4b1-9ceb6a50fb75';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('a74301ef-510d-4436-bf46-5379578feda2', v_meta_id, 2026, 1, -95329.62925, -130547.256871, 'erp'),
    ('42dd3672-0415-4ece-be47-f42b9a1c02cb', v_meta_id, 2026, 2, -104438.32225, -144316.941881, 'erp'),
    ('25005e1d-bc33-47a0-8953-2fa864bb4644', v_meta_id, 2026, 3, -103205.42525, -111028.959344, 'erp'),
    ('f279944f-fe7a-4520-a180-be91f3299672', v_meta_id, 2026, 4, -99917.37925, NULL, 'manual'),
    ('3aefba64-7842-4a86-9ed0-54cdffcbb662', v_meta_id, 2026, 5, -98366.64865, NULL, 'manual'),
    ('8ae555bb-d009-4236-b4e7-73c9779cb33d', v_meta_id, 2026, 6, -118905.76365, NULL, 'manual'),
    ('a1b9dfc2-6c7f-4570-abbc-9cd90654ab82', v_meta_id, 2026, 7, -115602.81965, NULL, 'manual'),
    ('8cd6f161-8558-45af-84d9-0c9c780dbfea', v_meta_id, 2026, 8, -113080.95165, NULL, 'manual'),
    ('f9eeae0a-e931-44f2-836b-21f085455510', v_meta_id, 2026, 9, -226281.31955, NULL, 'manual'),
    ('54a42563-5a69-41c2-b051-4af189d2a739', v_meta_id, 2026, 10, -137456.45165, NULL, 'manual'),
    ('94efbf54-6560-411b-9e65-a77d0c2f14b2', v_meta_id, 2026, 11, -118479.75065, NULL, 'manual'),
    ('257261fe-cf14-428a-9971-9b5e052a1052', v_meta_id, 2026, 12, -112318.91665, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 2: Meta de Faturamento
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('cce46848-ce9b-4bbb-8188-260e5013e30f', v_kpi_id, v_kr_id, 2,
    'Meta de Faturamento', 'Atingimento da Meta de Faturamento estabelecida para o ano',
    'monetario', 'maior', 0.6, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := 'cce46848-ce9b-4bbb-8188-260e5013e30f';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('ac32b068-98ea-475d-bad1-16be68b85a4c', v_meta_id, 2026, 1, 100000.0, 190729.0, 'erp'),
    ('2947e82f-7f3f-4c6d-a266-a8b661c44df4', v_meta_id, 2026, 2, 480000.0, 550338.0, 'erp'),
    ('02056f11-96c3-4384-b083-4135faf70588', v_meta_id, 2026, 3, 500000.0, 858661.0, 'erp')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 3: Rentabilidade
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('b7590379-7cd3-4036-a25d-c9a29561f74a', v_kpi_id, v_kr_id, 3,
    'Rentabilidade', 'Atingimento de 100% da meta de rentabilidade',
    'percentual', 'menor', 0.1, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := 'b7590379-7cd3-4036-a25d-c9a29561f74a';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('875b0673-9abf-45ad-95ff-96763a03d616', v_meta_id, 2026, 1, 0.7, 0.605, 'erp'),
    ('d33b3b16-fb12-4838-b261-8711d56db13e', v_meta_id, 2026, 2, 0.7, 0.662, 'erp'),
    ('27a40369-83f5-460a-8b02-6e15fb278de5', v_meta_id, 2026, 3, 0.7, 0.672, 'erp')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 4.01 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000401';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 4.01: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('406a9410-f8ab-4ae2-8b06-137f2825af8a', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário (<100%)',
    'monetario', 'menor', 0.6, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '406a9410-f8ab-4ae2-8b06-137f2825af8a';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('49d3d70d-c5e3-41fe-8ff5-17f0b8ae14a5', v_meta_id, 2026, 1, -322100.176512, -469363.02, 'erp'),
    ('89d12142-7052-4a92-91ba-17902af5ad29', v_meta_id, 2026, 2, -316978.128512, -457990.91, 'erp'),
    ('2d876964-46d1-4fc0-9a77-02bc6bc2c7ab', v_meta_id, 2026, 3, -422203.501512, -528427.641288, 'erp'),
    ('c41fe619-0fd0-46af-93e4-d96940bf3af7', v_meta_id, 2026, 4, -329202.368326, NULL, 'manual'),
    ('2a1204c5-f8d2-4963-be12-20a9c6f4a355', v_meta_id, 2026, 5, -469372.730512, NULL, 'manual'),
    ('f9d6e796-467c-47fb-84cb-ec5c6ea78054', v_meta_id, 2026, 6, -1237421.085512, NULL, 'manual'),
    ('f2d6e236-05de-4d72-b3e0-bff6161ddc8f', v_meta_id, 2026, 7, -1117679.781846, NULL, 'manual'),
    ('df7836c8-0278-4860-9815-498322acbb7e', v_meta_id, 2026, 8, -1100433.576203, NULL, 'manual'),
    ('f6eef58c-25c2-466f-bb32-dddb8ecef403', v_meta_id, 2026, 9, -1188933.133015, NULL, 'manual'),
    ('6560f2ad-5452-43f4-b2c8-55ab422e35e8', v_meta_id, 2026, 10, -1264543.266512, NULL, 'manual'),
    ('76c604a9-de0d-4b36-a4d2-5e2e7b03adbc', v_meta_id, 2026, 11, -1140303.563697, NULL, 'manual'),
    ('7a46605e-54e8-4120-99d7-8f6e5cb20020', v_meta_id, 2026, 12, -1141247.623512, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 2: Custo por Metro construído
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('907e6bf6-8db7-4c13-bcf8-556b7df8e2bf', v_kpi_id, v_kr_id, 2,
    'Custo por Metro construído', 'Valor do M² Construido (<100%)',
    'inteiro', 'menor', 0.2, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '907e6bf6-8db7-4c13-bcf8-556b7df8e2bf';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('348e5473-3586-401f-94ed-c5db4d92dcad', v_meta_id, 2026, 1, 250.0, 247.5, 'erp'),
    ('e76f6d5c-8b4e-4e4c-b47a-ae09b200bd22', v_meta_id, 2026, 2, 356.0, 331.08, 'erp'),
    ('31c95137-3c3e-49e0-bf0d-8dbdca9eb034', v_meta_id, 2026, 3, 422.0, 527.5, 'erp')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 3: Quantidade de Obras entregues
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('d1f645b6-55e3-4974-98b5-767debfc65a3', v_kpi_id, v_kr_id, 3,
    'Quantidade de Obras entregues', 'Entregar xx obras no mês previstas para execução',
    'decimal', 'maior', 0.2, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := 'd1f645b6-55e3-4974-98b5-767debfc65a3';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('5676bd71-b2fc-44c4-a0d4-6aac4edd5c92', v_meta_id, 2026, 1, 6.0, 2.0, 'erp'),
    ('2af39ee0-e362-45c7-aacb-e30601b1be46', v_meta_id, 2026, 2, 8.0, 4.0, 'erp'),
    ('885ae1e5-b182-471e-8e4c-d12438b61bdd', v_meta_id, 2026, 3, 10.0, 8.0, 'erp')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 4.03a ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0001-0000-000000000403';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 4.03a: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('70c19793-6a6d-4cd4-8541-ca476aa79452', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 0.5, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '70c19793-6a6d-4cd4-8541-ca476aa79452';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('2c7a9ca3-0f7c-4f8a-9ab9-39950380d1d3', v_meta_id, 2026, 1, -36369.534333, -41804.04, 'erp'),
    ('427ec129-5d85-4d6a-8ec6-28c6879c64e4', v_meta_id, 2026, 2, -37119.569333, -26297.88, 'erp'),
    ('b21a6672-317a-4480-9da3-7ebbc9d5a3c4', v_meta_id, 2026, 3, -43873.384333, -39486.7, 'erp'),
    ('70084924-b439-4d1a-b288-26576ba3ac05', v_meta_id, 2026, 4, -61684.229333, NULL, 'manual'),
    ('1cc8dc6f-2d18-4622-8f69-241a262afd40', v_meta_id, 2026, 5, -72098.554333, NULL, 'manual'),
    ('89e6176b-96d2-45a8-9d6e-7604abf48891', v_meta_id, 2026, 6, -36423.234333, NULL, 'manual'),
    ('224f602d-d1f7-4006-ac0e-e84a15226136', v_meta_id, 2026, 7, -35932.084333, NULL, 'manual'),
    ('5e114b89-b41f-481f-bb1d-32d9102be11e', v_meta_id, 2026, 8, -39758.794333, NULL, 'manual'),
    ('7c98a03b-459a-4d06-bac5-7b01e0f019c1', v_meta_id, 2026, 9, -37639.775333, NULL, 'manual'),
    ('e9f3b90c-060e-454a-a989-11d451465336', v_meta_id, 2026, 10, -35930.364333, NULL, 'manual'),
    ('c39384a5-21e1-44c8-b333-cafb60dc15af', v_meta_id, 2026, 11, -35931.220333, NULL, 'manual'),
    ('1960dff3-f261-4e23-9031-aeff296335de', v_meta_id, 2026, 12, -55528.119333, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 2: Custo por Litro
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('d938562e-b91a-49ce-ac56-2f64ead392d1', v_kpi_id, v_kr_id, 2,
    'Custo por Litro', 'Valor de Custo Operacional do Projeto Água dividido pela quantidade de água distribuida',
    'percentual', 'menor', 0.2, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := 'd938562e-b91a-49ce-ac56-2f64ead392d1';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('290c2091-a987-4da8-bee2-2dd0c8518d19', v_meta_id, 2026, 1, -0.018552, -0.023639, 'erp'),
    ('9cae78b6-9126-49dd-959e-ad339ae8113b', v_meta_id, 2026, 2, -0.018934, -0.019967, 'erp'),
    ('15cd7a01-61a4-4181-be64-898eea434d11', v_meta_id, 2026, 3, -0.022379, -0.037886, 'erp'),
    ('9c9fa917-4649-4fe1-af23-cd69b3ea1e3f', v_meta_id, 2026, 4, -0.031464, NULL, 'manual'),
    ('7fe84d91-a05c-4b79-a263-965453121e17', v_meta_id, 2026, 5, -0.036776, NULL, 'manual'),
    ('d982c10d-2593-46a4-9341-b3a9d11e3dd5', v_meta_id, 2026, 6, -0.018579, NULL, 'manual'),
    ('ebbeef28-2da4-4902-9319-14eaffbad25d', v_meta_id, 2026, 7, -0.018328, NULL, 'manual'),
    ('12ad09c5-cf22-4eb6-aafa-ed706e439fec', v_meta_id, 2026, 8, -0.02028, NULL, 'manual'),
    ('24430f9d-15d4-4b0f-b50c-914d182cf7c4', v_meta_id, 2026, 9, -0.0192, NULL, 'manual'),
    ('0a36dedf-0a38-471c-a835-eeca9d17df24', v_meta_id, 2026, 10, -0.018328, NULL, 'manual'),
    ('ecfb71cc-b78a-4817-8cad-01b173327234', v_meta_id, 2026, 11, -0.018328, NULL, 'manual'),
    ('4b6cbed4-9dd6-4588-b8ed-9fd2034e6612', v_meta_id, 2026, 12, -0.028324, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 3: Litros de água distribuidos
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('21852667-87dc-445e-88a5-3ceeeff50b8e', v_kpi_id, v_kr_id, 3,
    'Litros de água distribuidos', 'Litros de água distribuidos em carros pipa',
    'monetario', 'maior', 0.3, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '21852667-87dc-445e-88a5-3ceeeff50b8e';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('95ebb82f-380e-4eac-b666-b341f603ae2e', v_meta_id, 2026, 1, 1960453.833333, 1768462.0, 'erp'),
    ('6be9e1fe-7497-449e-86e1-e79a8a82b832', v_meta_id, 2026, 2, 1960453.833333, 1317051.0, 'erp'),
    ('3052a8de-e66a-41af-820a-e44ca6e95e91', v_meta_id, 2026, 3, 1960453.833333, 1042247.0, 'erp'),
    ('fbfc8229-6bab-42c3-a331-ca03e1591e74', v_meta_id, 2026, 4, 1960453.833333, NULL, 'manual'),
    ('315483a2-ef96-48f1-a317-747f0ba47aa0', v_meta_id, 2026, 5, 1960453.833333, NULL, 'manual'),
    ('41d14194-a9e2-44c5-8dbf-1f1245ac6ef0', v_meta_id, 2026, 6, 1960453.833333, NULL, 'manual'),
    ('ba9df48b-edcf-47fb-a46f-c13aecf6cb70', v_meta_id, 2026, 7, 1960453.833333, NULL, 'manual'),
    ('e4ad84db-74c1-48e0-aade-362157381562', v_meta_id, 2026, 8, 1960453.833333, NULL, 'manual'),
    ('be4cd531-7fae-40b6-822a-93f0706d7866', v_meta_id, 2026, 9, 1960453.833333, NULL, 'manual'),
    ('a0ff3d2b-bbdc-4c4d-96de-c62a746f3674', v_meta_id, 2026, 10, 1960453.833333, NULL, 'manual'),
    ('43f6220c-9540-4e8e-9664-5664113e3c83', v_meta_id, 2026, 11, 1960453.833333, NULL, 'manual'),
    ('3069d3aa-55fb-4231-9b94-e528ae091cac', v_meta_id, 2026, 12, 1960453.833333, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 4.04 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000404';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 4.04: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('083457be-a748-4364-ae80-0e708690660e', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 1.0, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '083457be-a748-4364-ae80-0e708690660e';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('4774e987-c7a4-4147-83ad-b4887affc184', v_meta_id, 2026, 1, -76920.304528, -24358.977867, 'erp'),
    ('8bf3e9ef-1839-447e-8de6-ef01cfb1839f', v_meta_id, 2026, 2, -76920.304528, -5799.811252, 'erp'),
    ('2768da0e-4199-4434-9d32-464fc9e5ee50', v_meta_id, 2026, 3, -78580.304528, -18416.951252, 'erp'),
    ('433781cd-e192-41cb-83fc-fc5d6c909a5c', v_meta_id, 2026, 4, -76920.304528, NULL, 'manual'),
    ('83b281b0-3b42-4f8b-9de0-ebb4fa115bf8', v_meta_id, 2026, 5, -76920.304528, NULL, 'manual'),
    ('a84add20-aef1-454c-bd05-0bde4e55d802', v_meta_id, 2026, 6, -76920.304528, NULL, 'manual'),
    ('98c66ca3-ef89-4a7a-b3d8-0aa743a92e2d', v_meta_id, 2026, 7, -76920.304528, NULL, 'manual'),
    ('7340c108-39b2-46a5-8e93-3a5c122715d7', v_meta_id, 2026, 8, -76920.304528, NULL, 'manual'),
    ('3e58832b-d77c-4487-ac6f-ea5ad0ccd9d7', v_meta_id, 2026, 9, -76920.304528, NULL, 'manual'),
    ('95758a33-d64f-4cfe-968a-066150c193c0', v_meta_id, 2026, 10, -76920.304528, NULL, 'manual'),
    ('89dbc0cd-4e0f-4476-a692-274b3731f4a4', v_meta_id, 2026, 11, -76984.304528, NULL, 'manual'),
    ('c0c95877-016c-4ad8-946c-3008fdeaf1ea', v_meta_id, 2026, 12, -77483.818528, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 5.02 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000502';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 5.02: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('647aa1ae-2b9e-4622-8ecb-a8696a343a4c', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 0.6, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '647aa1ae-2b9e-4622-8ecb-a8696a343a4c';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('b99e4497-3f68-4d73-812d-2661adc6c5e8', v_meta_id, 2026, 1, -289154.823186, -337881.71885, 'erp'),
    ('7c49fa88-1039-400a-a4b0-79742dd09192', v_meta_id, 2026, 2, -281193.595186, -372243.514464, 'erp'),
    ('c23cac35-7d5d-41cb-8dcc-de598b2655dd', v_meta_id, 2026, 3, -264129.842486, -281850.623201, 'erp'),
    ('e93b7255-5b43-48b2-995f-7878032879d7', v_meta_id, 2026, 4, -259741.942186, 0.0, 'erp'),
    ('88c7fe81-8259-4b2b-961f-1810810d879b', v_meta_id, 2026, 5, -259904.562186, 0.0, 'erp'),
    ('0f36f153-82cb-4158-b210-33155586e666', v_meta_id, 2026, 6, -274022.894386, 0.0, 'erp'),
    ('1edc9ffc-a52a-4101-ba2a-70de2930490d', v_meta_id, 2026, 7, -276598.359366, 0.0, 'erp'),
    ('3873710d-4e02-4729-a919-8ae7fb1d823d', v_meta_id, 2026, 8, -272467.067045, 0.0, 'erp'),
    ('1a16b968-69da-4fc6-9c75-f494b4fc4cc7', v_meta_id, 2026, 9, -275567.136333, 0.0, 'erp'),
    ('e80f0bc3-ffbc-4d52-9300-4a9a88f19111', v_meta_id, 2026, 10, -258084.462186, 0.0, 'erp'),
    ('ca0fd997-9074-4e5d-819f-defa34bf8959', v_meta_id, 2026, 11, -263220.657088, 0.0, 'erp'),
    ('8867c5a5-4010-4677-83c3-1abd7f39402c', v_meta_id, 2026, 12, -338017.289174, 0.0, 'erp')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 2: Atendimento de Requisição de Manutenção
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('b9111380-1919-4c9d-a58b-9f186e40a2b1', v_kpi_id, v_kr_id, 2,
    'Atendimento de Requisição de Manutenção', 'Nível de atendimento de requisições em aberto',
    'percentual', 'maior', 0.2, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := 'b9111380-1919-4c9d-a58b-9f186e40a2b1';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('72ff0020-e862-4568-a9e1-5385d1748dd0', v_meta_id, 2026, 1, 0.9, NULL, 'manual'),
    ('52fb2691-a573-4f1f-b3d6-3da32d46526a', v_meta_id, 2026, 2, 0.9, NULL, 'manual'),
    ('40fe8e22-7398-4631-8d9c-569bcd192cb6', v_meta_id, 2026, 3, 0.9, NULL, 'manual'),
    ('2e3e2a19-59d5-4e7a-b181-4d436013cb24', v_meta_id, 2026, 4, 0.9, NULL, 'manual'),
    ('1d0892a6-3e8f-4622-a77d-d01d54bda867', v_meta_id, 2026, 5, 0.9, NULL, 'manual'),
    ('09b3190a-dfa8-479c-8b9b-11fc2e02efce', v_meta_id, 2026, 6, 0.9, NULL, 'manual'),
    ('f2e9c096-2811-4f3b-852d-6313c303915d', v_meta_id, 2026, 7, 0.9, NULL, 'manual'),
    ('439f7276-bbba-4699-9574-f5cc1c1bd6aa', v_meta_id, 2026, 8, 0.9, NULL, 'manual'),
    ('9835fbdf-f698-45bc-b4fc-2234a4998a8f', v_meta_id, 2026, 9, 0.9, NULL, 'manual'),
    ('540469fb-b0d3-4862-aad8-ab238c119835', v_meta_id, 2026, 10, 0.9, NULL, 'manual'),
    ('8d4b56e6-2bb1-4bab-8617-e3a315fe2d9a', v_meta_id, 2026, 11, 0.9, NULL, 'manual'),
    ('57397232-9325-4aa5-bf9b-f8a723bde0d5', v_meta_id, 2026, 12, 0.9, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 3: Score de Avaliação da Unidade
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('0c3271cc-4bed-4d11-948e-6f82c181a677', v_kpi_id, v_kr_id, 3,
    'Score de Avaliação da Unidade', '',
    'percentual', 'menor', 0.2, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '0c3271cc-4bed-4d11-948e-6f82c181a677';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('8d6a26e5-2a58-480f-83fe-fbabf8851614', v_meta_id, 2026, 1, 0.95, 0.96, 'erp'),
    ('5a369a85-ca34-43d2-9818-f11bff18c838', v_meta_id, 2026, 2, 0.95, 0.94, 'erp'),
    ('0de2c148-7fc9-42e6-80ff-32654cbf41c5', v_meta_id, 2026, 3, 0.95, 0.95, 'erp')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 5.04 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000504';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 5.04: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('1da8096f-45d9-4232-9928-8be19a7e3b99', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 0.6, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '1da8096f-45d9-4232-9928-8be19a7e3b99';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('5c964fa2-1d96-4f4a-8fed-b58fcce63517', v_meta_id, 2026, 1, -39160.573681, -24728.037174, 'erp'),
    ('052c53dd-ee85-4a45-ac4e-8ae7cd53c31b', v_meta_id, 2026, 2, -40317.822681, -34358.181116, 'erp'),
    ('4aa12443-fdd3-4a24-a7bb-1ed555fd62a3', v_meta_id, 2026, 3, -40005.277681, -57625.955512, 'erp'),
    ('3e79f8f5-705e-445f-adbd-a7d37413c12a', v_meta_id, 2026, 4, -42408.702681, NULL, 'manual'),
    ('38a7353a-fae6-4057-b873-94e4a357fca7', v_meta_id, 2026, 5, -39411.085681, NULL, 'manual'),
    ('22405b89-ac57-45b4-afc0-926dbc775964', v_meta_id, 2026, 6, -41774.036681, NULL, 'manual'),
    ('d6f9f565-68ae-48bd-8e71-1be51519019e', v_meta_id, 2026, 7, -42164.920737, NULL, 'manual'),
    ('05af6703-8402-448e-9a1f-f6efefa654ab', v_meta_id, 2026, 8, -38575.262681, NULL, 'manual'),
    ('989e3573-dca8-428a-b1e3-ef5ed3ef2ab1', v_meta_id, 2026, 9, -39050.218681, NULL, 'manual'),
    ('2521e317-a5c9-4185-99b7-6b65f16617a8', v_meta_id, 2026, 10, -39122.382681, NULL, 'manual'),
    ('d02b936e-0fe8-41ce-96c7-940b933ac05d', v_meta_id, 2026, 11, -42627.002681, NULL, 'manual'),
    ('b328c227-97e4-4933-b789-fd8f67d33461', v_meta_id, 2026, 12, -38020.757681, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 2: Custo por Atendimentos
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('32713a34-429e-4004-b453-a6321ec33c85', v_kpi_id, v_kr_id, 2,
    'Custo por Atendimentos', 'Valor total do Custo da área dividido pelo número de Atendimentos feitos no Sertão',
    'decimal', 'menor', 0.2, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '32713a34-429e-4004-b453-a6321ec33c85';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('992adcd5-60bc-4c9a-9587-ec8f7588ee01', v_meta_id, 2026, 1, 0.0, 0.0, 'erp'),
    ('7b4c0804-170d-41da-9ac2-f723ce151734', v_meta_id, 2026, 2, 35.522311, 34.846025, 'erp'),
    ('7d81a1af-e3a1-447a-a0cd-cd98a9e499db', v_meta_id, 2026, 3, 35.246941, 30.107605, 'erp'),
    ('9b2691db-603a-4a18-83cd-9696cc100340', v_meta_id, 2026, 4, 0.0, 0.0, 'erp'),
    ('166036de-a323-4d3b-ac9a-a67916df1d27', v_meta_id, 2026, 5, 0.0, 0.0, 'erp'),
    ('76bc15b6-7c9e-4ed9-b984-70712b3f2967', v_meta_id, 2026, 6, 0.0, 0.0, 'erp'),
    ('e325d5f3-9216-4308-a2aa-d9ed15d32248', v_meta_id, 2026, 7, 0.0, 0.0, 'erp'),
    ('63f6ef99-d9a1-428b-8ba3-b8805e29d4bf', v_meta_id, 2026, 8, 0.0, 0.0, 'erp'),
    ('da5e7aeb-f121-4d7f-962a-0b471e7cdb31', v_meta_id, 2026, 9, 0.0, 0.0, 'erp'),
    ('cdb856ee-24db-4028-8484-d3d8cd63aa64', v_meta_id, 2026, 10, 0.0, 0.0, 'erp'),
    ('47433f40-0753-45c2-9342-73c5c7c8ce3d', v_meta_id, 2026, 11, 0.0, 0.0, 'erp'),
    ('b3b13a10-7e69-44e2-8d0f-959ad1963e08', v_meta_id, 2026, 12, 0.0, 0.0, 'erp')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 3: Atendimentos Efetuados
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('0548aa3b-5f21-4219-9f7d-fc33739e6720', v_kpi_id, v_kr_id, 3,
    'Atendimentos Efetuados', 'Quantidade de Atendimentos apurados no SAB de médicos e dentistas',
    'inteiro', 'maior', 0.2, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '0548aa3b-5f21-4219-9f7d-fc33739e6720';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('d27e9cef-c1a7-46f8-88c2-7023c85a1e4b', v_meta_id, 2026, 1, 0.0, 0.0, 'erp'),
    ('ca638f68-be5a-44b0-b75a-06ada702d372', v_meta_id, 2026, 2, 1135.0, 986.0, 'erp'),
    ('7b3be337-42ab-4994-864c-e88bca982030', v_meta_id, 2026, 3, 1135.0, 1914.0, 'erp')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 5.05 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000505';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 5.05: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('4c3c547c-9e20-4181-a454-c30b88f77b7c', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 0.5, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '4c3c547c-9e20-4181-a454-c30b88f77b7c';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('736c68ef-1aa8-45dc-a1a1-9273276509f1', v_meta_id, 2026, 1, -464027.386486, -567423.79, 'erp'),
    ('00703645-ce01-4dea-9a6c-3f66b6d273de', v_meta_id, 2026, 2, -406791.502786, -410301.74, 'erp'),
    ('3c0fb21b-494b-406b-ba1c-7d81a58b84d0', v_meta_id, 2026, 3, -490145.315286, -584749.940194, 'erp'),
    ('a85a09d8-4ebd-4ffe-b95b-31aff3a291b5', v_meta_id, 2026, 4, -411653.249386, NULL, 'manual'),
    ('17a963ac-a154-4cf9-8f6f-803c187b421e', v_meta_id, 2026, 5, -466018.694086, NULL, 'manual'),
    ('a6451dea-c28c-43c8-8c1a-c00521b56024', v_meta_id, 2026, 6, -388638.479486, NULL, 'manual'),
    ('3fa686c7-4509-4b1d-9eb1-f7f305386702', v_meta_id, 2026, 7, -503941.346086, NULL, 'manual'),
    ('05876ab3-38ca-4519-b00c-dfb657c6a359', v_meta_id, 2026, 8, -432298.780586, NULL, 'manual'),
    ('a19cf2c7-0d1a-4ee2-94c9-2010c7ddfe29', v_meta_id, 2026, 9, -469110.170986, NULL, 'manual'),
    ('1592e5c3-59d1-4e88-aa3b-6c03c89e64a4', v_meta_id, 2026, 10, -472185.631386, NULL, 'manual'),
    ('7ce80f83-676f-4e14-adfe-f30da3c01f77', v_meta_id, 2026, 11, -341849.858986, NULL, 'manual'),
    ('17ab03c6-f4e5-4879-9b05-41569a7b3e5e', v_meta_id, 2026, 12, -551607.830086, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 3: Utilização da Frota
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('3c49e38d-57d4-454a-b96a-0513d07d7fa4', v_kpi_id, v_kr_id, 3,
    'Utilização da Frota', 'Índice de veículos ativos x Veículos em manutenção medidos ao final de cada mês. Meta 90% da Frota em Atividade Constante maior que 50 km',
    'inteiro', 'maior', 0.3, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '3c49e38d-57d4-454a-b96a-0513d07d7fa4';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('bc2c730e-b649-41fc-b383-4ccb694699c5', v_meta_id, 2026, 1, 174.0, 167.0, 'erp'),
    ('2df5a74e-56ef-41f1-8a22-37fef4fc7e01', v_meta_id, 2026, 2, 174.0, 165.0, 'erp'),
    ('b145ab21-8dcb-45c2-8098-362b9d375255', v_meta_id, 2026, 3, 175.0, 170.0, 'erp')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 3: Score Frota
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('8aacfdb9-f9c7-44c1-bce5-8f7ef8cd98e0', v_kpi_id, v_kr_id, 3,
    'Score Frota', 'Idicador de Score gerado pela Auditoria Interna',
    'percentual', 'menor', 0.3, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '8aacfdb9-f9c7-44c1-bce5-8f7ef8cd98e0';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('39bc31d9-90b7-49d7-91e0-e77d9505efe6', v_meta_id, 2026, 1, 0.9, NULL, 'manual'),
    ('5cc9f05f-ff87-4ce2-bacc-41cb60676e97', v_meta_id, 2026, 2, 0.9, NULL, 'manual'),
    ('2f688f87-17a2-4d38-ba4f-22f3175af10c', v_meta_id, 2026, 3, 0.9, NULL, 'manual'),
    ('b6e4886b-5c13-47b2-87fd-878db22847eb', v_meta_id, 2026, 4, 0.9, NULL, 'manual'),
    ('ff3c0847-c616-482f-ae84-3d523601d7ea', v_meta_id, 2026, 5, 0.9, NULL, 'manual'),
    ('d4744fd9-2e28-46ab-861c-6d6e15f87db4', v_meta_id, 2026, 6, 0.9, NULL, 'manual'),
    ('00f7fd3c-6206-42b4-ad83-122fa5e6ec4e', v_meta_id, 2026, 7, 0.9, NULL, 'manual'),
    ('4285c995-ce69-44df-8d25-3eea4289047c', v_meta_id, 2026, 8, 0.9, NULL, 'manual'),
    ('83b9af14-0fd2-4ab8-b168-421810b2711d', v_meta_id, 2026, 9, 0.9, NULL, 'manual'),
    ('4e49d590-f54d-4d89-a7b3-a1a0148baf47', v_meta_id, 2026, 10, 0.9, NULL, 'manual'),
    ('5030333c-391b-4d8c-9fda-c52ea95a8c83', v_meta_id, 2026, 11, 0.9, NULL, 'manual'),
    ('9d5c3b9a-4c81-4137-9190-a3eadd9bf6e4', v_meta_id, 2026, 12, 0.9, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 5.07 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000507';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 5.07: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('27bb255d-b8c6-4e17-9806-b7628b392a33', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 0.8, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '27bb255d-b8c6-4e17-9806-b7628b392a33';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('9848b288-1f3b-4cc1-9513-d0ebaa0708dc', v_meta_id, 2026, 1, -780366.600597, -1278533.347273, 'erp'),
    ('dd46d14b-7bd7-4e69-92b1-de3e7725d414', v_meta_id, 2026, 2, -670562.566597, -135443.2653, 'erp'),
    ('c98f85a4-d203-45af-a5ca-98739dbf4349', v_meta_id, 2026, 3, -662809.146597, -817936.446261, 'erp'),
    ('f6eb931a-1a57-463a-a370-6211a13f5999', v_meta_id, 2026, 4, -692765.087597, NULL, 'manual'),
    ('a42c9262-7ee8-4828-b47f-bd88ccf56296', v_meta_id, 2026, 5, -665580.900597, NULL, 'manual'),
    ('4485497a-addb-4f25-8869-4089d8abda81', v_meta_id, 2026, 6, -723968.528318, NULL, 'manual'),
    ('d732ce68-c51b-4fc2-8743-3ba4074e1a1a', v_meta_id, 2026, 7, -699958.407681, NULL, 'manual'),
    ('a85d3c48-0ddb-419c-b3cc-93e04740b117', v_meta_id, 2026, 8, -689144.213494, NULL, 'manual'),
    ('6f332f15-fcf8-4dfe-830d-cd250daa46de', v_meta_id, 2026, 9, -708161.714597, NULL, 'manual'),
    ('ef2cb72e-3fcf-4bb6-ad67-c20ed8a3e8d7', v_meta_id, 2026, 10, -696967.449097, NULL, 'manual'),
    ('62804651-b740-4eeb-b3b6-bb50bd701b12', v_meta_id, 2026, 11, -707188.174597, NULL, 'manual'),
    ('b0917461-dca1-4fb8-bdc9-1890e8c0e226', v_meta_id, 2026, 12, -814927.255597, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 3: Alimentos Distribuidos
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('531558c9-5913-43f8-9e60-b717961dca1e', v_kpi_id, v_kr_id, 3,
    'Alimentos Distribuidos', '',
    'monetario', 'maior', 0.2, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '531558c9-5913-43f8-9e60-b717961dca1e';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('87af41d0-318d-4c11-9852-2f43fb72ee9a', v_meta_id, 2026, 1, 173810.75, 3550.0, 'erp'),
    ('00861c25-aa4e-4d52-8e48-d0130b344053', v_meta_id, 2026, 2, 173810.75, 8182.0, 'erp'),
    ('b07b54b3-1918-4324-96f3-c8e0eb474652', v_meta_id, 2026, 3, 173810.75, 18330.0, 'erp'),
    ('eec090a0-558b-4e49-8602-c17baa172022', v_meta_id, 2026, 4, 173810.75, NULL, 'manual'),
    ('defaf444-74bf-4837-958b-3f0441aa5fe3', v_meta_id, 2026, 5, 173810.75, NULL, 'manual'),
    ('b912019a-61cb-49df-aa27-a0b31705fd21', v_meta_id, 2026, 6, 173810.75, NULL, 'manual'),
    ('a8885a53-48a2-44aa-ab56-72fbda912f68', v_meta_id, 2026, 7, 173810.75, NULL, 'manual'),
    ('db426f3f-5084-492b-a0fa-cc6ce0564aa7', v_meta_id, 2026, 8, 173810.75, NULL, 'manual'),
    ('cbb10ed1-0bbf-4f62-bfd1-46070b5434f6', v_meta_id, 2026, 9, 173810.75, NULL, 'manual'),
    ('ffa8eccf-995f-42ce-99ef-d2d76f3114d4', v_meta_id, 2026, 10, 173810.75, NULL, 'manual'),
    ('de381ab1-1f09-4971-a2d9-5cb5e2ec226a', v_meta_id, 2026, 11, 173810.75, NULL, 'manual'),
    ('1456b62a-df6d-42c8-847e-86fa92676edc', v_meta_id, 2026, 12, 173810.75, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 5.08 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000508';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 5.08: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('11d0dd32-faca-43a5-8ece-d3b927054035', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 0.2, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '11d0dd32-faca-43a5-8ece-d3b927054035';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('d92bd69d-a2f7-443a-a26b-f9a620f920b6', v_meta_id, 2026, 1, -717734.866456, -196552.491684, 'erp'),
    ('e1d0af90-d79a-4ff8-ac62-be861e75c145', v_meta_id, 2026, 2, -169431.544931, -127526.308179, 'erp'),
    ('fa814300-3659-4c3a-97c8-3ea4642a95e5', v_meta_id, 2026, 3, -236480.815416, -596419.448854, 'erp'),
    ('883f3055-3dab-4018-abf7-8e5cdac362ce', v_meta_id, 2026, 4, -244718.446826, NULL, 'manual'),
    ('84ff1fc4-5cb6-4a78-979a-bdf80cd8eac1', v_meta_id, 2026, 5, -153812.653191, NULL, 'manual'),
    ('8479b5c7-76fe-4549-8733-d4824917eaff', v_meta_id, 2026, 6, -192995.648811, NULL, 'manual'),
    ('31497652-cc49-4b1a-b912-f4deb3ffb861', v_meta_id, 2026, 7, -168969.265026, NULL, 'manual'),
    ('1e50b1c5-3e91-4bff-8697-c5355b1d11b0', v_meta_id, 2026, 8, -166368.054651, NULL, 'manual'),
    ('96d7dc1e-ef93-4639-9f63-b81fb24f02e6', v_meta_id, 2026, 9, -109415.301041, NULL, 'manual'),
    ('49d11e95-19ec-4576-a5bb-9b5bb3cd6d2b', v_meta_id, 2026, 10, -114056.299281, NULL, 'manual'),
    ('183ac849-622b-486e-bde2-6e96db833f4d', v_meta_id, 2026, 11, -106572.161096, NULL, 'manual'),
    ('34a4ef12-e01f-42fd-9f6d-9910c6e668cf', v_meta_id, 2026, 12, -122858.461966, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 2: Receita Arrecadação PF
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('c19cf7ec-03da-4500-8e40-8a923b347531', v_kpi_id, v_kr_id, 2,
    'Receita Arrecadação PF', 'Receitas Recorrentes',
    'monetario', 'maior', 0.6, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := 'c19cf7ec-03da-4500-8e40-8a923b347531';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('614ab05e-06d8-4c3f-aefb-5a00536f79dd', v_meta_id, 2026, 1, 2869803.904, 1816707.27, 'erp'),
    ('8daeaffc-55de-439a-bf39-03b48e37a4d3', v_meta_id, 2026, 2, 2137478.376, 1841198.28, 'erp'),
    ('1c5ae291-9edc-4443-a577-721efb495519', v_meta_id, 2026, 3, 2111105.359, 1955357.75, 'erp'),
    ('0414319e-1986-49a6-9b1d-2721c75b75ae', v_meta_id, 2026, 4, 2088271.669, NULL, 'manual'),
    ('60643b66-dc9c-46d4-bea5-59d3b5893cd9', v_meta_id, 2026, 5, 2058242.043, NULL, 'manual'),
    ('09d728e7-43af-4efd-9b84-123d4251447f', v_meta_id, 2026, 6, 2060826.922, NULL, 'manual'),
    ('fd89c683-ecf0-41f7-aed3-1096b0fa5232', v_meta_id, 2026, 7, 2442471.856, NULL, 'manual'),
    ('443b26cc-c258-4b3e-a15e-d9eebac0ed11', v_meta_id, 2026, 8, 2202215.983, NULL, 'manual'),
    ('9d2c4a45-e396-42bf-9964-d4b8c06771f5', v_meta_id, 2026, 9, 2429219.331, NULL, 'manual'),
    ('920e5a01-3316-4ea9-9454-949230b00df7', v_meta_id, 2026, 10, 2432976.524, NULL, 'manual'),
    ('4d05642a-057c-442f-a6e1-3692b94eeaa3', v_meta_id, 2026, 11, 2762262.855, NULL, 'manual'),
    ('0b7a51db-8569-4c35-827e-56970ad9058b', v_meta_id, 2026, 12, 4735617.634, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 3: Quantidade de Doadores
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('6f9ac172-488b-4137-9438-788510898ca4', v_kpi_id, v_kr_id, 3,
    'Quantidade de Doadores', 'Evolução de Quantidade de Doadores Recorrentes Iniciativa PF',
    'inteiro', 'maior', 0.2, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '6f9ac172-488b-4137-9438-788510898ca4';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('f4e76fd4-e996-4bdb-964d-f37619d783d5', v_meta_id, 2026, 1, 20000.0, 19124.0, 'erp'),
    ('f00ea47b-c975-4161-ac0e-71d832366a6d', v_meta_id, 2026, 2, 20000.0, 18315.0, 'erp'),
    ('0c5dd75c-d074-4883-b71b-61154e50733c', v_meta_id, 2026, 3, 25000.0, 19485.0, 'erp'),
    ('d9f35a05-e35d-442e-98bf-09b40109ae54', v_meta_id, 2026, 4, 25000.0, NULL, 'manual'),
    ('a49985ca-90b6-4c16-850f-38c8ac88c538', v_meta_id, 2026, 5, 25000.0, NULL, 'manual'),
    ('36a7c603-b176-4dd5-a306-2705dad67630', v_meta_id, 2026, 6, 25000.0, NULL, 'manual'),
    ('e86f0428-21e1-4329-84ee-f5b20b5ea4f2', v_meta_id, 2026, 7, 30000.0, NULL, 'manual'),
    ('6b4fa6a9-6e70-4572-8845-317872323e82', v_meta_id, 2026, 8, 30000.0, NULL, 'manual'),
    ('fb20c410-c715-432d-9525-2341299cc9a1', v_meta_id, 2026, 9, 30000.0, NULL, 'manual'),
    ('1607ced3-4359-4b05-92b4-0314e1b45941', v_meta_id, 2026, 10, 30000.0, NULL, 'manual'),
    ('4428f2ae-8381-48ab-afde-54cb8eec0c0a', v_meta_id, 2026, 11, 30000.0, NULL, 'manual'),
    ('d9a32ee3-38cf-4f60-9cba-46632d87a4a4', v_meta_id, 2026, 12, 30000.0, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

  -- Meta 4: Receita de Arrecadação Pontual
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('04197230-e7d0-4c16-8eac-2c6b89abd3d5', v_kpi_id, v_kr_id, 4,
    'Receita de Arrecadação Pontual', 'Receitas Pontuais',
    'inteiro', 'maior', 0.2, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '04197230-e7d0-4c16-8eac-2c6b89abd3d5';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('acc1c94d-4a17-49a2-99c1-88b444c6587c', v_meta_id, 2026, 1, 20000.0, 19124.0, 'erp'),
    ('98d6209a-f39c-4b90-a90a-f54f0d6aaf48', v_meta_id, 2026, 2, 20000.0, 18315.0, 'erp'),
    ('9a697418-fb47-4711-a82a-d66dd6b75260', v_meta_id, 2026, 3, 25000.0, 19485.0, 'erp'),
    ('a962a547-5a99-49d3-a776-5b6982d4412f', v_meta_id, 2026, 4, 25000.0, NULL, 'manual'),
    ('05fc6603-2751-4c4f-bbdd-7fbceb507214', v_meta_id, 2026, 5, 25000.0, NULL, 'manual'),
    ('f93ba0a8-a624-4b1e-ba6b-c2bf61e5fede', v_meta_id, 2026, 6, 25000.0, NULL, 'manual'),
    ('d0668747-ceec-43e6-a73d-667bb9ee955b', v_meta_id, 2026, 7, 30000.0, NULL, 'manual'),
    ('2a371d8f-1c28-4b4e-825c-e94971065606', v_meta_id, 2026, 8, 30000.0, NULL, 'manual'),
    ('631f9aee-e311-4bf5-a81c-81e0076ae988', v_meta_id, 2026, 9, 30000.0, NULL, 'manual'),
    ('e00a3b43-d5bf-4d71-923f-9008e5e2e913', v_meta_id, 2026, 10, 30000.0, NULL, 'manual'),
    ('b805ed39-0da7-40f6-bd02-3351a2c56d76', v_meta_id, 2026, 11, 30000.0, NULL, 'manual'),
    ('3e09cfcf-0038-4f4b-95a6-8456fbaf9add', v_meta_id, 2026, 12, 30000.0, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;


-- ── KPI 5.10 ──────────────────────────────────────────────────
DO $$
DECLARE
  v_kpi_id  UUID := 'd7f1a000-0000-0000-0000-000000000510';
  v_kr_id   UUID;
  v_meta_id UUID;
BEGIN

  -- Pega o primeiro kpi_responsavel deste KPI
  SELECT id INTO v_kr_id FROM public.kpi_responsaveis
    WHERE id_kpi = v_kpi_id AND ativo = TRUE ORDER BY responsavel LIMIT 1;

  IF v_kr_id IS NULL THEN
    RAISE WARNING 'KPI 5.10: nenhum kpi_responsavel encontrado, pulando';
    RETURN;
  END IF;

  -- Meta 1: Acompanhamento Orçamentário
  INSERT INTO public.metas (id, id_kpi, id_kpi_responsavel, numero_meta,
    nome_curto, descricao, tipo_formato, bom_quando, peso, ano)
  VALUES ('73c4018e-7a0d-4e48-acd6-459fbabfaef7', v_kpi_id, v_kr_id, 1,
    'Acompanhamento Orçamentário', 'Manter o valor do realizado abaixo do valor estabelecido no Planejamento Orçamentário',
    'monetario', 'menor', 0.8, 2026)
  ON CONFLICT DO NOTHING;
  v_meta_id := '73c4018e-7a0d-4e48-acd6-459fbabfaef7';

  INSERT INTO public.metas_mensais
    (id, id_meta, ano, mes, valor_meta, valor_realizado, origem_realizado)
  VALUES
    ('167c5c50-8edc-4ca0-a265-f356bfdb19c3', v_meta_id, 2026, 1, -31024.27175, -42494.505736, 'erp'),
    ('c21987db-6bf7-4689-a685-197f39c36020', v_meta_id, 2026, 2, -35556.41475, -29948.724638, 'erp'),
    ('cb7dfdda-f54e-4c6f-a210-229ffd2a8661', v_meta_id, 2026, 3, -33053.15975, -36633.627295, 'erp'),
    ('6dbf811f-220e-4311-bf8f-2c87888dcf4d', v_meta_id, 2026, 4, -35007.44275, NULL, 'manual'),
    ('f6463a46-27d9-4c66-8140-49a72fb66232', v_meta_id, 2026, 5, -35852.91675, NULL, 'manual'),
    ('10ddaf0f-b4ff-45da-a879-d6b121813352', v_meta_id, 2026, 6, -37470.72975, NULL, 'manual'),
    ('2806101c-82f7-437d-ad66-8b9a481e9912', v_meta_id, 2026, 7, -35141.11675, NULL, 'manual'),
    ('af6794ca-ec29-43ee-a17c-3b3e6959a016', v_meta_id, 2026, 8, -33262.97975, NULL, 'manual'),
    ('495dd5de-a5f9-483a-85c4-8cde76641c68', v_meta_id, 2026, 9, -35003.55075, NULL, 'manual'),
    ('0fddd9f8-76a0-4418-8b48-5a6d37cb9f77', v_meta_id, 2026, 10, -38616.33975, NULL, 'manual'),
    ('16998b17-5f8d-497f-87a5-c58b18fa9989', v_meta_id, 2026, 11, -37925.70875, NULL, 'manual'),
    ('fe345c89-a7ec-4442-af13-65d5aca95386', v_meta_id, 2026, 12, -36148.70375, NULL, 'manual')
  ON CONFLICT (id_meta, ano, mes) DO UPDATE SET
    valor_meta = EXCLUDED.valor_meta,
    valor_realizado = EXCLUDED.valor_realizado;

END $$;
