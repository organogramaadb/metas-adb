// ============================================================
// api.js — Supabase Client v2
// Substitui toda comunicação com Google Apps Script
// Quando SUPA_URL estiver vazio, opera em modo demo (in-memory)
// ============================================================

const SUPA_URL = 'https://fibamjsjksszyrfqgszq.supabase.co';
const SUPA_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZpYmFtanNqa3NzenlyZnFnc3pxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODIzOTcyMjUsImV4cCI6MjA5Nzk3MzIyNX0.HOINhPxouui6GJoGSFv4coboAR853Uv1MqlwheUIJl0';

// Mapeamento de perfil Supabase (DB) → engine.js
const PERFIL_MAP = {
  'administrador': 'Admin',
  'diretoria_n1':  'DiretorN1',
  'diretor':       'Diretor',
  'responsavel':   'Responsavel',
};

const _supa = (SUPA_URL && SUPA_KEY)
  ? window.supabase.createClient(SUPA_URL, SUPA_KEY)
  : null;

function isLiveMode() { return !!(SUPA_URL && SUPA_KEY); }

// ── fillDemo — preenche campos de login para demonstração ─────
function fillDemo(email, pwd) {
  document.getElementById('inp-email').value = email;
  document.getElementById('inp-pwd').value   = pwd;
}

// ── doLogin ───────────────────────────────────────────────────
async function doLogin(event) {
  event.preventDefault();
  const email = document.getElementById('inp-email').value.trim().toLowerCase();
  const pwd   = document.getElementById('inp-pwd').value;
  const errEl = document.getElementById('lerr');
  errEl.style.display = 'none';

  if (!isLiveMode()) {
    // Demo mode: autenticação in-memory via engine.js
    const u = login(email, pwd);
    if (!u) { errEl.style.display = 'block'; return; }
    DB.usuario = u;
    initApp();
    return;
  }

  // Live mode: Supabase Auth
  const { error: authError } = await _supa.auth.signInWithPassword({ email, password: pwd });
  if (authError) {
    errEl.textContent = 'E-mail ou senha incorretos.';
    errEl.style.display = 'block';
    return;
  }

  // Busca perfil na tabela usuarios
  const { data: perfil, error: perfilError } = await _supa
    .from('usuarios')
    .select('nome, perfil_acesso, responsavel_vinculado, diretoria_vinculada, ativo')
    .eq('email', email)
    .single();

  if (perfilError || !perfil || !perfil.ativo) {
    await _supa.auth.signOut();
    errEl.textContent = 'Acesso não autorizado. Contate o administrador.';
    errEl.style.display = 'block';
    return;
  }

  // Monta objeto de usuário compatível com engine.js
  const perfilMapped = PERFIL_MAP[perfil.perfil_acesso] || perfil.perfil_acesso;
  DB.usuario = {
    email,
    nome:        perfil.nome,
    perfil:      perfilMapped,
    responsavel: perfil.responsavel_vinculado,
    diretoria:   perfil.diretoria_vinculada,
    ativo:       true,
  };
  SESSION = DB.usuario;

  await loadData();
  initApp();
}

// ── doLogout ──────────────────────────────────────────────────
async function doLogout() {
  if (isLiveMode()) await _supa.auth.signOut();
  logout();   // engine.js — limpa SESSION
  DB.usuario = null;
  document.getElementById('app').classList.remove('on');
  document.getElementById('lo').style.display = 'flex';
  document.getElementById('inp-pwd').value = '';
}

// ── loadData — carga completa do banco ────────────────────────
async function loadData() {
  if (!isLiveMode()) return;
  try {
    const [
      { data: kpis,         error: e1 },
      { data: kpiResps,     error: e2 },
      { data: metas,        error: e3 },
      { data: metasMensais, error: e4 },
      { data: projetos,     error: e5 },
      { data: logs,         error: e6 },
    ] = await Promise.all([
      _supa.from('kpis').select('*').eq('ativo', true).order('ordem_exibicao'),
      _supa.from('kpi_responsaveis').select('id, id_kpi, responsavel, diretor').eq('ativo', true),
      _supa.from('metas').select('*').eq('ativo', true).order('id_kpi').order('seq'),
      _supa.from('metas_mensais').select('*').order('id_meta').order('ano').order('mes'),
      _supa.from('projetos').select('*').eq('ativo', true),
      _supa.from('logs_auditoria').select('*').order('data_hora', { ascending: false }).limit(200),
    ]);

    if (e1 || e2 || e3 || e4 || e5 || e6) throw new Error('Erro ao carregar dados do banco');

    // Constrói mapas a partir de kpi_responsaveis:
    //   respMap[id_kpi]   → array de nomes de responsáveis
    //   diretorMap[id_kpi] → nome do primeiro diretor
    //   krIdMap[kr.id]    → nome do responsável (para resolver id_kpi_responsavel em metas)
    const respMap    = {};
    const diretorMap = {};
    const krIdMap    = {};   // kpi_responsavel UUID → nome
    for (const kr of (kpiResps || [])) {
      if (!respMap[kr.id_kpi]) respMap[kr.id_kpi] = [];
      respMap[kr.id_kpi].push(kr.responsavel);
      if (!diretorMap[kr.id_kpi] && kr.diretor) diretorMap[kr.id_kpi] = kr.diretor;
      if (kr.id) krIdMap[kr.id] = kr.responsavel;
    }

    // KPIs: normaliza area (UPPERCASE) — areaLabel() cuida do display
    DB.kpis = (kpis || []).map(k => ({
      ...k,
      responsaveis: respMap[k.id]    || [],
      diretoria:    diretorMap[k.id] || '',
    }));

    // Colunas do banco agora batem com o frontend:
    //   nome (era nome_curto), seq (era numero_meta), status (era status_meta)
    // Mapeamentos restantes:
    //   status 'ativa'→'Ativa' para os selects do drawer
    //   id_kpi_responsavel (UUID) → responsavel (nome legível via krIdMap)
    //   atualizado_em → ult_at
    const STATUS_DISPLAY = { ativa: 'Ativa', suspensa: 'Suspensa', encerrada: 'Concluída' };
    DB.metas = (metas || []).map(m => ({
      ...m,
      seq:            parseInt(m.seq)  || 1,
      peso:           parseFloat(m.peso) || 0,
      responsavel:    krIdMap[m.id_kpi_responsavel] || '',
      status:         STATUS_DISPLAY[m.status] || m.status || 'Ativa',
      obs:            '',
      ult_at:         m.atualizado_em
                        ? new Date(m.atualizado_em).toLocaleDateString('pt-BR')
                        : '—',
      tipo_formato:        m.tipo_formato        || 'decimal',
      bom_quando:          m.bom_quando          || 'maior',
      formula_atingimento: m.formula_atingimento || 'real_sobre_meta',
      tipo_acumulado:      m.tipo_acumulado      || 'soma',
    }));

    DB.metasMensais = (metasMensais || []).map(r => ({
      ...r,
      ano:             parseInt(r.ano) || 2026,
      mes:             parseInt(r.mes) || 1,
      valor_meta:      r.valor_meta      != null ? parseFloat(r.valor_meta)      : null,
      valor_realizado: r.valor_realizado != null ? parseFloat(r.valor_realizado) : null,
    }));

    // Projetos: mapeia banco → frontend
    //   observacoes → obs | atualizado_em → data_atualizacao | status/prioridade → rótulos
    //   id_kpi derivado via id_meta (a tabela projetos só guarda id_meta)
    const metaToKpi = {};
    DB.metas.forEach(m => { metaToKpi[m.id] = m.id_kpi; });
    const ST_DISPLAY = { nao_iniciado:'Não iniciado', em_andamento:'Em andamento', em_atraso:'Em atraso', concluido:'Concluído', suspenso:'Suspenso', cancelado:'Cancelado' };
    const PR_DISPLAY = { baixa:'Baixa', media:'Média', alta:'Alta', critica:'Crítica' };
    DB.projetos = (projetos || []).map(p => ({
      ...p,
      id_kpi:              metaToKpi[p.id_meta] || null,
      percentual_evolucao: parseFloat(p.percentual_evolucao) || 0,
      status:              ST_DISPLAY[p.status] || p.status || 'Não iniciado',
      prioridade:          PR_DISPLAY[p.prioridade] || p.prioridade || 'Média',
      obs:                 p.observacoes || '',
      data_atualizacao:    p.atualizado_em ? new Date(p.atualizado_em).toLocaleDateString('pt-BR') : '',
    }));

    // Logs vindos do servidor já estão persistidos — marca como sincronizados
    // para não serem reenviados. Sem isso, todo save (meta/projeto/KPI/usuário)
    // reenviava o histórico de auditoria inteiro de volta ao banco a cada
    // clique em Salvar (causava dezenas/centenas de requisições por save,
    // travando a aba e dando a impressão de "não salva").
    DB.logs = (logs || []).map(l => ({ ...l, _synced: true }));

    // Sincroniza array global KPIS (usado por engine.js / app.js)
    KPIS.length = 0;
    DB.kpis.forEach(k => KPIS.push(k));

    const badge = document.getElementById('mode-badge');
    if (badge) { badge.textContent = 'LIVE'; badge.classList.add('live'); }

  } catch (err) {
    console.error('loadData error:', err);
    toast('Erro ao carregar dados: ' + err.message, 'err');
  }
}

// ── apiSaveMeta ───────────────────────────────────────────────
// Traduz o objeto frontend (campos como 'nome', 'seq', 'status') para
// o schema real da tabela metas no Supabase.
async function apiSaveMeta(payload, forceNew = false) {
  if (!isLiveMode()) return { ok: true, demo: true };

  // id_kpi_responsavel: se não vier no payload, busca o primeiro para o KPI
  let krId = payload.id_kpi_responsavel;
  if (!krId && payload.id_kpi) {
    const { data: kr } = await _supa
      .from('kpi_responsaveis')
      .select('id')
      .eq('id_kpi', payload.id_kpi)
      .eq('ativo', true)
      .order('responsavel')
      .limit(1)
      .single();
    krId = kr?.id || null;
  }
  if (!krId) throw new Error('KPI sem responsável cadastrado. Cadastre um responsável primeiro.');

  // Colunas do banco agora batem com o frontend: nome, seq, status
  // Apenas filtra campos que não existem na tabela (responsavel, obs, ult_at, _isNew, etc.)
  const STATUS_DB = { Ativa: 'ativa', Suspensa: 'suspensa', 'Concluída': 'encerrada' };
  const dbPayload = {
    id:                  payload.id,
    id_kpi:              payload.id_kpi,
    id_kpi_responsavel:  krId,
    seq:                 parseInt(payload.seq) || 1,
    nome:                payload.nome || '',
    descricao:           payload.descricao || '',
    unidade_medida:      payload.unidade_medida || '',
    tipo_formato:        payload.tipo_formato || 'decimal',
    bom_quando:          (payload.bom_quando || 'maior').toLowerCase(),
    peso:                parseFloat(payload.peso) || 0,
    formula_atingimento: payload.formula_atingimento || 'real_sobre_meta',
    tipo_acumulado:      payload.tipo_acumulado || 'soma',
    status:              STATUS_DB[payload.status] || payload.status || 'ativa',
    ano:                 payload.ano || 2026,
    ativo:               payload.ativo !== false,
  };

  // INSERT para metas novas, UPDATE para existentes
  // Evita o problema de RLS com UPSERT (PostgreSQL verifica INSERT antes de saber se é UPDATE)
  const isNew = forceNew || !!payload._isNew;
  let error;
  if (isNew) {
    ({ error } = await _supa.from('metas').insert(dbPayload));
  } else {
    ({ error } = await _supa.from('metas').update(dbPayload).eq('id', dbPayload.id));
  }
  if (error) throw error;

  // Atualiza cache local
  const idx = DB.metas.findIndex(m => m.id === payload.id);
  if (idx >= 0) DB.metas[idx] = { ...DB.metas[idx], ...payload, id_kpi_responsavel: krId };
  else          DB.metas.push({ ...payload, id_kpi_responsavel: krId });
  return { ok: true };
}

// ── apiSaveMetaMensal ─────────────────────────────────────────
// Payload limpo (só colunas da tabela). NÃO envia 'id': o banco gera no
// insert e o conflito é resolvido por (id_meta, ano, mes). Isso evita erro
// quando a meta é nova e o registro mensal tinha id provisório (mm-xxx).
async function apiSaveMetaMensal(payload) {
  if (!isLiveMode()) return { ok: true, demo: true };
  const dbPayload = {
    id_meta:          payload.id_meta,
    ano:              parseInt(payload.ano) || 2026,
    mes:              parseInt(payload.mes),
    valor_meta:       (payload.valor_meta      != null && payload.valor_meta      !== '') ? parseFloat(payload.valor_meta)      : null,
    valor_realizado:  (payload.valor_realizado != null && payload.valor_realizado !== '') ? parseFloat(payload.valor_realizado) : null,
    origem_realizado: payload.origem_realizado || 'manual',
  };
  const { error } = await _supa
    .from('metas_mensais')
    .upsert(dbPayload, { onConflict: 'id_meta,ano,mes' });
  if (error) throw error;
  const idx = DB.metasMensais.findIndex(
    m => m.id_meta === payload.id_meta && m.mes === payload.mes && m.ano === payload.ano
  );
  if (idx >= 0) DB.metasMensais[idx] = { ...DB.metasMensais[idx], ...payload };
  else          DB.metasMensais.push(payload);
  return { ok: true };
}

// ── apiSaveProject ────────────────────────────────────────────
// Mapeia o objeto frontend para o schema da tabela projetos:
//   obs → observacoes | rótulos de status/prioridade → enums lowercase
//   id_kpi/data_*/usuario_* descartados (não existem na tabela)
const STATUS_PROJ_DB = { 'Não iniciado':'nao_iniciado', 'Em andamento':'em_andamento', 'Em atraso':'em_atraso', 'Concluído':'concluido', 'Suspenso':'suspenso', 'Cancelado':'cancelado' };
const PRIO_PROJ_DB   = { 'Baixa':'baixa', 'Média':'media', 'Alta':'alta', 'Crítica':'critica' };

async function apiSaveProject(proj) {
  if (!isLiveMode()) return { ok: true, demo: true };

  const dbPayload = {
    id:                  proj.id,
    id_meta:             proj.id_meta,
    nome:                proj.nome || '',
    descricao:           proj.descricao || '',
    responsavel:         proj.responsavel || '',
    status:              STATUS_PROJ_DB[proj.status] || proj.status || 'nao_iniciado',
    prazo:               proj.prazo || null,
    percentual_evolucao: parseFloat(proj.percentual_evolucao) || 0,
    prioridade:          PRIO_PROJ_DB[proj.prioridade] || proj.prioridade || 'media',
    proxima_acao:        proj.proxima_acao || '',
    responsavel_acao:    proj.responsavel_acao || '',
    observacoes:         proj.obs || proj.observacoes || '',
    ativo:               proj.ativo !== false,
  };

  // INSERT para novos, UPDATE para existentes (evita problema de RLS no UPSERT)
  const isNew = !!proj._isNew;
  let error;
  if (isNew) {
    ({ error } = await _supa.from('projetos').insert(dbPayload));
  } else {
    ({ error } = await _supa.from('projetos').update(dbPayload).eq('id', dbPayload.id));
  }
  if (error) throw error;

  delete proj._isNew;  // já persistido — próximos saves serão UPDATE
  const idx = DB.projetos.findIndex(p => p.id === proj.id);
  if (idx >= 0) DB.projetos[idx] = { ...DB.projetos[idx], ...proj };
  else          DB.projetos.push(proj);
  return { ok: true };
}

// ── apiDeleteProject ──────────────────────────────────────────
async function apiDeleteProject(id) {
  if (!isLiveMode()) return { ok: true, demo: true };
  const { error } = await _supa.from('projetos').delete().eq('id', id);
  if (error) throw error;
  DB.projetos = DB.projetos.filter(p => p.id !== id);
  return { ok: true };
}

// ── apiDeleteMeta ─────────────────────────────────────────────
// Soft delete (ativo=false): preserva histórico de auditoria e não quebra
// projetos vinculados. A meta some das telas mas continua no banco.
async function apiDeleteMeta(id) {
  if (!isLiveMode()) return { ok: true, demo: true };
  const { error } = await _supa.from('metas').update({ ativo: false }).eq('id', id);
  if (error) throw error;
  DB.metas = DB.metas.filter(m => m.id !== id);
  return { ok: true };
}

// ── apiSaveKpi ────────────────────────────────────────────────
// O objeto KPI do frontend mistura dados de duas tabelas:
//   tabela kpis            → nome, area, descricao, nome_completo
//   tabela kpi_responsaveis → responsaveis (array), diretoria
// Esta função grava cada campo na tabela correta.
const AREAS_VALIDAS = ['ORGANIZACIONAL','ADMINISTRATIVOS','EDUCACAO','AREA_PRODUTIVA','INVESTIMENTOS_SOCIAIS','PROGRAMAS_SOCIAIS'];

async function apiSaveKpi(kpi) {
  if (!isLiveMode()) return { ok: true, demo: true };

  // 1. Atualiza a tabela kpis (apenas colunas que existem nela)
  const dbKpi = {
    nome:          kpi.nome,
    descricao:     kpi.descricao || null,
    nome_completo: (kpi.codigo ? kpi.codigo + ' - ' : '') + kpi.nome,
  };
  // area só entra se for um valor válido do enum (evita quebrar o CHECK)
  if (AREAS_VALIDAS.includes(kpi.area)) dbKpi.area = kpi.area;

  const { error: e1 } = await _supa.from('kpis').update(dbKpi).eq('id', kpi.id);
  if (e1) throw e1;

  // 2. Sincroniza kpi_responsaveis com a lista de responsáveis editada
  const novosResp = kpi.responsaveis || [];
  const diretoria = kpi.diretoria || null;

  const { data: atuais, error: e2 } = await _supa
    .from('kpi_responsaveis')
    .select('id, responsavel, ativo')
    .eq('id_kpi', kpi.id);
  if (e2) throw e2;

  const atuaisMap = {};
  (atuais || []).forEach(r => { atuaisMap[r.responsavel] = r; });

  // Desativa responsáveis que saíram da lista
  for (const r of (atuais || [])) {
    if (r.ativo && !novosResp.includes(r.responsavel)) {
      const { error } = await _supa.from('kpi_responsaveis')
        .update({ ativo: false }).eq('id', r.id);
      if (error) throw error;
    }
  }

  // Insere novos / reativa existentes + atualiza diretoria de todos
  for (const nome of novosResp) {
    const existente = atuaisMap[nome];
    if (existente) {
      const { error } = await _supa.from('kpi_responsaveis')
        .update({ ativo: true, diretor: diretoria }).eq('id', existente.id);
      if (error) throw error;
    } else {
      const { error } = await _supa.from('kpi_responsaveis')
        .insert({ id_kpi: kpi.id, responsavel: nome, diretor: diretoria, ativo: true });
      if (error) throw error;
    }
  }

  // Atualiza cache local (kpi já é referência ao objeto em KPIS)
  const idx = DB.kpis.findIndex(k => k.id === kpi.id);
  if (idx >= 0) DB.kpis[idx] = { ...DB.kpis[idx], ...kpi };
  const ki = KPIS.findIndex(k => k.id === kpi.id);
  if (ki >= 0) Object.assign(KPIS[ki], kpi);
  return { ok: true };
}

// ── Gestão de usuários via Edge Function admin-users ──────────
// Toda a gestão de LOGIN (Supabase Auth) + perfil é feita por uma
// Edge Function server-side que usa a chave service_role e confere
// se quem chamou é administrador. O front NUNCA vê a chave admin.
const PERFIL_DB_MAP = { Admin:'administrador', DiretorN1:'diretoria_n1', Diretor:'diretor', Responsavel:'responsavel' };

async function invokeAdminUsers(action, payload) {
  const { data, error } = await _supa.functions.invoke('admin-users', { body: { action, payload } });
  if (error) {
    let msg = error.message || 'Falha na função admin-users';
    try {
      const body = await error.context?.json?.();   // erros retornam {error: "..."}
      if (body?.error) msg = body.error;
    } catch (_) { /* corpo não-JSON, mantém msg padrão */ }
    throw new Error(msg);
  }
  if (data && data.error) throw new Error(data.error);
  return data || { ok: true };
}

// ── apiSaveUser ───────────────────────────────────────────
// isNew: cria login JÁ CONFIRMADO + perfil.
// edição: atualiza perfil/e-mail/ativo e, se 'senha' vier, redefine a senha.
async function apiSaveUser({ email, nome, perfil, senha, ativo, isNew, currentEmail }) {
  if (!isLiveMode()) return { ok: true, demo: true };
  if (isNew) {
    return await invokeAdminUsers('create', { email, nome, perfil, senha, ativo });
  }
  return await invokeAdminUsers('update', {
    currentEmail: currentEmail || email, email, nome, perfil,
    senha: senha || undefined, ativo,
  });
}

// ── apiDeleteUser ─────────────────────────────────────────
// Remove o login (Auth) e o perfil. Se houver referências no banco,
// a função mantém o perfil inativo e devolve { note }.
async function apiDeleteUser(email) {
  if (!isLiveMode()) return { ok: true, demo: true };
  return await invokeAdminUsers('delete', { currentEmail: email });
}

// ── apiResetPassword ──────────────────────────────────────
async function apiResetPassword(email, senha) {
  if (!isLiveMode()) return { ok: true, demo: true };
  return await invokeAdminUsers('reset_password', { currentEmail: email, senha });
}

// ── apiSetUserActive ──────────────────────────────────────
async function apiSetUserActive(email, ativo) {
  if (!isLiveMode()) return { ok: true, demo: true };
  return await invokeAdminUsers('set_active', { currentEmail: email, ativo });
}

// ── apiSyncKpiAccess ──────────────────────────────────────
// Sincroniza tabela kpi_responsaveis para um usuário:
// adiciona KPIs selecionados, desativa os removidos.
async function apiSyncKpiAccess(nomeUsuario, selectedKpiIds, perfil) {
  if (!isLiveMode()) return { ok: true, demo: true };
  if (perfil !== 'Responsavel') return { ok: true }; // Admin/DiretorN1 não usam kpi_responsaveis

  const { data: atuais, error: e1 } = await _supa
    .from('kpi_responsaveis')
    .select('id, id_kpi, ativo')
    .eq('responsavel', nomeUsuario);
  if (e1) throw e1;

  const atuaisMap = {};
  for (const r of (atuais || [])) atuaisMap[r.id_kpi] = r;

  // Desativa KPIs que saíram
  for (const r of (atuais || [])) {
    if (r.ativo && !selectedKpiIds.includes(r.id_kpi)) {
      await _supa.from('kpi_responsaveis').update({ ativo: false }).eq('id', r.id);
    }
  }
  // Insere/reativa KPIs selecionados
  for (const kpiId of selectedKpiIds) {
    const kpi = (DB.kpis || KPIS).find(k => k.id === kpiId);
    const diretoria = kpi?.diretoria || null;
    const existente = atuaisMap[kpiId];
    if (existente) {
      await _supa.from('kpi_responsaveis').update({ ativo: true, diretor: diretoria }).eq('id', existente.id);
    } else {
      await _supa.from('kpi_responsaveis').insert({ id_kpi: kpiId, responsavel: nomeUsuario, diretor: diretoria, ativo: true });
    }
  }
  // Atualiza cache local
  for (const k of KPIS) {
    const had = (k.responsaveis || []).includes(nomeUsuario);
    const wants = selectedKpiIds.includes(k.id);
    if (wants && !had)  k.responsaveis = [...(k.responsaveis||[]), nomeUsuario];
    if (!wants && had)  k.responsaveis = (k.responsaveis||[]).filter(r => r !== nomeUsuario);
  }
  return { ok: true };
}

// ── Comentários do KPI (mural Controladoria ↔ Gestor) ─────────
// Carrega os comentários de um KPI (ordenados do mais antigo ao mais novo).
// Tolerante: se a tabela ainda não existe (migração não rodada), devolve [].
async function apiLoadComentarios(idKpi) {
  if (!isLiveMode()) {
    return (DB.comentarios || []).filter(c => c.id_kpi === idKpi);
  }
  const { data, error } = await _supa
    .from('kpi_comentarios')
    .select('*')
    .eq('id_kpi', idKpi)
    .order('criado_em', { ascending: true });
  if (error) { console.warn('apiLoadComentarios:', error.message); return []; }
  return data || [];
}

// Insere um comentário. Retorna a linha persistida (com id/criado_em do banco).
async function apiAddComentario(payload) {
  if (!isLiveMode()) {
    const row = { ...payload, id: uid('c'), criado_em: new Date().toISOString() };
    DB.comentarios.push(row);
    return row;
  }
  const dbPayload = {
    id_kpi:      payload.id_kpi,
    autor_nome:  payload.autor_nome || '',
    autor_email: payload.autor_email || '',
    autor_papel: payload.autor_papel || 'Gestor',
    texto:       payload.texto || '',
  };
  const { data, error } = await _supa
    .from('kpi_comentarios')
    .insert(dbPayload)
    .select()
    .single();
  if (error) throw error;
  return data;
}

// ── apiAddLog ─────────────────────────────────────────────────
// Traduz payload interno (engine.js) para o schema de logs_auditoria
async function apiAddLog(payload) {
  if (!isLiveMode()) return { ok: true, demo: true };
  try {
    await _supa.from('logs_auditoria').insert({
      // id é BIGSERIAL — não passar
      data_hora:      new Date().toISOString(),
      nome_usuario:   payload.usuario     || '',
      acao:           payload.acao        || '',
      tabela_afetada: payload.tabela      || '',
      id_registro:    payload.id_registro || '',
      campo_alterado: payload.campo       || '',
      valor_anterior: String(payload.antes  ?? ''),
      valor_novo:     String(payload.depois ?? ''),
    });
  } catch (e) {
    console.warn('apiAddLog falhou silenciosamente:', e);
  }
}
