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

// ── Mapeamento de área para exibição ─────────────────────────────────
const AREA_LABELS = {
  'ADMINISTRATIVOS':       'Administração',
  'EDUCACAO':              'Educação',
  'AREA_PRODUTIVA':        'Área Produtiva',
  'INVESTIMENTOS_SOCIAIS': 'Investimentos Sociais',
  'PROGRAMAS_SOCIAIS':     'Programas Sociais',
};

function areaLabel(area) {
  return AREA_LABELS[area] || area;
}

// Exibe responsáveis do KPI; retorna 'A definir' para KPIs sem responsável definido
function kpiResps(kpi) {
  const arr = kpi.responsaveis || [];
  return arr.length ? arr.join(', ') : 'A definir';
}

// ── Permissões ────────────────────────────────────────────────────
function isAdmin()      { return SESSION && (SESSION.perfil === 'Admin'); }
function isDiretorN1()  { return SESSION && (SESSION.perfil === 'DiretorN1'); }
function canSeeAll()    { return isAdmin() || isDiretorN1(); }

function canSeeKPI(kpi) {
  if (!SESSION) return false;
  if (canSeeAll()) return true;
  // Responsável vê KPIs onde seu nome aparece no array responsaveis
  return (kpi.responsaveis || []).includes(SESSION.responsavel);
}

function canEditMeta(meta) {
  if (!SESSION) return false;
  if (isAdmin()) return true;
  if (meta.responsavel === SESSION.responsavel) return true;
  // Co-responsável do KPI também pode editar as metas do KPI
  const kpi = (DB.kpis || KPIS).find(k => k.id === meta.id_kpi);
  return !!(kpi && (kpi.responsaveis || []).includes(SESSION.responsavel));
}

function canEditProject(proj) {
  if (!SESSION) return false;
  if (isAdmin()) return true;
  if (proj.responsavel === SESSION.responsavel) return true;
  // Co-responsável do KPI também pode editar os projetos do KPI
  const kpi = (DB.kpis || KPIS).find(k => k.id === proj.id_kpi);
  return !!(kpi && (kpi.responsaveis || []).includes(SESSION.responsavel));
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
    case 'monetario':
    case 'moeda':
      return 'R$ ' + Math.abs(n).toLocaleString('pt-BR', { minimumFractionDigits:2, maximumFractionDigits:2 });
    case 'percentual':
      return (n * 100).toLocaleString('pt-BR', { minimumFractionDigits:1, maximumFractionDigits:1 }) + '%';
    case 'decimal':
      return n.toLocaleString('pt-BR', { minimumFractionDigits:2, maximumFractionDigits:2 });
    case 'inteiro':
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
 *
 * Campos da meta usados:
 *   tipo_acumulado      — 'soma' (padrão) | 'media'
 *     soma  → acumula todos os meses até ultimoMes (bom para volumes, despesas totais)
 *     media → média dos meses (bom para percentuais, valores unitários)
 *
 *   formula_atingimento — 'real_sobre_meta' (padrão) | 'meta_sobre_real'
 *     Define SOMENTE o valor exibido (atingimento).
 *     A pontuação e a cor sempre usam bom_quando (scoringAt).
 *
 * Retorna: { metaAc, realAc, atingimento, scoringAt, pontuacao, ultimoMes, registros }
 *   atingimento — valor para exibição (segue formula_atingimento)
 *   scoringAt   — valor para cor/pontuação (>=1 = bom, baseado em bom_quando)
 */
function calcMeta(meta, ano) {
  const { registros, ultimoMes } = getMesesComRealizado(meta.id, ano);

  if (ultimoMes === 0) {
    return { metaAc: null, realAc: null, atingimento: null, scoringAt: null, pontuacao: 0, ultimoMes: 0, registros };
  }

  const formula   = meta.formula_atingimento || 'real_sobre_meta';
  const acumulado = meta.tipo_acumulado      || 'soma';

  let metaSum = 0, realSum = 0, nMeta = 0, nReal = 0;
  for (const r of registros) {
    if (r.mes <= ultimoMes) {
      const vm = (r.valor_meta      != null && r.valor_meta      !== '') ? parseFloat(r.valor_meta)      : null;
      const vr = (r.valor_realizado != null && r.valor_realizado !== '') ? parseFloat(r.valor_realizado) : null;
      if (vm !== null) { metaSum += vm; nMeta++; }
      if (vr !== null) { realSum += vr; nReal++; }
    }
  }

  // Aplica acumulado: soma mantém o total; média divide pelo nº de meses com valor
  const metaAc = acumulado === 'media' ? (nMeta > 0 ? metaSum / nMeta : 0) : metaSum;
  const realAc = acumulado === 'media' ? (nReal > 0 ? realSum / nReal : 0) : realSum;

  // Atingimento para EXIBIÇÃO (fórmula configurável)
  let atingimento = null;
  // Atingimento para COR / PONTUAÇÃO (sempre: bom_quando=Maior → real/meta; Menor → meta/real; >=1 = bom)
  let scoringAt   = null;

  if (metaAc !== 0 && realAc !== 0) {
    atingimento = formula === 'real_sobre_meta' ? realAc / metaAc : metaAc / realAc;
    scoringAt   = meta.bom_quando === 'maior'   ? realAc / metaAc : metaAc / realAc;
  } else if (metaAc === 0 && realAc === 0) {
    atingimento = 1;
    scoringAt   = 1;
  }

  // Pontuação ponderada usa scoringAt (≥100% = full, 90-100% = linear, <90% = 0)
  let pontuacao = 0;
  if (scoringAt !== null) {
    if (scoringAt >= 1.0) {
      pontuacao = meta.peso;
    } else if (scoringAt >= 0.9) {
      pontuacao = meta.peso * ((scoringAt - 0.9) / 0.1);
    }
  }

  return { metaAc, realAc, atingimento, scoringAt, pontuacao, ultimoMes, registros };
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
