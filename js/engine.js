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
  'ORGANIZACIONAL':        'Indicadores Organizacionais',
  'ADMINISTRATIVOS':       'Administração',
  'EDUCACAO':              'Educação',
  'AREA_PRODUTIVA':        'Área Produtiva',
  'INVESTIMENTOS_SOCIAIS': 'Investimentos Sociais',
  'PROGRAMAS_SOCIAIS':     'Programas Sociais',
};

function areaLabel(area) {
  return AREA_LABELS[area] || area;
}

// Ícone só de exibição — nenhuma dependência de biblioteca de ícones/SVG externo.
const AREA_ICONS = {
  'ORGANIZACIONAL':        '⭐',
  'ADMINISTRATIVOS':       '🏢',
  'EDUCACAO':              '🎓',
  'AREA_PRODUTIVA':        '🌾',
  'INVESTIMENTOS_SOCIAIS': '💰',
  'PROGRAMAS_SOCIAIS':     '🤝',
};
function areaIcon(area) {
  return AREA_ICONS[area] || '📌';
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
  // KPI Organizacional (0.00): exclusivo do Administrador
  if (kpi.area === 'ORGANIZACIONAL') return isAdmin();
  if (canSeeAll()) return true;
  // Responsável vê KPIs onde seu nome aparece no array responsaveis
  return (kpi.responsaveis || []).includes(SESSION.responsavel);
}

// Somente o Administrador altera qualquer dado do Quadro de KPI (metas e valores).
// Gestores e Diretoria N1 acessam as metas apenas como visualizadores (ver, ler),
// sem opção de alterar. A edição de Projetos permanece com os gestores (canEditProject).
function canEditMeta(meta) {
  if (!SESSION) return false;
  return isAdmin();
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
 *   tipo_acumulado      — 'soma' (padrão) | 'media' | 'manual'
 *     soma   → acumula todos os meses até ultimoMes (bom para volumes, despesas totais)
 *     media  → média dos meses (bom para percentuais, valores unitários)
 *     manual → usa acumulado_meta_manual/acumulado_realizado_manual direto,
 *              ignorando o somatório dos meses (para métricas que não dá pra
 *              derivar simplesmente somando/tirando média dos lançamentos mensais)
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
  const formula   = meta.formula_atingimento || 'real_sobre_meta';
  const acumulado = meta.tipo_acumulado      || 'soma';

  let metaAc, realAc;

  if (acumulado === 'manual') {
    // Entrada manual — bypassa o somatório mensal; ultimoMes/registros seguem
    // calculados normalmente só para os pontinhos de mês na tabela principal.
    metaAc = (meta.acumulado_meta_manual      != null && meta.acumulado_meta_manual      !== '') ? parseFloat(meta.acumulado_meta_manual)      : null;
    realAc = (meta.acumulado_realizado_manual != null && meta.acumulado_realizado_manual !== '') ? parseFloat(meta.acumulado_realizado_manual) : null;
  } else {
    if (ultimoMes === 0) {
      return { metaAc: null, realAc: null, atingimento: null, scoringAt: null, pontuacao: 0, ultimoMes: 0, registros };
    }
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
    metaAc = acumulado === 'media' ? (nMeta > 0 ? metaSum / nMeta : 0) : metaSum;
    realAc = acumulado === 'media' ? (nReal > 0 ? realSum / nReal : 0) : realSum;
  }

  if (metaAc == null || realAc == null) {
    return { metaAc, realAc, atingimento: null, scoringAt: null, pontuacao: 0, ultimoMes, registros };
  }

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

// ── Tarefas (Projetos e Iniciativas) — usado pelo dashboard e pela tela Tarefas
function isTaskOpen(status) {
  return status !== 'Concluído' && status !== 'Cancelado';
}
function prioWeight(prio) {
  const map = { 'Alta': 0, 'Média': 1, 'Baixa': 2 };
  return map[prio] ?? 3;
}
// Lista de projetos abertos e visíveis ao usuário logado, ordenada por
// prioridade (Alta primeiro) e depois por prazo mais próximo (sem prazo por último).
function openTasksFor(kpis) {
  const ids = new Set(kpis.map(k => k.id));
  const list = DB.projetos.filter(p => p.ativo && ids.has(p.id_kpi) && isTaskOpen(p.status));
  list.sort((a, b) => {
    const dp = prioWeight(a.prioridade) - prioWeight(b.prioridade);
    if (dp !== 0) return dp;
    return (a.prazo || '9999-99-99').localeCompare(b.prazo || '9999-99-99');
  });
  return list;
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
