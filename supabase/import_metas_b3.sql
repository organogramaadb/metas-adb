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
