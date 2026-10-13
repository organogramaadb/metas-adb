// ===================================================================
// engine.js — Cálculos, formatação, autenticação e permissões
// ===================================================================

// ── Sessão ────────────────────────────────────────────────────────
let SESSION = null;

// Filtro de período (quadrimestre/semestre). Janela de meses inclusiva usada em toda a
// apuração; {from:1,to:12} = acumulado do ano. Alterado pelo seletor global (app.js).
let PERIODO_FILTRO = { from: 1, to: 12 };

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

// Ícone de exibição — classes Font Awesome (padrão de ícones do DS ADB).
const AREA_ICONS = {
  'ORGANIZACIONAL':        'fa-star',
  'ADMINISTRATIVOS':       'fa-building',
  'EDUCACAO':              'fa-graduation-cap',
  'AREA_PRODUTIVA':        'fa-wheat-awn',
  'INVESTIMENTOS_SOCIAIS': 'fa-hand-holding-dollar',
  'PROGRAMAS_SOCIAIS':     'fa-people-group',
};
function areaIcon(area) {
  return `<i class="fa-solid ${AREA_ICONS[area] || 'fa-location-dot'}" aria-hidden="true"></i>`;
}

// Exibe responsáveis do KPI; retorna 'A definir' para KPIs sem responsável definido
function kpiResps(kpi) {
  const arr = kpi.responsaveis || [];
  return arr.length ? arr.join(', ') : 'A definir';
}

// ── Permissões ────────────────────────────────────────────────────
function isAdmin()      { return SESSION && (SESSION.perfil === 'Admin'); }
function isDiretorN1()  { return SESSION && (SESSION.perfil === 'DiretorN1'); }
// Diretoria (N1 ou Diretor): visão de topo — para na "primeira linha" dos sintéticos.
function isDiretoria()  { return SESSION && (SESSION.perfil === 'DiretorN1' || SESSION.perfil === 'Diretor'); }
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
  // Acha o último mês com realizado DENTRO do período filtrado (quadrimestre/semestre/ano).
  const { from, to } = PERIODO_FILTRO;
  let ultimoMes = 0;
  for (const r of registros) {
    if (r.mes >= from && r.mes <= to &&
        r.valor_realizado !== null && r.valor_realizado !== undefined && r.valor_realizado !== '') {
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
      if (r.mes >= PERIODO_FILTRO.from && r.mes <= ultimoMes) {
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

  // Pontuação (contribuição) = peso × atingimento, linear e SEM teto (reforma da malha, out/2026).
  // A régua antiga (travava em 100%, zerava abaixo de 90%) foi removida: 140% contribui 1,40×peso.
  const pontuacao = (scoringAt !== null) ? meta.peso * scoringAt : 0;

  return { metaAc, realAc, atingimento, scoringAt, pontuacao, ultimoMes, registros };
}

/**
 * Consolida uma frente (card) na malha de 3 níveis:
 *   CARD → SINTÉTICO (bucket temático) → ANALÍTICO (indicador).
 * atingimento do bucket = média ponderada (renormalizada) dos analíticos COM dado;
 * atingimento do card   = média ponderada (renormalizada) dos buckets COM dado.
 * cobertura = fração do peso que de fato tem lançamento (selo de completude).
 *
 * Retorna: { totalPontuacao, cobertura, resultados[], sinteticos[], ultimoMes }
 *   totalPontuacao — atingimento do card (pode passar de 1 = 100%, sem teto)
 *   cobertura      — 0..1, quanto do peso do card já tem dado lançado
 *   resultados[]   — analíticos achatados { meta, ...calcMeta } (compat. tela de detalhe atual)
 *   sinteticos[]   — [{ sint, atingimento, cobertura, filhos[], ultimoMes }] (p/ a UI de buckets, Fase B)
 * Card sem nível SINTÉTICO (legado/plano) cai no mesmo cálculo tratando o card como bucket único.
 */
function calcKPI(kpiId, ano) {
  const todas = DB.metas.filter(m => m.id_kpi === kpiId && m.ativo);
  const sints = todas.filter(m => m.nivel === 'SINTETICO');

  // Média ponderada renormalizada entre os filhos COM dado (scoringAt !== null).
  const rollup = (filhos) => {
    const comDado = filhos.filter(r => r.scoringAt !== null);
    const num     = comDado.reduce((a, r) => a + r.peso * r.scoringAt, 0);
    const den     = comDado.reduce((a, r) => a + r.peso, 0);
    const pesoAll = filhos.reduce((a, r) => a + r.peso, 0);
    return { atingimento: den > 0 ? num / den : null, cobertura: pesoAll > 0 ? den / pesoAll : 0 };
  };

  // Caso legado/plano: sem sintéticos, os analíticos penduram direto no card.
  if (sints.length === 0) {
    const resultados = todas.map(m => ({ meta: m, ...calcMeta(m, ano) }));
    const { atingimento, cobertura } = rollup(resultados.map(r => ({ scoringAt: r.scoringAt, peso: r.meta.peso })));
    const ultimoMes = Math.max(0, ...resultados.map(r => r.ultimoMes));
    return { totalPontuacao: atingimento || 0, cobertura, resultados, sinteticos: [], ultimoMes };
  }

  // Malha de 3 níveis.
  const sinteticos = sints.map(s => {
    const filhos = todas
      .filter(m => m.nivel === 'ANALITICO' && m.id_pai === s.id)
      .map(m => ({ meta: m, ...calcMeta(m, ano) }));
    const { atingimento, cobertura } = rollup(filhos.map(r => ({ scoringAt: r.scoringAt, peso: r.meta.peso })));
    const ultimoMes = Math.max(0, ...filhos.map(r => r.ultimoMes));
    return { sint: s, atingimento, cobertura, filhos, ultimoMes };
  });

  const card = rollup(sinteticos.map(s => ({ scoringAt: s.atingimento, peso: s.sint.peso })));
  // Cobertura do card: pondera a cobertura de cada bucket pelo peso do sintético (vê buckets parciais).
  const pesoAllS = sinteticos.reduce((a, s) => a + s.sint.peso, 0);
  const coberturaCard = pesoAllS > 0
    ? sinteticos.reduce((a, s) => a + s.sint.peso * s.cobertura, 0) / pesoAllS
    : 0;

  const resultados = sinteticos.flatMap(s => s.filhos);   // compat. com a tela de detalhe atual
  const ultimoMes  = Math.max(0, ...sinteticos.map(s => s.ultimoMes));
  return { totalPontuacao: card.atingimento || 0, cobertura: coberturaCard, resultados, sinteticos, ultimoMes };
}

// Reaplica a mesma lógica de scoringAt do calcMeta, mas cortando os meses em
// `cutoffMes` em vez de detectar o último mês automaticamente — usado só pra
// comparar tendência (mês atual vs anterior), nunca pro cálculo oficial do KPI.
// Retorna null quando não dá pra "voltar no tempo": meta em modo manual (valor
// acumulado único, sem série mensal) ou sem nenhum dado até o cutoff.
function calcMetaScoringAtCutoff(meta, ano, cutoffMes) {
  if (cutoffMes <= 0) return null;
  if ((meta.tipo_acumulado || 'soma') === 'manual') return null;
  const acumulado = meta.tipo_acumulado || 'soma';
  const registros = DB.metasMensais.filter(m => m.id_meta === meta.id && m.ano === ano);
  let metaSum = 0, realSum = 0, nMeta = 0, nReal = 0;
  for (const r of registros) {
    if (r.mes < PERIODO_FILTRO.from || r.mes > cutoffMes) continue;
    const vm = (r.valor_meta      != null && r.valor_meta      !== '') ? parseFloat(r.valor_meta)      : null;
    const vr = (r.valor_realizado != null && r.valor_realizado !== '') ? parseFloat(r.valor_realizado) : null;
    if (vm !== null) { metaSum += vm; nMeta++; }
    if (vr !== null) { realSum += vr; nReal++; }
  }
  if (nMeta === 0 && nReal === 0) return null; // sem nenhum lançamento até esse mês
  const metaAc = acumulado === 'media' ? (nMeta > 0 ? metaSum / nMeta : 0) : metaSum;
  const realAc = acumulado === 'media' ? (nReal > 0 ? realSum / nReal : 0) : realSum;
  if (metaAc === 0 && realAc === 0) return 1;
  if (metaAc === 0 || realAc === 0) return null;
  return meta.bom_quando === 'maior' ? realAc / metaAc : metaAc / realAc;
}

/**
 * Tendência do KPI: compara a pontuação total no último mês apurado contra o
 * mês anterior. Retorna 'alta' | 'estavel' | 'baixa', ou null quando não dá
 * pra comparar (só 1 mês de histórico, ou nenhuma meta comparável — ex.: só
 * metas em modo manual).
 */
// Reaplica o rollup de 3 níveis cortando os meses em `cutoff` (usa calcMetaScoringAtCutoff
// por analítico). Retorna o atingimento do card até aquele mês, ou null se não dá pra comparar.
function calcCardAtingimentoAtCutoff(kpiId, ano, cutoff) {
  const todas = DB.metas.filter(m => m.id_kpi === kpiId && m.ativo);
  const sints = todas.filter(m => m.nivel === 'SINTETICO');
  const roll = (filhos) => {
    let num = 0, den = 0;
    for (const f of filhos) {
      const a = calcMetaScoringAtCutoff(f, ano, cutoff);
      if (a != null) { num += f.peso * a; den += f.peso; }
    }
    return den > 0 ? num / den : null;
  };
  if (sints.length === 0) return roll(todas);
  let num = 0, den = 0;
  for (const s of sints) {
    const atB = roll(todas.filter(m => m.nivel === 'ANALITICO' && m.id_pai === s.id));
    if (atB != null) { num += s.peso * atB; den += s.peso; }
  }
  return den > 0 ? num / den : null;
}

function calcKPITrend(kpiId, ano) {
  const { totalPontuacao, ultimoMes } = calcKPI(kpiId, ano);
  if (ultimoMes <= 1) return null;
  const prev = calcCardAtingimentoAtCutoff(kpiId, ano, ultimoMes - 1);
  if (prev == null) return null;
  const delta = totalPontuacao - prev;
  if (Math.abs(delta) < 0.005) return 'estavel'; // variação < 0,5 p.p. — não vale destacar
  return delta > 0 ? 'alta' : 'baixa';
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
