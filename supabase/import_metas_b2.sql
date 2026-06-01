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


