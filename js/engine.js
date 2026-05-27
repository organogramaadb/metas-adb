// ===================================================================
// engine.js — Cálculos, formatação, autenticação e permissões
// ===================================================================

// ── Sessão ────────────────────────────────────────────────────────
let SESSION = null;

function login(email, senha) {
  const u = USUARIOS.find(x => x.email.toLowerCase() === email.toLowerCase() && x.senha === senha && x.ativo);
  if (!u) return null;
  SESSION = { ...u, loginAt: new Date().toISOString() };
  return SESSION;
}

function logout() { SESSION = null; }

// ── Permissões ────────────────────────────────────────────────────
function isAdmin()      { return SESSION && (SESSION.perfil === 'Admin'); }
function isDiretorN1()  { return SESSION && (SESSION.perfil === 'DiretorN1'); }
function canSeeAll()    { return isAdmin() || isDiretorN1(); }

function canSeeKPI(kpi) {
  if (!SESSION) return false;
  if (canSeeAll()) return true;
  // Responsável vê KPIs onde seu nome está como responsável
  return kpi.responsavel === SESSION.responsavel;
}

function canEditMeta(meta) {
  if (!SESSION) return false;
  if (isAdmin()) return true;
  return meta.responsavel === SESSION.responsavel;
}

function canEditProject(proj) {
  if (!SESSION) return false;
  if (isAdmin()) return true;
  return proj.responsavel === SESSION.responsavel;
}

function allowedKPIs() {
  return KPIS.filter(k => k.ativo && canSeeKPI(k));
}

// ── Formatação de números ─────────────────────────────────────────
const MESES_ABREV = ['Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'];

function fmt(valor, tipo) {
  if (valor === null || valor === undefined || valor === '') return '—';
  const n = parseFloat(valor);
  if (isNaN(n)) return String(valor);
  switch (tipo) {
    case 'moeda':
      return 'R$ ' + Math.abs(n).toLocaleString('pt-BR', { minimumFractionDigits:2, maximumFractionDigits:2 });
    case 'percentual':
      return (n * 100).toLocaleString('pt-BR', { minimumFractionDigits:1, maximumFractionDigits:1 }) + '%';
    case 'decimal':
      return n.toLocaleString('pt-BR', { minimumFractionDigits:2, maximumFractionDigits:2 });
    case 'numero_inteiro':
      return Math.round(n).toLocaleString('pt-BR');
    default:
      return n.toLocaleString('pt-BR');
  }
}

function fmtPct(v) {
  if (v === null || v === undefined) return '—';
  return (v * 100).toLocaleString('pt-BR', { minimumFractionDigits:1, maximumFractionDigits:1 }) + '%';
}

function fmtPrazo(iso) {
  if (!iso) return '—';
  const [y, m, d] = iso.split('-');
  return `${d}/${m}/${y}`;
}

function parseInput(val, tipo) {
  // Converte string de input do usuário para número
  if (val === '' || val === null || val === undefined) return null;
  // Remove pontos de milhar, substitui vírgula por ponto
  const clean = String(val).replace(/\./g, '').replace(',', '.');
  const n = parseFloat(clean);
  return isNaN(n) ? null : n;
}

// ── Cálculos principais ───────────────────────────────────────────

/**
 * Retorna os registros mensais de uma meta para um dado ano,
 * de jan (1) até o último mês com realizado preenchido.
 */
function getMesesComRealizado(idMeta, ano) {
  const registros = DB.metasMensais.filter(m => m.id_meta === idMeta && m.ano === ano);
  // Ordena por mês
  registros.sort((a, b) => a.mes - b.mes);
  // Acha último mês com realizado
  let ultimoMes = 0;
  for (const r of registros) {
    if (r.valor_realizado !== null && r.valor_realizado !== undefined && r.valor_realizado !== '') {
      ultimoMes = r.mes;
    }
  }
  return { registros, ultimoMes };
}

/**
 * Calcula os acumulados e atingimento de uma meta.
 * Retorna: { metaAc, realAc, atingimento, pontuacao, ultimoMes, registros }
 */
function calcMeta(meta, ano) {
  const { registros, ultimoMes } = getMesesComRealizado(meta.id, ano);

  if (ultimoMes === 0) {
    return { metaAc: null, realAc: null, atingimento: null, pontuacao: 0, ultimoMes: 0, registros };
  }

  let metaAc = 0, realAc = 0;
  for (const r of registros) {
    if (r.mes <= ultimoMes) {
      metaAc += (r.valor_meta != null ? parseFloat(r.valor_meta) : 0);
      realAc += (r.valor_realizado != null ? parseFloat(r.valor_realizado) : 0);
    }
  }

  // Atingimento ajustado conforme "Bom quando"
  let atingimento = null;
  if (metaAc !== 0 && realAc !== 0) {
    if (meta.bom_quando === 'Maior') {
      atingimento = realAc / metaAc;           // >1 = bom
    } else {
      atingimento = metaAc / realAc;           // >1 = bom (gastou menos)
    }
  } else if (metaAc === 0 && realAc === 0) {
    atingimento = 1;
  }

  // Pontuação ponderada (regra parametrizável — aqui: ≥100% = full, 90-100% = linear, <90% = 0)
  let pontuacao = 0;
  if (atingimento !== null) {
    if (atingimento >= 1.0) {
      pontuacao = meta.peso;                              // full
    } else if (atingimento >= 0.9) {
      pontuacao = meta.peso * ((atingimento - 0.9) / 0.1); // 90-100% linear
    }
    // abaixo de 90%: 0
  }

  return { metaAc, realAc, atingimento, pontuacao, ultimoMes, registros };
}

/**
 * Calcula o consolidado de um KPI (soma das pontuações ponderadas).
 * Retorna: { totalPontuacao, resultados[], ultimoMes }
 */
function calcKPI(kpiId, ano) {
  const metas = DB.metas.filter(m => m.id_kpi === kpiId && m.ativo);
  const resultados = metas.map(m => ({ meta: m, ...calcMeta(m, ano) }));
  const totalPontuacao = resultados.reduce((s, r) => s + r.pontuacao, 0);
  const ultimoMes = Math.max(0, ...resultados.map(r => r.ultimoMes));
  return { totalPontuacao, resultados, ultimoMes };
}

// ── Helpers de cor e status ───────────────────────────────────────
function scoreClass(pct) {
  // pct = 0..1 representando 0%..100%
  if (pct === null || pct === undefined) return '';
  if (pct >= 1.0)  return 'ok';
  if (pct >= 0.9)  return 'warn';
  return 'err';
}

function statusBadgeClass(status) {
  const map = {
    'Não iniciado': 'st-nao',
    'Em andamento':  'st-and',
    'Em atraso':     'st-atr',
    'Concluído':     'st-con',
    'Suspenso':      'st-sus',
    'Cancelado':     'st-can',
  };
  return map[status] || 'st-nao';
}

function prioBadgeClass(prio) {
  const map = { 'Alta':'pr-alta', 'Média':'pr-media', 'Baixa':'pr-baixa' };
  return map[prio] || 'pr-baixa';
}

// ── Log de auditoria ──────────────────────────────────────────────
function addLog(acao, tabela, idRegistro, campo, antes, depois) {
  const entry = {
    id: 'log-' + Date.now(),
    data_hora: new Date().toLocaleString('pt-BR'),
    usuario: SESSION ? SESSION.email : 'sistema',
    acao, tabela, id_registro: idRegistro,
    campo, antes: String(antes), depois: String(depois),
    obs: '',
  };
  DB.logs.unshift(entry);
}

// ── Gerador de IDs ────────────────────────────────────────────────
function uid(prefix) {
  return prefix + '-' + Date.now().toString(36) + Math.random().toString(36).slice(2, 6);
}
