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


