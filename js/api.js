// ===================================================================
// api.js — Camada de persistência: demo (in-memory) ou GAS real
// ===================================================================
//
// Para ativar o backend real:
//   1. Publique Code.gs como Web App (Qualquer pessoa, Execute como: Eu)
//   2. Cole a URL abaixo em GAS_URL
//   3. Recarregue o app
//
// Enquanto GAS_URL estiver vazio, todas as operações permanecem
// em memória (comportamento de demonstração).
// ===================================================================

const GAS_URL = 'https://script.google.com/macros/s/AKfycbzbHgNavVdI-YRsZV63orQH7BeH3ggcCOhIZWHWT9g0ZGSMhmnaOkCW8-3ReuQB900fHw/exec';

// ── Modo de operação ──────────────────────────────────────────────
function isLiveMode() { return !!GAS_URL; }

// ── Chamada genérica ao GAS (POST) ───────────────────────────────
async function gasPost(action, payload) {
  if (!isLiveMode()) return { ok: true, demo: true };
  try {
    const resp = await fetch(GAS_URL, {
      method: 'POST',
      body: JSON.stringify({ action, payload }),
    });
    const data = await resp.json();
    if (data.error) throw new Error(data.error);
    return data;
  } catch (err) {
    console.error('[api] gasPost erro:', err);
    throw err;
  }
}

// ── Chamada genérica ao GAS (GET) ────────────────────────────────
async function gasGet(action) {
  if (!isLiveMode()) return null;
  try {
    const resp = await fetch(`${GAS_URL}?action=${action}`);
    const data = await resp.json();
    if (data.error) throw new Error(data.error);
    return data;
  } catch (err) {
    console.error('[api] gasGet erro:', err);
    throw err;
  }
}

// ── Carrega dados iniciais do GAS (substitui DB demo) ────────────
async function apiLoadInitData() {
  if (!isLiveMode()) return false;

  toast('Conectando ao banco de dados…', '');
  try {
    const data = await gasGet('getInitData');
    if (!data) return false;

    // Só substitui DB se o servidor devolver dados reais.
    // Enquanto as planilhas estiverem vazias, mantém os dados demo.
    if (data.metas?.length)        DB.metas        = data.metas;
    if (data.metasMensais?.length) DB.metasMensais = data.metasMensais;
    if (data.projetos?.length)     DB.projetos     = data.projetos;
    if (data.logs?.length)         DB.logs         = data.logs;
    // Merge kpis: atualiza entradas que o servidor conhece, mantém o resto do data.js
    if (data.kpis?.length) {
      data.kpis.forEach(sk => {
        const idx = KPIS.findIndex(k => k.id === sk.id);
        if (idx >= 0) Object.assign(KPIS[idx], sk);
        else KPIS.push(sk);
      });
    }

    const fonte = data.metas?.length ? 'servidor' : 'demo (planilha ainda vazia)';
    toast(`✅ Conectado — dados: ${fonte}`, data.metas?.length ? 'ok' : '');
    return true;
  } catch (err) {
    // GAS indisponível: continua com dados demo sem quebrar o app
    console.warn('[api] GAS indisponível, usando dados demo:', err.message);
    const badge = document.getElementById('mode-badge');
    if (badge) { badge.textContent = 'DEMO'; badge.classList.remove('live'); }
    return false;
  }
}

// ── Persiste um registro mensal ───────────────────────────────────
async function apiSaveMetaMensal(reg) {
  return gasPost('saveMetaMensal', reg);
}

// ── Persiste metadados de uma meta ───────────────────────────────
async function apiSaveMeta(meta) {
  return gasPost('saveMeta', meta);
}

// ── Persiste um projeto ───────────────────────────────────────────
async function apiSaveProject(proj) {
  return gasPost('saveProject', proj);
}

// ── Remove um projeto ─────────────────────────────────────────────
async function apiDeleteProject(id) {
  return gasPost('deleteProject', { id });
}

// ── Persiste cabeçalho de um KPI ─────────────────────────────────
async function apiSaveKpi(kpi) {
  return gasPost('saveKpi', kpi);
}

// ── Envia entrada de log ao servidor ─────────────────────────────
async function apiAddLog(entry) {
  return gasPost('addLog', entry);
}

// ── Inicialização: tenta carregar do servidor, senão usa demo ─────
async function apiInit() {
  const loaded = await apiLoadInitData();
  if (!loaded) {
    // Demo mode: DB já está populado pelo data.js
    const badge = document.getElementById('mode-badge');
    if (badge) badge.textContent = 'DEMO';
  }
}
