// ===================================================================
// app.js — Renderização, navegação, interações e inicialização
// ===================================================================

const ANO_ATUAL = 2026;
let currentKpiId = null;
let drawerMetaId = null;
let drawerKpiId = null;   // KPI do drawer aberto — usado pelo mural de comentários
let drawerCurrentTab = 'dados';
let editingProjId = null;
let currentView = 'index';   // 'index' | 'kpi' | 'users'
let editingUserEmail = null; // null = novo usuário

// ── Toast ─────────────────────────────────────────────────────────
let toastTimer;
function toast(msg, tipo = '') {
  const el = document.getElementById('toast');
  el.textContent = msg;
  el.className = 'on ' + tipo;
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => { el.className = ''; }, 3200);
}

// ── initApp — chamado por api.js após login bem-sucedido ──────────
function initApp() {
  const u = DB.usuario;
  document.getElementById('lo').style.display = 'none';
  document.getElementById('app').classList.add('on');
  const img = document.getElementById('hdr-logo');
  img.src = LOGO_B64;
  document.getElementById('hdr-uname').textContent = u.nome;
  const roleLabels = { 'Admin': 'Administrador', 'DiretorN1': 'Diretoria N1', 'Responsavel': 'Responsável' };
  document.getElementById('hdr-urole').textContent = roleLabels[u.perfil] || 'Responsável';
  document.getElementById('hdr-avatar').textContent = u.nome.charAt(0).toUpperCase();
  renderNav();
  initNavState();
  showIndex();
}

// ── Navegação ─────────────────────────────────────────────────────
function renderNav() {
  const kpis = allowedKPIs();
  // Agrupa por área
  const areas = {};
  for (const k of kpis) {
    if (!areas[k.area]) areas[k.area] = [];
    areas[k.area].push(k);
  }
  let html = '';
  for (const [area, list] of Object.entries(areas)) {
    const isOpen = true;
    html += `<div class="nav-area${isOpen?' open':''}">
      <div class="nav-area-hd" onclick="toggleArea(this)">
        <span>${areaLabel(area)}</span><span class="nav-area-arrow">▶</span>
      </div>
      <div class="nav-area-cnt">`;
    for (const k of list) {
      html += `<div class="nav-kpi${currentKpiId===k.id?' sel':''}" onclick="showKPI('${k.id}')">
        <span class="nav-kpi-code">${k.codigo}</span>
        <span class="nav-kpi-name">${k.nome.replace('KPI ','')}</span>
        <span class="nav-kpi-dot"></span>
      </div>`;
    }
    html += `</div></div>`;
  }
  if (isAdmin()) {
    html += `<div class="nav-admin-sep"></div>
      <div class="nav-kpi nav-admin-link${currentView==='users'?' sel':''}" onclick="showUsersAdmin()">
        <span class="nav-kpi-code" style="font-size:13px">⚙</span>
        <span class="nav-kpi-name">Gerenciar Acessos</span>
      </div>`;
  }
  document.getElementById('nav-inner').innerHTML = html;
}

function toggleArea(el) {
  el.parentElement.classList.toggle('open');
}

// ── Sidebar retrátil ──────────────────────────────────────────────
// Recolhe/expande o menu lateral. A preferência é lembrada por sessão
// no navegador (localStorage). No mobile o menu abre como painel sobreposto.
function toggleNav() {
  const app = document.getElementById('app');
  const collapsed = app.classList.toggle('nav-collapsed');
  try { localStorage.setItem('metasNavCollapsed', collapsed ? '1' : '0'); } catch (e) {}
}

function initNavState() {
  const app = document.getElementById('app');
  let pref = null;
  try { pref = localStorage.getItem('metasNavCollapsed'); } catch (e) {}
  // Sem preferência salva: recolhido no mobile, expandido no desktop
  if (pref === null) pref = window.innerWidth <= 900 ? '1' : '0';
  app.classList.toggle('nav-collapsed', pref === '1');
}

function highlightNav(kpiId) {
  document.querySelectorAll('.nav-kpi').forEach(el => el.classList.remove('sel'));
  const active = document.querySelector(`.nav-kpi[onclick*="${kpiId}"]`);
  if (active) active.classList.add('sel');
}

// ── View: Index ───────────────────────────────────────────────────
function showIndex() {
  currentKpiId = null;
  currentView = 'index';
  document.getElementById('view-kpi').classList.remove('on');
  document.getElementById('view-users').classList.remove('on');
  document.getElementById('view-index').classList.add('on');
  highlightNav(null);
  setBreadcrumb([{ label: 'Início' }]);

  const u = SESSION;
  document.getElementById('welcome-msg').textContent =
    canSeeAll() ? 'Painel de Metas Corporativas' : `Olá, ${u.nome.split(' ')[0]}`;
  document.getElementById('welcome-sub').textContent =
    canSeeAll() ? 'Visão consolidada de todos os KPIs.' : 'Seus KPIs e metas de responsabilidade.';

  const kpis = allowedKPIs();
  const areas = {};
  for (const k of kpis) {
    if (!areas[k.area]) areas[k.area] = [];
    areas[k.area].push(k);
  }

  let html = '';
  for (const [area, list] of Object.entries(areas)) {
    html += `<div class="index-area">
      <div class="index-area-title">${areaLabel(area)}</div>
      <div class="kpi-cards-grid">`;
    for (const k of list) {
      const { totalPontuacao, ultimoMes } = calcKPI(k.id, ANO_ATUAL);
      const cls = scoreClass(totalPontuacao);
      const pctDisplay = (totalPontuacao * 100).toFixed(1) + '%';
      const barWidth = Math.min(100, totalPontuacao * 100).toFixed(1);
      const periodo = ultimoMes > 0 ? `Até ${MESES_ABREV[ultimoMes-1]}/2026` : 'Sem realizado';
      html += `<div class="kpi-index-card" onclick="showKPI('${k.id}')">
        <div class="kic-code">${k.codigo}</div>
        <div class="kic-name">${k.nome}</div>
        <div class="kic-info">
          <div class="kic-resp">Resp.: <strong>${kpiResps(k)}</strong></div>
          <div>${k.diretoria}</div>
        </div>
        <div class="kic-score">
          <div class="kic-score-bar"><div class="kic-score-fill ${cls}" style="width:${barWidth}%"></div></div>
          <div class="kic-score-val ${cls}">${pctDisplay} ${periodo ? '· '+periodo : ''}</div>
        </div>
      </div>`;
    }
    html += `</div></div>`;
  }
  document.getElementById('index-areas').innerHTML = html;
}

// ── View: KPI Detail ──────────────────────────────────────────────
function showKPI(kpiId) {
  const kpi = KPIS.find(k => k.id === kpiId);
  if (!kpi || !canSeeKPI(kpi)) return;

  currentKpiId = kpiId;
  currentView = 'kpi';
  document.getElementById('view-index').classList.remove('on');
  document.getElementById('view-users').classList.remove('on');
  document.getElementById('view-kpi').classList.add('on');
  highlightNav(kpiId);
  setBreadcrumb([
    { label: 'Início', action: 'showIndex()' },
    { label: kpi.area, action: `showIndex()` },
    { label: kpi.codigo + ' · ' + kpi.nome.replace('KPI ','') },
  ]);

  // Cabeçalho
  document.getElementById('kpi-code-hd').textContent = kpi.codigo;
  document.getElementById('kpi-name-hd').textContent = kpi.nome;
  document.getElementById('kpi-resp-hd').textContent = kpiResps(kpi);
  document.getElementById('kpi-dir-hd').textContent  = kpi.diretoria;
  document.getElementById('kpi-area-hd').textContent = areaLabel(kpi.area);
  document.getElementById('btn-edit-kpi').style.display = isAdmin() ? '' : 'none';

  // Cabeçalho de impressão (usado só quando o usuário clica em "Imprimir Meta")
  document.getElementById('print-header-tit').textContent = `${kpi.codigo} · ${kpi.nome}`;
  document.getElementById('print-header-meta').textContent =
    `Responsável: ${kpiResps(kpi)} · Diretoria: ${kpi.diretoria} · Gerado em ${new Date().toLocaleDateString('pt-BR')}`;

  const { totalPontuacao, resultados, ultimoMes } = calcKPI(kpiId, ANO_ATUAL);
  document.getElementById('kpi-periodo-hd').textContent =
    ultimoMes > 0 ? `Jan – ${MESES_ABREV[ultimoMes-1]} 2026 (acumulado)` : 'Jan – Dez 2026';

  // Cards superiores
  renderCards(totalPontuacao, resultados, ultimoMes);

  // Tabela de metas
  renderMetasTable(resultados, kpi);

  // Projetos
  renderProjTable(kpiId, kpi);
}

// ── Cards ─────────────────────────────────────────────────────────
function renderCards(totalPontuacao, resultados, ultimoMes) {
  const cls = scoreClass(totalPontuacao);
  const pctDisplay = (totalPontuacao * 100).toFixed(1) + '%';
  const barW = Math.min(100, totalPontuacao * 100).toFixed(1);
  const periodo = ultimoMes > 0 ? `Acum. até ${MESES_ABREV[ultimoMes-1]}/2026` : 'Sem realizado apurado';

  let html = `<div class="card-total">
    <div class="ct-label">Pontuação Total do KPI</div>
    <div class="ct-pct">${pctDisplay}</div>
    <div class="ct-sub">${periodo}</div>
    <div class="ct-bar"><div class="ct-bar-fill" style="width:${barW}%"></div></div>
  </div>`;

  for (const r of resultados) {
    const at = r.atingimento;
    const cls2 = scoreClass(r.scoringAt);
    const atDisplay = at !== null ? fmtPct(at) : '—';
    const barW2 = r.scoringAt !== null ? Math.min(100, r.scoringAt * 100).toFixed(1) : 0;
    const pts = (r.pontuacao * 100).toFixed(1) + '%';
    html += `<div class="card-meta" onclick="openDrawer('${r.meta.id}')">
      <div class="cm-num">Meta ${r.meta.seq}</div>
      <div class="cm-name">${r.meta.nome}</div>
      <div class="cm-pct ${cls2}">${atDisplay}</div>
      <div class="cm-bar"><div class="cm-bar-fill ${cls2}" style="width:${barW2}%"></div></div>
      <div class="cm-foot">
        <span>Peso: ${(r.meta.peso * 100).toFixed(0)}%</span>
        <span>${r.meta.bom_quando === 'maior' ? '↑ Maior' : '↓ Menor'}</span>
      </div>
      <div class="cm-pts">Pts: ${pts}</div>
    </div>`;
  }

  document.getElementById('kpi-cards-row').innerHTML = html;
  document.getElementById('metas-periodo-sub').textContent =
    ultimoMes > 0 ? `Acumulado Jan – ${MESES_ABREV[ultimoMes-1]}/2026` : 'Sem realizado apurado';
}

// ── Tabela de Metas ───────────────────────────────────────────────
function renderMetasTable(resultados, kpi) {
  // Somente o Administrador edita as metas do quadro de KPI.
  const canEdit = isAdmin();

  // Botões de seção
  document.getElementById('sec-btns-metas').innerHTML = canEdit
    ? `<button class="sec-btn" onclick="openDrawer(null,'${kpi.id}')">+ Nova Meta</button>`
    : '';

  if (!resultados.length) {
    document.getElementById('metas-tbody').innerHTML =
      '<tr><td colspan="10"><div class="empty-state"><div class="empty-state-icon">📊</div><div class="empty-state-t">Nenhuma meta cadastrada</div></div></td></tr>';
    return;
  }

  let rows = '';
  for (const r of resultados) {
    const m = r.meta;
    const at = r.atingimento;
    const cls = scoreClass(r.scoringAt);
    const atDisplay = at !== null ? fmtPct(at) : '—';
    const metaFmt = r.metaAc !== null ? fmt(r.metaAc, m.tipo_formato) : '—';
    const realFmt = r.realAc !== null ? fmt(r.realAc, m.tipo_formato) : '—';
    const pts = (r.pontuacao * 100).toFixed(1) + '%';
    const bomHtml = m.bom_quando === 'maior'
      ? `<span class="bom-badge bom-maior">↑ Maior</span>`
      : `<span class="bom-badge bom-menor">↓ Menor</span>`;

    // Dots mensais
    const { registros } = getMesesComRealizado(m.id, ANO_ATUAL);
    const regMap = {};
    for (const reg of registros) regMap[reg.mes] = reg;
    let dots = '<div class="month-dots">';
    for (let mes = 1; mes <= 12; mes++) {
      const reg = regMap[mes];
      let dotCls = 'mdot';
      let title = MESES_ABREV[mes-1];
      if (!reg || reg.valor_meta == null) {
        dotCls += '';
      } else if (reg.valor_realizado != null) {
        dotCls += ' real';
        title += `: ${fmt(reg.valor_realizado, m.tipo_formato)}`;
      } else {
        dotCls += ' meta';
      }
      dots += `<span class="${dotCls}" title="${title}"></span>`;
    }
    dots += '</div>';

    const editBtn = canEdit
      ? `<button class="tbl-btn" onclick="openDrawer('${m.id}')">Editar</button>`
      : `<button class="tbl-btn" onclick="openDrawer('${m.id}')">Ver</button>`;

    rows += `<tr>
      <td class="tbl-c" style="color:#bbb;font-weight:700">${m.seq}</td>
      <td>
        <div class="tbl-meta-name">${m.nome}</div>
        <div class="tbl-meta-desc">${m.descricao}</div>
      </td>
      <td class="tbl-c">${bomHtml}</td>
      <td class="tbl-peso">${(m.peso * 100).toFixed(0)}%</td>
      <td class="tbl-r">${metaFmt}</td>
      <td class="tbl-r">${realFmt}</td>
      <td class="tbl-pct ${cls}">${atDisplay}</td>
      <td class="tbl-pts">${pts}</td>
      <td>${dots}</td>
      <td class="tbl-c">${editBtn}</td>
    </tr>`;
  }

  // Totalizador da coluna Peso — mostra rápido se a distribuição bate 100%
  // (sem travar nada aqui; a trava de verdade fica no campo do drawer)
  const totalPeso = resultados.reduce((s, r) => s + (parseFloat(r.meta.peso) || 0), 0);
  const pesoOk = Math.abs(totalPeso - 1) < 0.001;
  rows += `<tr class="tbl-total-row">
    <td colspan="3" class="tbl-total-label">Total de Peso das Metas</td>
    <td class="tbl-peso tbl-peso-total ${pesoOk ? 'ok' : 'err'}">${(totalPeso * 100).toFixed(0)}%</td>
    <td colspan="6"></td>
  </tr>`;

  document.getElementById('metas-tbody').innerHTML = rows;
}

// ── Tabela de Projetos ────────────────────────────────────────────
function renderProjTable(kpiId, kpi) {
  const canEdit = isAdmin() || (kpi.responsaveis||[]).includes(SESSION.responsavel);
  document.getElementById('sec-btns-proj').innerHTML = canEdit
    ? `<button class="sec-btn primary" onclick="openProjModal(null,'${kpiId}')">+ Novo Projeto</button>`
    : '';

  const projs = DB.projetos.filter(p => p.id_kpi === kpiId && p.ativo);
  if (!projs.length) {
    document.getElementById('proj-tbody').innerHTML =
      '<tr><td colspan="8"><div class="empty-state"><div class="empty-state-icon">📋</div><div class="empty-state-t">Nenhum projeto cadastrado</div></div></td></tr>';
    return;
  }

  let rows = '';
  for (const p of projs) {
    const metaVinc = DB.metas.find(m => m.id === p.id_meta);
    const stCls = statusBadgeClass(p.status);
    const prCls = prioBadgeClass(p.prioridade);
    const actionBtns = canEdit
      ? `<button class="tbl-btn" onclick="openProjModal('${p.id}')">Editar</button>
         <button class="tbl-btn-del" onclick="deleteProject('${p.id}')" title="Excluir projeto">🗑️</button>`
      : '';
    rows += `<tr>
      <td>
        <div class="proj-name">${p.nome}</div>
        <div class="proj-meta-link">${p.responsavel}</div>
      </td>
      <td style="font-size:11px;color:#888">${metaVinc ? `Meta ${metaVinc.seq} · ${metaVinc.nome}` : '—'}</td>
      <td class="tbl-c"><span class="status-badge ${stCls}">${p.status}</span></td>
      <td class="tbl-c"><span class="prio-badge ${prCls}">${p.prioridade}</span></td>
      <td class="tbl-c" style="font-size:11px;white-space:nowrap">${fmtPrazo(p.prazo)}</td>
      <td>
        <div class="prog-wrap">
          <div class="prog-val">${p.percentual_evolucao}%</div>
          <div class="prog-bar"><div class="prog-fill" style="width:${p.percentual_evolucao}%"></div></div>
        </div>
      </td>
      <td style="font-size:11px;max-width:200px">${p.proxima_acao || '—'}</td>
      <td class="tbl-c" style="white-space:nowrap">${actionBtns}</td>
    </tr>`;
  }
  document.getElementById('proj-tbody').innerHTML = rows;
}

// ── Drawer de Edição de Meta ──────────────────────────────────────
function openDrawer(metaId, kpiId) {
  let meta = metaId ? DB.metas.find(m => m.id === metaId) : null;

  if (!meta) {
    // Nova meta — cria objeto em memória e 12 registros mensais vazios
    if (!kpiId) return;
    const kpi = KPIS.find(k => k.id === kpiId);
    if (!kpi) return;
    const existingMetasKpi = DB.metas.filter(m => m.id_kpi === kpiId && m.ativo);
    const existingSeqs = existingMetasKpi.map(m => m.seq);
    const nextSeq = existingSeqs.length ? Math.max(...existingSeqs) + 1 : 1;
    // Sugestão de peso padrão: 1 ÷ quantidade de metas do KPI (incluindo esta nova).
    // Fica editável — é só ponto de partida, não trava nada na criação.
    const pesoSugerido = Math.round((1 / (existingMetasKpi.length + 1)) * 100) / 100;
    // Gera UUID válido para o banco (crypto.randomUUID disponível em browsers modernos)
    const newId = (typeof crypto !== 'undefined' && crypto.randomUUID)
      ? crypto.randomUUID()
      : 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, c => {
          const r = Math.random() * 16 | 0;
          return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16);
        });
    meta = {
      id: newId, id_kpi: kpiId, seq: nextSeq,
      nome: '', descricao: '', responsavel: (kpi.responsaveis||[])[0] || '',
      diretoria: kpi.diretoria || '', tipo_formato: 'percentual',
      unidade_medida: '%', bom_quando: 'maior', peso: pesoSugerido,
      formula_atingimento: 'real_sobre_meta', tipo_acumulado: 'soma',
      acumulado_meta_manual: null, acumulado_realizado_manual: null,
      status: 'Ativa', obs: '', ult_at: new Date().toLocaleDateString('pt-BR'), ativo: true,
      _isNew: true
    };
    DB.metas.push(meta);
    for (let mes = 1; mes <= 12; mes++) {
      DB.metasMensais.push({
        id: `mm-${newId}-${mes}`, id_meta: newId, ano: ANO_ATUAL,
        mes, valor_meta: null, valor_realizado: null, obs: ''
      });
    }
  }

  drawerMetaId = meta.id;
  document.getElementById('drw-title').textContent = meta._isNew ? 'Nova Meta' : 'Editar Meta';
  document.getElementById('drw-sub').textContent = meta._isNew
    ? `${meta.codigo_kpi} · Meta ${meta.seq} (nova)`
    : `${meta.codigo_kpi} · Meta ${meta.seq}`;
  document.getElementById('drw-nome').value    = meta.nome;
  document.getElementById('drw-resp').value    = meta.responsavel;
  document.getElementById('drw-desc').value    = meta.descricao || '';
  document.getElementById('drw-formato').value   = meta.tipo_formato;
  document.getElementById('drw-bom').value       = meta.bom_quando;
  document.getElementById('drw-formula').value   = meta.formula_atingimento || 'real_sobre_meta';
  document.getElementById('drw-acumulado').value = meta.tipo_acumulado      || 'soma';
  document.getElementById('drw-peso').value      = meta.peso;
  document.getElementById('drw-status').value  = meta.status || 'Ativa';
  document.getElementById('drw-obs').value     = meta.obs || '';
  document.getElementById('drw-ult-at').value  = meta.ult_at || '—';

  buildMonthGrids(meta);
  // Sempre força a aba "Dados da Meta" como ativa ao abrir — sem passar um botão
  // "atual", que poderia sobrar marcado de uma sessão anterior do drawer (era a
  // causa do destaque aparecer em "Realizado Mensal" com o conteúdo errado).
  switchDrawerTab('dados');

  // Botão excluir: só para meta existente (não nova) e com permissão de edição
  const delBtn = document.getElementById('btn-meta-delete');
  if (delBtn) delBtn.style.display = (!meta._isNew && canEditMeta(meta)) ? '' : 'none';

  // Modo somente-leitura para quem não é Administrador (gestores/diretoria)
  applyDrawerReadOnly(!canEditMeta(meta));

  // Mural de comentários do KPI (Controladoria ↔ Gestor)
  drawerKpiId = meta.id_kpi || currentKpiId;
  const cInput = document.getElementById('drw-coment-input');
  if (cInput) cInput.value = '';
  renderComentarios(drawerKpiId);

  document.getElementById('drawer').classList.add('open');
  document.getElementById('drawer-overlay').classList.add('on');
}

// ── Mural de comentários do KPI ───────────────────────────────────
// Pequeno histórico rolante de mensagens entre a Controladoria (admin) e o
// gestor do KPI. Fica na aba Observações e é escrito por ambos os lados —
// inclusive pelo gestor, que no restante do drawer é apenas visualizador.
function escHtml(s) {
  return String(s == null ? '' : s)
    .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;').replace(/'/g, '&#39;');
}

function fmtDataHora(iso) {
  if (!iso) return '';
  const d = new Date(iso);
  if (isNaN(d)) return '';
  const p = n => String(n).padStart(2, '0');
  return `${p(d.getDate())}/${p(d.getMonth()+1)}/${d.getFullYear()} ${p(d.getHours())}:${p(d.getMinutes())}`;
}

async function renderComentarios(idKpi) {
  const list = document.getElementById('drw-coment-list');
  if (!list) return;
  list.innerHTML = '<div class="coment-empty">Carregando…</div>';
  let coments = [];
  try { coments = await apiLoadComentarios(idKpi); } catch (e) { coments = []; }
  // Ignora resposta antiga se o usuário já trocou de KPI no drawer
  if (idKpi !== drawerKpiId) return;
  coments.sort((a, b) => new Date(a.criado_em) - new Date(b.criado_em));
  if (!coments.length) {
    list.innerHTML = '<div class="coment-empty">Nenhum comentário ainda. Use o campo abaixo para registrar uma solicitação ou observação sobre este KPI.</div>';
    return;
  }
  list.innerHTML = coments.map(c => {
    const adm = c.autor_papel === 'Controladoria';
    return `<div class="coment ${adm ? 'adm' : 'gestor'}">
      <div class="coment-hd">
        <span class="coment-autor">${escHtml(c.autor_nome)}</span>
        <span class="coment-papel ${adm ? 'p-adm' : 'p-gestor'}">${adm ? 'Controladoria' : 'Gestor'}</span>
        <span class="coment-data">${fmtDataHora(c.criado_em)}</span>
      </div>
      <div class="coment-txt">${escHtml(c.texto)}</div>
    </div>`;
  }).join('');
  list.scrollTop = list.scrollHeight;
}

async function addComentario() {
  const input = document.getElementById('drw-coment-input');
  if (!input) return;
  const texto = input.value.trim();
  if (!texto) { toast('Escreva um comentário antes de enviar.', 'warn'); return; }
  const idKpi = drawerKpiId;
  const kpi = KPIS.find(k => k.id === idKpi);
  if (!kpi || !canSeeKPI(kpi)) { toast('Sem permissão para comentar neste KPI.', 'err'); return; }

  const papel = isAdmin() ? 'Controladoria' : 'Gestor';
  const payload = {
    id_kpi: idKpi,
    autor_nome:  SESSION.nome,
    autor_email: SESSION.email,
    autor_papel: papel,
    texto,
  };
  const sendBtn = document.getElementById('drw-coment-send');
  if (sendBtn) sendBtn.disabled = true;
  try {
    const row = await apiAddComentario(payload);
    // Em modo live o cache é opcional; apenas re-renderiza a partir do banco
    if (!isLiveMode() && row && !DB.comentarios.some(c => c.id === row.id)) {
      // apiAddComentario já empurrou em demo; nada a fazer
    }
    input.value = '';
    await renderComentarios(idKpi);
    toast('💬 Comentário enviado.', 'ok');
  } catch (e) {
    toast('Erro ao enviar comentário: ' + (e.message || e), 'err');
  } finally {
    if (sendBtn) sendBtn.disabled = false;
  }
}

// Ativa/desativa o modo somente-leitura do drawer de meta.
// Gestores abrem o drawer para VER os lançamentos e ler a descrição (como o card),
// mas sem qualquer campo editável nem botão de salvar/excluir.
function applyDrawerReadOnly(readOnly) {
  const drawer = document.getElementById('drawer');
  // .no-ro fica de fora: o campo de comentário do KPI é liberado mesmo p/ gestores
  // .acum-input também fica de fora daqui: seu readOnly combina modo Entrada
  // Manual + permissão de edição (canEditMeta), decidido só por recalcDrawerLive()
  // — que já checa a permissão direto, então funciona independente da ordem
  // de chamada entre essa função e buildMonthGrids/recalcDrawerLive.
  drawer.querySelectorAll('.drw-body input:not(.no-ro):not(.acum-input), .drw-body select:not(.no-ro), .drw-body textarea:not(.no-ro)').forEach(el => {
    if (el.tagName === 'SELECT') el.disabled = readOnly;
    else el.readOnly = readOnly;
    el.classList.toggle('ro', readOnly);
  });
  const saveBtn = drawer.querySelector('.btn-save');
  if (saveBtn) saveBtn.style.display = readOnly ? 'none' : '';
  const banner = document.getElementById('drw-ro-banner');
  if (banner) banner.style.display = readOnly ? 'block' : 'none';
  if (readOnly) document.getElementById('drw-title').textContent = 'Visualizar Meta';
}

function buildMonthGrids(meta) {
  const registros = DB.metasMensais.filter(m => m.id_meta === meta.id && m.ano === ANO_ATUAL);
  const regMap = {};
  for (const r of registros) regMap[r.mes] = r;

  let metaHtml = '', realHtml = '';
  for (let mes = 1; mes <= 12; mes++) {
    const r = regMap[mes] || {};
    const mv = r.valor_meta != null ? r.valor_meta : '';
    const rv = r.valor_realizado != null ? r.valor_realizado : '';
    const mvDisplay = mv !== '' ? String(mv).replace('.', ',') : '';
    const rvDisplay = rv !== '' ? String(rv).replace('.', ',') : '';
    metaHtml += `<div class="mi">
      <label>${MESES_ABREV[mes-1]}</label>
      <input type="text" data-mes="${mes}" data-type="meta" value="${mvDisplay}" placeholder="—" oninput="recalcDrawerLive()">
    </div>`;
    realHtml += `<div class="mi">
      <label>${MESES_ABREV[mes-1]}</label>
      <input type="text" data-mes="${mes}" data-type="real" value="${rvDisplay}" class="${rvDisplay?'has-val':''}" placeholder="—"
        oninput="this.classList.toggle('has-val', this.value!=''); recalcDrawerLive()">
    </div>`;
  }
  document.getElementById('drw-meta-grid').innerHTML = metaHtml;
  document.getElementById('drw-real-grid').innerHTML = realHtml;

  // Linha "Acumulado" — mesmo padrão visual do mês, mas destacada. Editável
  // só quando Acumulado = Entrada Manual; nos outros modos fica travada e
  // mostra o valor calculado ao vivo (recalcDrawerLive cuida disso).
  const mvAcum = meta.acumulado_meta_manual != null ? String(meta.acumulado_meta_manual).replace('.', ',') : '';
  const rvAcum = meta.acumulado_realizado_manual != null ? String(meta.acumulado_realizado_manual).replace('.', ',') : '';
  document.getElementById('drw-meta-acum-wrap').innerHTML = `<div class="mi mi-acum">
    <label>Acum.</label>
    <input type="text" class="acum-input" id="drw-meta-acum-input" value="${mvAcum}" placeholder="—" oninput="recalcDrawerLive()">
  </div>`;
  document.getElementById('drw-real-acum-wrap').innerHTML = `<div class="mi mi-acum">
    <label>Acum.</label>
    <input type="text" class="acum-input" id="drw-real-acum-input" value="${rvAcum}" placeholder="—" oninput="recalcDrawerLive()">
  </div>`;

  recalcDrawerLive();
  updatePesoTotalHint();
}

// Formata um número calculado de volta pro padrão de texto dos campos
// (vírgula decimal, arredondado — evita cauda de ponto flutuante tipo
// "195000.00000000003" aparecendo num campo travado).
function fmtInputVal(n, tipoFormato) {
  if (n == null || isNaN(n)) return '';
  const rounded = tipoFormato === 'inteiro' ? Math.round(n) : Math.round(n * 100) / 100;
  return String(rounded).replace('.', ',');
}

// ── Recálculo ao vivo do Acumulado (Meta Mensal + Realizado Mensal) ────────
// Roda a cada tecla digitada em qualquer mês (ou nos próprios campos
// "Acum." em modo manual) e a cada troca de Tipo de Formato/Bom Quando/
// Fórmula/Acumulado — sem precisar salvar para ver o resultado mudar.
// Espelha a mesma lógica de calcMeta() em engine.js, mas lendo os valores
// direto do formulário (ainda não salvos) em vez do banco.
function recalcDrawerLive() {
  if (!drawerMetaId) return;
  const meta = DB.metas.find(m => m.id === drawerMetaId);
  if (!meta) return;

  const tipoFormato   = document.getElementById('drw-formato').value;
  const bomQuando     = document.getElementById('drw-bom').value;
  const formula       = document.getElementById('drw-formula').value;
  const tipoAcumulado = document.getElementById('drw-acumulado').value;
  const peso          = parseFloat(document.getElementById('drw-peso').value) || 0;

  const isManual = tipoAcumulado === 'manual';
  // Combina as duas travas: quem não pode editar a meta (gestor) nunca edita
  // aqui, mesmo em modo manual; quem pode editar só digita quando é manual —
  // nos outros modos o campo fica travado mostrando o valor calculado ao vivo.
  const semPermissao = !canEditMeta(meta);
  const acumEditavel = isManual && !semPermissao;
  const metaAcumInput = document.getElementById('drw-meta-acum-input');
  const realAcumInput = document.getElementById('drw-real-acum-input');
  [metaAcumInput, realAcumInput].forEach(inp => {
    if (!inp) return;
    inp.readOnly = !acumEditavel;
    inp.classList.toggle('acum-locked', !acumEditavel);
  });

  // Lê os valores mensais direto do formulário (reflete o que está sendo
  // digitado agora, não o que já está salvo no banco).
  const metaVals = {}, realVals = {};
  document.querySelectorAll('#drw-meta-grid input[data-mes]').forEach(inp => {
    metaVals[parseInt(inp.dataset.mes, 10)] = parseInput(inp.value, tipoFormato);
  });
  document.querySelectorAll('#drw-real-grid input[data-mes]').forEach(inp => {
    realVals[parseInt(inp.dataset.mes, 10)] = parseInput(inp.value, tipoFormato);
  });
  let ultimoMes = 0;
  for (let mes = 1; mes <= 12; mes++) if (realVals[mes] != null) ultimoMes = mes;

  let metaAc = null, realAc = null;
  if (isManual) {
    metaAc = metaAcumInput ? parseInput(metaAcumInput.value, tipoFormato) : null;
    realAc = realAcumInput ? parseInput(realAcumInput.value, tipoFormato) : null;
  } else if (ultimoMes > 0) {
    let metaSum = 0, realSum = 0, nMeta = 0, nReal = 0;
    for (let mes = 1; mes <= ultimoMes; mes++) {
      if (metaVals[mes] != null) { metaSum += metaVals[mes]; nMeta++; }
      if (realVals[mes] != null) { realSum += realVals[mes]; nReal++; }
    }
    metaAc = tipoAcumulado === 'media' ? (nMeta > 0 ? metaSum / nMeta : 0) : metaSum;
    realAc = tipoAcumulado === 'media' ? (nReal > 0 ? realSum / nReal : 0) : realSum;
    if (metaAcumInput) metaAcumInput.value = fmtInputVal(metaAc, tipoFormato);
    if (realAcumInput) realAcumInput.value = fmtInputVal(realAc, tipoFormato);
  } else {
    if (metaAcumInput) metaAcumInput.value = '';
    if (realAcumInput) realAcumInput.value = '';
  }

  // Atingimento / pontuação — mesma regra de calcMeta()
  let atingimento = null, scoringAt = null, pontuacao = 0;
  if (metaAc != null && realAc != null) {
    if (metaAc !== 0 && realAc !== 0) {
      atingimento = formula === 'real_sobre_meta' ? realAc / metaAc : metaAc / realAc;
      scoringAt   = bomQuando === 'maior' ? realAc / metaAc : metaAc / realAc;
    } else if (metaAc === 0 && realAc === 0) {
      atingimento = 1; scoringAt = 1;
    }
    if (scoringAt !== null) {
      if (scoringAt >= 1.0) pontuacao = peso;
      else if (scoringAt >= 0.9) pontuacao = peso * ((scoringAt - 0.9) / 0.1);
    }
  }

  const cls = scoreClass(scoringAt);
  const at = atingimento !== null ? fmtPct(atingimento) : '—';
  const resumoEl = document.getElementById('drw-resumo');
  if (resumoEl) resumoEl.innerHTML = `
    <b>Meta acumulada:</b> ${metaAc != null ? fmt(metaAc, tipoFormato) : '—'}<br>
    <b>Realizado acumulado:</b> ${realAc != null ? fmt(realAc, tipoFormato) : '—'}<br>
    <b>Atingimento:</b> <span style="color:var(--${cls==='ok'?'ok':cls==='warn'?'warn':'err'})">${at}</span><br>
    <b>Pontuação ponderada:</b> ${(pontuacao*100).toFixed(1)}% (peso ${(peso*100).toFixed(0)}%)<br>
    <b>Último mês apurado:</b> ${ultimoMes > 0 ? MESES_ABREV[ultimoMes-1]+'/2026' : 'Nenhum'}
  `;
}

// ── Colar valores em lote (Ctrl+V) nos campos de mês ────────────────
// Copie uma coluna vertical de 12 valores de uma planilha (Jan a Dez, na
// mesma ordem dos campos) e cole em qualquer mês do grid: os valores são
// distribuídos a partir do campo colado até dezembro, um por linha — sem
// precisar digitar mês a mês. Um valor comum (colagem de célula única)
// continua funcionando normalmente, sem interferência.
function handleMonthPaste(e) {
  const target = e.target;
  if (!target || !target.matches('input[data-mes]') || target.readOnly) return;
  const clip = e.clipboardData || window.clipboardData;
  if (!clip) return;
  const raw = clip.getData('text');
  if (raw == null) return;

  let linhas = raw.replace(/\r\n/g, '\n').replace(/\r/g, '\n').split('\n');
  // remove a linha vazia que sobra ao copiar uma coluna inteira do Excel/Sheets
  if (linhas.length > 1 && linhas[linhas.length - 1] === '') linhas.pop();
  // uma única linha com tabulações = colou uma linha horizontal — separa por elas também
  if (linhas.length === 1 && linhas[0].indexOf('\t') !== -1) linhas = linhas[0].split('\t');
  // valor único: deixa o navegador colar normalmente no campo focado
  if (linhas.length <= 1) return;

  e.preventDefault();
  const grid = target.closest('.months-list');
  if (!grid) return;
  const mesInicial = parseInt(target.dataset.mes, 10);

  let ultimoInput = target;
  for (let i = 0; i < linhas.length; i++) {
    const mes = mesInicial + i;
    if (mes > 12) break;
    const inp = grid.querySelector(`input[data-mes="${mes}"]`);
    if (!inp) continue;
    inp.value = linhas[i].trim();
    if (inp.dataset.type === 'real') inp.classList.toggle('has-val', inp.value !== '');
    ultimoInput = inp;
  }
  ultimoInput.focus();
}
(function setupMonthPasteHandlers() {
  const gridMeta = document.getElementById('drw-meta-grid');
  const gridReal = document.getElementById('drw-real-grid');
  if (gridMeta) gridMeta.addEventListener('paste', handleMonthPaste);
  if (gridReal) gridReal.addEventListener('paste', handleMonthPaste);
})();

// ── Trava inteligente de PESO ───────────────────────────────────────────
// Mostra, ao vivo, quanto o KPI somaria de peso se este valor for salvo —
// não bloqueia digitação (o rebalanceamento de verdade acontece no save,
// ver saveDrawer). Só avisa antes de você clicar em Salvar.
function updatePesoTotalHint() {
  if (!drawerMetaId) return;
  const hintEl = document.getElementById('drw-peso-hint');
  if (!hintEl) return;
  const kpiId = currentKpiId;
  if (!kpiId) { hintEl.textContent = ''; return; }

  const pesoAtual = parseFloat(document.getElementById('drw-peso').value) || 0;
  const outrasMetas = DB.metas.filter(m => m.id_kpi === kpiId && m.ativo && m.id !== drawerMetaId);
  const totalOutras = outrasMetas.reduce((s, m) => s + (parseFloat(m.peso) || 0), 0);
  const totalComEsta = totalOutras + pesoAtual;
  const pct = (totalComEsta * 100).toFixed(0);

  if (totalComEsta > 1.001) {
    hintEl.innerHTML = `⚠ Total do KPI ficaria em <b>${pct}%</b> — ao salvar, as outras metas serão reduzidas proporcionalmente para fechar em 100%.`;
    hintEl.style.color = 'var(--warn)';
  } else {
    hintEl.textContent = `Total do KPI com este peso: ${pct}%`;
    hintEl.style.color = '#999';
  }
}

function switchDrawerTab(tab, btn) {
  drawerCurrentTab = tab;
  document.querySelectorAll('.drw-tab').forEach(b => b.classList.remove('on'));
  if (btn) btn.classList.add('on');
  else {
    const btns = document.querySelectorAll('.drw-tab');
    const idx = ['dados','realizado','obs'].indexOf(tab);
    if (btns[idx]) btns[idx].classList.add('on');
  }
  document.getElementById('drw-tab-dados').style.display     = tab === 'dados'     ? '' : 'none';
  document.getElementById('drw-tab-realizado').style.display = tab === 'realizado'  ? '' : 'none';
  document.getElementById('drw-tab-obs').style.display       = tab === 'obs'        ? '' : 'none';
}

function closeDrawer() {
  // Se era nova meta não salva → remove do DB para não poluir
  if (drawerMetaId) {
    const m = DB.metas.find(x => x.id === drawerMetaId);
    if (m && m._isNew) {
      DB.metas = DB.metas.filter(x => x.id !== drawerMetaId);
      DB.metasMensais = DB.metasMensais.filter(x => x.id_meta !== drawerMetaId);
    }
  }
  document.getElementById('drawer').classList.remove('open');
  document.getElementById('drawer-overlay').classList.remove('on');
  drawerMetaId = null;
}

// Renumera o campo "#" (seq) das metas de um KPI para ficar sempre 1..N
// sem buracos, preservando a ordem relativa atual entre elas. Chamada
// depois de criar ou excluir uma meta — as duas únicas ações que mudam
// o conjunto de metas do KPI (editar uma meta existente não mexe em seq).
function resequenceMetasKpi(kpiId) {
  const metas = DB.metas.filter(m => m.id_kpi === kpiId && m.ativo).sort((a, b) => a.seq - b.seq);
  const alteradas = [];
  metas.forEach((m, i) => {
    const novoSeq = i + 1;
    if (m.seq !== novoSeq) {
      addLog('UPDATE', 'metas', m.id, 'seq', m.seq, novoSeq);
      m.seq = novoSeq;
      alteradas.push(m);
    }
  });
  if (isLiveMode() && alteradas.length) {
    alteradas.forEach(m => apiSaveMeta(m, false).catch(() => {}));
    DB.logs.filter(l => !l._synced).forEach(l => { l._synced = true; apiAddLog(l).catch(() => {}); });
  }
  return alteradas;
}

function saveDrawer() {
  if (!drawerMetaId) return;
  const meta = DB.metas.find(m => m.id === drawerMetaId);
  if (!meta) return;

  if (!canEditMeta(meta)) { toast('Sem permissão para editar esta meta.', 'err'); return; }

  const isNew = !!meta._isNew;
  const before = JSON.parse(JSON.stringify(meta));

  // Validação obrigatória para nova meta
  const novoNome = document.getElementById('drw-nome').value.trim();
  if (isNew && !novoNome) { toast('Preencha o nome da meta antes de salvar.', 'warn'); return; }

  // Salva parâmetros (todos os campos editáveis)
  meta.nome         = novoNome || meta.nome;
  meta.responsavel  = document.getElementById('drw-resp').value.trim()    || meta.responsavel;
  meta.descricao    = document.getElementById('drw-desc').value.trim();
  meta.tipo_formato         = document.getElementById('drw-formato').value;
  meta.bom_quando           = document.getElementById('drw-bom').value;
  meta.formula_atingimento  = document.getElementById('drw-formula').value;
  meta.tipo_acumulado       = document.getElementById('drw-acumulado').value;
  meta.peso                 = parseFloat(document.getElementById('drw-peso').value) || meta.peso;
  meta.status       = document.getElementById('drw-status').value;
  meta.obs          = document.getElementById('drw-obs').value;
  meta.ult_at       = new Date().toLocaleDateString('pt-BR');

  // Acumulado manual — só guarda valor quando o modo é "Entrada Manual".
  // Nos outros modos fica null: o valor exibido é sempre recalculado, não
  // faz sentido guardar um número antigo que confundiria se o modo mudar depois.
  if (meta.tipo_acumulado === 'manual') {
    const metaAcumInput = document.getElementById('drw-meta-acum-input');
    const realAcumInput = document.getElementById('drw-real-acum-input');
    meta.acumulado_meta_manual      = metaAcumInput ? parseInput(metaAcumInput.value, meta.tipo_formato) : null;
    meta.acumulado_realizado_manual = realAcumInput ? parseInput(realAcumInput.value, meta.tipo_formato) : null;
  } else {
    meta.acumulado_meta_manual = null;
    meta.acumulado_realizado_manual = null;
  }

  // Trava inteligente de PESO — se a soma do KPI ultrapassaria 100% com este
  // valor, reduz as OUTRAS metas do mesmo KPI proporcionalmente ao peso atual
  // de cada uma, para fechar em 100%. Nunca deixa peso negativo; se as outras
  // já estiverem muito baixas para absorver o excesso, só segue (o totalizador
  // da tela principal continua avisando visualmente).
  const metasRebalanceadas = [];
  if (meta.id_kpi) {
    const outrasMetas = DB.metas.filter(m => m.id_kpi === meta.id_kpi && m.ativo && m.id !== meta.id);
    const totalOutras = outrasMetas.reduce((s, m) => s + (parseFloat(m.peso) || 0), 0);
    const excesso = (meta.peso + totalOutras) - 1;
    if (excesso > 0.001 && totalOutras > 0) {
      for (const m of outrasMetas) {
        const reducao = excesso * ((parseFloat(m.peso) || 0) / totalOutras);
        const novoPeso = Math.max(0, Math.round((m.peso - reducao) * 1000) / 1000);
        if (novoPeso !== m.peso) {
          addLog('UPDATE', 'metas', m.id, 'peso', m.peso, novoPeso);
          m.peso = novoPeso;
          metasRebalanceadas.push(m);
        }
      }
    }
  }

  // Salva valores mensais (meta e realizado). Metas antigas podem não ter
  // os 12 registros de metas_mensais pré-criados (ex.: importadas via SQL
  // sem o insert correspondente) — quando não existe registro para o mês,
  // cria um novo em vez de descartar o valor digitado.
  const metaInputs = document.querySelectorAll('#drw-meta-grid input');
  const realInputs = document.querySelectorAll('#drw-real-grid input');

  // Só cria registro novo quando há valor a gravar; se o mês já tinha
  // registro, permite atualizar para null (usuário limpando o campo).
  function findMensal(mes) {
    return DB.metasMensais.find(r => r.id_meta === meta.id && r.ano === ANO_ATUAL && r.mes === mes);
  }
  function createMensal(mes) {
    const reg = { id: `mm-${meta.id}-${mes}`, id_meta: meta.id, ano: ANO_ATUAL, mes, valor_meta: null, valor_realizado: null, obs: '' };
    DB.metasMensais.push(reg);
    return reg;
  }

  for (const inp of metaInputs) {
    const mes = parseInt(inp.dataset.mes);
    const val = parseInput(inp.value, meta.tipo_formato);
    let reg = findMensal(mes);
    if (!reg) {
      if (val == null) continue;
      reg = createMensal(mes);
    }
    if (reg.valor_meta !== val) {
      addLog('UPDATE', 'metas_mensais', reg.id, 'valor_meta', reg.valor_meta, val);
      reg.valor_meta = val;
    }
  }
  for (const inp of realInputs) {
    const mes = parseInt(inp.dataset.mes);
    const val = parseInput(inp.value, meta.tipo_formato);
    let reg = findMensal(mes);
    if (!reg) {
      if (val == null) continue;
      reg = createMensal(mes);
    }
    if (reg.valor_realizado !== val) {
      addLog('UPDATE', 'metas_mensais', reg.id, 'valor_realizado', reg.valor_realizado, val);
      reg.valor_realizado = val;
    }
  }

  // Log de parâmetros alterados
  if (before.nome        !== meta.nome)        addLog('UPDATE', 'metas', meta.id, 'nome',        before.nome,        meta.nome);
  if (before.responsavel !== meta.responsavel) addLog('UPDATE', 'metas', meta.id, 'responsavel', before.responsavel, meta.responsavel);
  if (before.descricao   !== meta.descricao)   addLog('UPDATE', 'metas', meta.id, 'descricao',   before.descricao,   meta.descricao);
  if (before.peso        !== meta.peso)        addLog('UPDATE', 'metas', meta.id, 'peso',        before.peso,        meta.peso);
  if (before.bom_quando  !== meta.bom_quando)  addLog('UPDATE', 'metas', meta.id, 'bom_quando',  before.bom_quando,  meta.bom_quando);

  delete meta._isNew;   // marca como persistida antes de fechar
  if (isNew) resequenceMetasKpi(meta.id_kpi);   // garante numeração 1..N sem buracos após criar
  closeDrawer();
  const msgRebal = metasRebalanceadas.length
    ? ` Peso de ${metasRebalanceadas.length} outra${metasRebalanceadas.length>1?'s':''} meta${metasRebalanceadas.length>1?'s':''} ajustado p/ manter o total em 100%.`
    : '';
  toast((isNew ? '✅ Nova meta criada com sucesso!' : '✅ Meta salva com sucesso!') + msgRebal, 'ok');

  // Persiste no servidor. isNew foi capturado ANTES do delete _isNew acima,
  // por isso é passado explicitamente (senão a API faria UPDATE de meta inexistente).
  if (isLiveMode()) {
    const metaId = meta.id;
    // Salva a meta primeiro; só depois os valores mensais (a meta precisa existir
    // no banco antes dos registros mensais por causa da chave estrangeira).
    apiSaveMeta(meta, isNew)
      .then(() => {
        const mensaisDaMeta = DB.metasMensais.filter(r => r.id_meta === metaId && r.ano === ANO_ATUAL);
        return Promise.all(mensaisDaMeta.map(reg => apiSaveMetaMensal(reg).catch(() => {})));
      })
      .catch(err => toast('Erro ao salvar meta: ' + err.message, 'err'));
    // Metas irmãs rebalanceadas por causa da trava de 100% de peso
    metasRebalanceadas.forEach(m => apiSaveMeta(m, false).catch(() => {}));
    // Logs
    DB.logs.filter(l => !l._synced).forEach(l => {
      l._synced = true;
      apiAddLog(l).catch(() => {});
    });
  }

  // Re-renderiza a página do KPI
  if (currentKpiId) showKPI(currentKpiId);
}

// ── Excluir Meta ──────────────────────────────────────────────────
function deleteMeta(metaId) {
  const meta = DB.metas.find(m => m.id === metaId);
  if (!meta) return;
  if (!canEditMeta(meta)) { toast('Sem permissão para excluir esta meta.', 'err'); return; }

  // Avisa se há projetos vinculados
  const projsVinc = DB.projetos.filter(p => p.id_meta === metaId && p.ativo);
  const aviso = projsVinc.length
    ? `\n\nAtenção: ${projsVinc.length} projeto(s) estão vinculados a esta meta e ficarão sem meta vinculada.`
    : '';
  if (!confirm(`Excluir a meta "${meta.nome}"?${aviso}\n\nEsta ação remove a meta e seus valores mensais do painel.`)) return;

  DB.metas = DB.metas.filter(m => m.id !== metaId);
  DB.metasMensais = DB.metasMensais.filter(mm => mm.id_meta !== metaId);
  // Fecha o buraco deixado pela meta excluída na numeração das demais.
  const renumeradas = resequenceMetasKpi(meta.id_kpi);

  if (isLiveMode()) {
    apiDeleteMeta(metaId)
      .then(() => {
        addLog('DELETE', 'metas', metaId, 'nome', meta.nome, 'excluída');
        DB.logs.filter(l => !l._synced).forEach(l => { l._synced = true; apiAddLog(l).catch(() => {}); });
      })
      .catch(err => toast('Erro ao excluir no servidor: ' + err.message, 'err'));
  }

  const msgRenum = renumeradas.length ? ' Numeração das demais metas ajustada.' : '';
  toast('🗑️ Meta excluída.' + msgRenum, '');
  if (currentKpiId) showKPI(currentKpiId);
}

// Chamado pelo botão "Excluir Meta" dentro do drawer
function deleteMetaFromDrawer() {
  if (!drawerMetaId) return;
  const id = drawerMetaId;
  // fecha o drawer sem disparar a limpeza de "nova meta"
  const m = DB.metas.find(x => x.id === id);
  if (m && m._isNew) { closeDrawer(); return; }
  document.getElementById('drawer').classList.remove('open');
  document.getElementById('drawer-overlay').classList.remove('on');
  drawerMetaId = null;
  deleteMeta(id);
}

// ── Imprimir Meta (PDF via caixa de impressão do navegador) ────────
// Usa window.print() com CSS dedicado (@media print no style.css) para gerar
// uma versão em retrato só com os cards e tabelas do KPI atual — menu lateral,
// cabeçalho e botões somem. O usuário escolhe "Salvar como PDF" no destino.
function imprimirKPI() {
  if (!currentKpiId) return;
  const kpi = KPIS.find(k => k.id === currentKpiId);
  const originalTitle = document.title;
  // Muitos navegadores usam document.title como nome padrão do arquivo ao salvar em PDF
  if (kpi) document.title = `Metas ${kpi.codigo} - ${kpi.nome}`.replace(/\s+/g, ' ').trim();
  window.print();
  const restoreTitle = () => { document.title = originalTitle; window.removeEventListener('afterprint', restoreTitle); };
  window.addEventListener('afterprint', restoreTitle);
}

// ── Modal Editar KPI ──────────────────────────────────────────────
function openKpiEdit() {
  if (!currentKpiId) return;
  const kpi = KPIS.find(k => k.id === currentKpiId);
  if (!kpi) return;
  document.getElementById('kpi-edit-nome').value = kpi.nome;
  document.getElementById('kpi-edit-resp').value = kpiResps(kpi);
  document.getElementById('kpi-edit-dir').value  = kpi.diretoria;
  document.getElementById('kpi-edit-area').value = kpi.area;
  document.getElementById('kpi-edit-modal').classList.add('on');
}

function closeKpiEdit() {
  document.getElementById('kpi-edit-modal').classList.remove('on');
}

function saveKpiEdit() {
  if (!currentKpiId) return;
  const kpi = KPIS.find(k => k.id === currentKpiId);
  if (!kpi) return;

  const nome = document.getElementById('kpi-edit-nome').value.trim();
  const resp = document.getElementById('kpi-edit-resp').value.trim();
  const dir  = document.getElementById('kpi-edit-dir').value.trim();
  const area = document.getElementById('kpi-edit-area').value.trim();

  if (!nome) { toast('Nome do KPI é obrigatório.', 'warn'); return; }

  // Atualiza em memória
  kpi.nome         = nome;
  kpi.responsaveis = resp ? resp.split(',').map(s => s.trim()).filter(Boolean) : [];
  kpi.diretoria    = dir;
  kpi.area         = area;

  closeKpiEdit();
  toast('✅ KPI atualizado!', 'ok');
  showKPI(currentKpiId); // re-renderiza o cabeçalho

  // Persiste no servidor
  if (isLiveMode()) {
    apiSaveKpi(kpi).catch(err => toast('Erro ao salvar KPI: ' + err.message, 'err'));
    addLog('UPDATE', 'kpis', kpi.id, 'header', '', JSON.stringify({ nome, resp, dir, area }));
    DB.logs.filter(l => !l._synced).forEach(l => {
      l._synced = true;
      apiAddLog(l).catch(() => {});
    });
  }
}

// ── Modal de Projeto ──────────────────────────────────────────────
function openProjModal(projId, kpiId) {
  editingProjId = projId || null;
  const kpi = KPIS.find(k => k.id === (kpiId || currentKpiId));
  const canEdit = isAdmin() || (kpi && (kpi.responsaveis||[]).includes(SESSION.responsavel));

  // Popula select de metas
  const metas = DB.metas.filter(m => m.id_kpi === (kpiId || currentKpiId) && m.ativo);
  let metaOpts = '<option value="">— Selecione a meta vinculada —</option>';
  for (const m of metas) metaOpts += `<option value="${m.id}">Meta ${m.seq} · ${m.nome}</option>`;
  document.getElementById('proj-meta-sel').innerHTML = metaOpts;

  if (projId) {
    const p = DB.projetos.find(x => x.id === projId);
    if (!p) return;
    document.getElementById('modal-title').textContent = 'Editar Projeto';
    document.getElementById('proj-id').value           = p.id;
    document.getElementById('proj-nome').value         = p.nome;
    document.getElementById('proj-desc').value         = p.descricao;
    document.getElementById('proj-meta-sel').value     = p.id_meta;
    document.getElementById('proj-resp').value         = p.responsavel;
    document.getElementById('proj-status').value       = p.status;
    document.getElementById('proj-prio').value         = p.prioridade;
    document.getElementById('proj-prazo').value        = p.prazo;
    document.getElementById('proj-pct').value          = p.percentual_evolucao;
    document.getElementById('proj-resp-acao').value    = p.responsavel_acao;
    document.getElementById('proj-prox-acao').value    = p.proxima_acao;
    document.getElementById('proj-obs').value          = p.obs;
  } else {
    document.getElementById('modal-title').textContent = 'Novo Projeto';
    document.getElementById('proj-id').value    = '';
    document.getElementById('proj-nome').value  = '';
    document.getElementById('proj-desc').value  = '';
    document.getElementById('proj-resp').value  = kpi ? kpiResps(kpi) : SESSION.nome;
    document.getElementById('proj-status').value = 'Não iniciado';
    document.getElementById('proj-prio').value  = 'Média';
    document.getElementById('proj-prazo').value = '';
    document.getElementById('proj-pct').value   = 0;
    document.getElementById('proj-resp-acao').value = '';
    document.getElementById('proj-prox-acao').value  = '';
    document.getElementById('proj-obs').value        = '';
  }
  // Botão Excluir: só aparece ao editar e para quem tem permissão
  const delBtn = document.getElementById('btn-proj-delete');
  if (delBtn) delBtn.style.display = (projId && canEdit) ? '' : 'none';

  document.getElementById('proj-modal').classList.add('on');
}

function closeModal() {
  document.getElementById('proj-modal').classList.remove('on');
  editingProjId = null;
}

function saveProject() {
  const nome = document.getElementById('proj-nome').value.trim();
  const metaId = document.getElementById('proj-meta-sel').value;
  if (!nome) { toast('Informe o nome do projeto.', 'err'); return; }
  if (!metaId) { toast('Selecione a meta vinculada.', 'err'); return; }

  const now = new Date().toLocaleDateString('pt-BR');
  const kpiId = currentKpiId;

  if (editingProjId) {
    const p = DB.projetos.find(x => x.id === editingProjId);
    if (!p) return;
    p.nome                 = nome;
    p.descricao            = document.getElementById('proj-desc').value;
    p.id_meta              = metaId;
    p.responsavel          = document.getElementById('proj-resp').value;
    p.status               = document.getElementById('proj-status').value;
    p.prioridade           = document.getElementById('proj-prio').value;
    p.prazo                = document.getElementById('proj-prazo').value;
    p.percentual_evolucao  = parseInt(document.getElementById('proj-pct').value) || 0;
    p.responsavel_acao     = document.getElementById('proj-resp-acao').value;
    p.proxima_acao         = document.getElementById('proj-prox-acao').value;
    p.obs                  = document.getElementById('proj-obs').value;
    p.data_atualizacao     = now;
    p.usuario_atualizacao  = SESSION.email;
    addLog('UPDATE', 'projetos', p.id, 'status', '', p.status);
    toast('✅ Projeto atualizado!', 'ok');
  } else {
    const newId = (typeof crypto !== 'undefined' && crypto.randomUUID)
      ? crypto.randomUUID()
      : 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, c => {
          const r = Math.random() * 16 | 0;
          return (c === 'x' ? r : (r & 0x3 | 0x8)).toString(16);
        });
    const newP = {
      id: newId, id_meta: metaId, id_kpi: kpiId, _isNew: true,
      nome,
      descricao:           document.getElementById('proj-desc').value,
      responsavel:         document.getElementById('proj-resp').value,
      status:              document.getElementById('proj-status').value,
      prazo:               document.getElementById('proj-prazo').value,
      percentual_evolucao: parseInt(document.getElementById('proj-pct').value) || 0,
      prioridade:          document.getElementById('proj-prio').value,
      proxima_acao:        document.getElementById('proj-prox-acao').value,
      responsavel_acao:    document.getElementById('proj-resp-acao').value,
      obs:                 document.getElementById('proj-obs').value,
      ativo: true,
      data_criacao:       now,
      data_atualizacao:   now,
      usuario_atualizacao: SESSION.email,
    };
    DB.projetos.push(newP);
    addLog('INSERT', 'projetos', newP.id, 'nome', '', newP.nome);
    toast('✅ Projeto criado!', 'ok');
  }

  // Persiste no servidor
  if (isLiveMode()) {
    const proj = editingProjId
      ? DB.projetos.find(x => x.id === editingProjId)
      : DB.projetos[DB.projetos.length - 1];
    if (proj) apiSaveProject(proj).catch(err => toast('Erro ao salvar projeto: ' + err.message, 'err'));
  }

  closeModal();
  if (currentKpiId) {
    const kpi = KPIS.find(k => k.id === currentKpiId);
    renderProjTable(currentKpiId, kpi);
  }
}

// ── Excluir Projeto ───────────────────────────────────────────────
function deleteProject(projId) {
  const p = DB.projetos.find(x => x.id === projId);
  if (!p) return;
  if (!confirm(`Excluir o projeto "${p.nome}"?\n\nEsta ação não pode ser desfeita.`)) return;

  DB.projetos = DB.projetos.filter(x => x.id !== projId);

  if (isLiveMode()) {
    apiDeleteProject(projId)
      .then(() => {
        addLog('DELETE', 'projetos', projId, 'nome', p.nome, 'excluído');
        DB.logs.filter(l => !l._synced).forEach(l => { l._synced = true; apiAddLog(l).catch(() => {}); });
      })
      .catch(err => toast('Erro ao excluir no servidor: ' + err.message, 'err'));
  }

  toast('🗑️ Projeto excluído.', '');
  const kpi = KPIS.find(k => k.id === currentKpiId);
  if (kpi) renderProjTable(currentKpiId, kpi);
}

// Chamado pelo botão "Excluir Projeto" dentro do modal de edição
function deleteProjectFromModal() {
  const projId = document.getElementById('proj-id').value;
  if (!projId) return;
  closeModal();           // fecha o modal antes de confirmar para limpar o estado
  deleteProject(projId);
}

// ── Breadcrumb ────────────────────────────────────────────────────
function setBreadcrumb(items) {
  let html = '';
  for (let i = 0; i < items.length; i++) {
    const it = items[i];
    if (i > 0) html += '<span>›</span>';
    if (it.action) html += `<a onclick="${it.action}">${it.label}</a>`;
    else           html += `<span style="color:#888">${it.label}</span>`;
  }
  document.getElementById('breadcrumb').innerHTML = html;
}

// ── Gerenciamento de Usuários (Admin) ─────────────────────────────

function showUsersAdmin() {
  if (!isAdmin()) return;
  currentView = 'users';
  currentKpiId = null;
  document.getElementById('view-index').classList.remove('on');
  document.getElementById('view-kpi').classList.remove('on');
  document.getElementById('view-users').classList.add('on');
  renderNav();
  setBreadcrumb([{ label: 'Início', action: 'showIndex()' }, { label: 'Gerenciar Acessos' }]);
  loadAndRenderUsers();
}

async function loadAndRenderUsers() {
  let users = [];
  if (isLiveMode()) {
    try {
      const { data, error } = await _supa.from('usuarios').select('*').order('nome');
      if (error) throw error;
      users = (data || []).map(u => ({
        email: u.email, nome: u.nome,
        perfil: u.perfil_acesso, responsavel: u.responsavel_vinculado,
        senha: '', ativo: u.ativo,
      }));
    } catch(e) { toast('Erro ao carregar usuários: ' + e.message, 'err'); return; }
  } else {
    users = USUARIOS.map(u => ({ ...u }));
  }
  _usersCache = users;
  renderUsersTable(users);
}

function renderUsersTable(users) {
  if (!users.length) {
    document.getElementById('users-tbody').innerHTML =
      '<tr><td colspan="6"><div class="empty-state"><div class="empty-state-icon">👤</div><div class="empty-state-t">Nenhum usuário cadastrado</div></div></td></tr>';
    return;
  }
  const PERFIL_LABEL = { Admin: 'Administrador', DiretorN1: 'Diretoria N1', Responsavel: 'Responsável', responsavel: 'Responsável', administrador: 'Administrador', diretoria_n1: 'Diretoria N1' };
  let rows = '';
  for (const u of users) {
    const perfil = PERFIL_LABEL[u.perfil] || u.perfil || '—';
    const ativo = u.ativo === true || u.ativo === 'true' || u.ativo === 'TRUE';
    const statusBadge = ativo
      ? '<span class="usr-badge-on">Ativo</span>'
      : '<span class="usr-badge-off">Inativo</span>';

    let kpisHtml = '—';
    const perfilNorm = String(u.perfil || '').toLowerCase();
    if (perfilNorm === 'admin' || perfilNorm === 'administrador') {
      kpisHtml = '<span style="color:#888;font-size:11px">Todos (admin)</span>';
    } else if (perfilNorm === 'diretorn1' || perfilNorm === 'diretoria_n1') {
      kpisHtml = '<span style="color:#888;font-size:11px">Todos (leitura)</span>';
    } else {
      const nome = u.responsavel || u.nome || '';
      const kpisAcesso = KPIS.filter(k => (k.responsaveis || []).includes(nome));
      kpisHtml = kpisAcesso.length
        ? kpisAcesso.map(k => `<span class="usr-kpi-tag">${k.codigo}</span>`).join(' ')
        : '<span style="color:#aaa;font-size:11px">Nenhum</span>';
    }

    rows += `<tr>
      <td><strong>${u.nome}</strong></td>
      <td style="font-size:12px;color:#555">${u.email}</td>
      <td class="tbl-c"><span class="usr-badge-perfil">${perfil}</span></td>
      <td>${kpisHtml}</td>
      <td class="tbl-c">${statusBadge}</td>
      <td class="tbl-c"><button class="tbl-btn" onclick="openUserModal('${u.email}')">Editar</button></td>
    </tr>`;
  }
  document.getElementById('users-tbody').innerHTML = rows;
}

function openUserModal(emailOrNull) {
  editingUserEmail = emailOrNull;
  const isNew = !emailOrNull;

  document.getElementById('user-modal-title').textContent = isNew ? 'Novo Usuário' : 'Editar Usuário';
  document.getElementById('usr-pwd-hint').style.display = isNew ? 'none' : '';
  document.getElementById('btn-user-delete').style.display = isNew ? 'none' : '';

  if (isNew) {
    document.getElementById('usr-nome').value  = '';
    document.getElementById('usr-email').value = '';
    document.getElementById('usr-pwd').value   = '';
    document.getElementById('usr-perfil').value = 'Responsavel';
    document.getElementById('usr-ativo').value = 'true';
  } else {
    // Busca o usuário na lista renderizada (demo) ou pelo email
    let u = null;
    if (!isLiveMode()) {
      u = USUARIOS.find(x => x.email === emailOrNull);
    } else {
      // Dados vêm do servidor — usa o que está em cache na tabela renderizada
      u = _usersCache ? _usersCache.find(x => x.email === emailOrNull) : null;
    }
    if (!u) { toast('Usuário não encontrado.', 'err'); return; }
    document.getElementById('usr-nome').value   = u.nome  || '';
    document.getElementById('usr-email').value  = u.email || '';
    document.getElementById('usr-pwd').value    = '';
    const perfilVal = { administrador:'Admin', diretoria_n1:'DiretorN1', responsavel:'Responsavel' }[String(u.perfil||'').toLowerCase()] || u.perfil || 'Responsavel';
    document.getElementById('usr-perfil').value = perfilVal;
    document.getElementById('usr-ativo').value  = String(u.ativo === true || u.ativo === 'true' || u.ativo === 'TRUE');
  }

  onUserPerfilChange();
  document.getElementById('user-modal').classList.add('on');
}

// Cache de usuários para edição sem re-fetch
let _usersCache = null;

function closeUserModal() {
  document.getElementById('user-modal').classList.remove('on');
  editingUserEmail = null;
}

function onUserPerfilChange() {
  const perfil = document.getElementById('usr-perfil').value;
  const showKpis = (perfil === 'Responsavel');
  document.getElementById('usr-kpis-section').style.display = showKpis ? '' : 'none';
  if (showKpis) buildKpiCheckboxes();
}

function buildKpiCheckboxes() {
  const nome = document.getElementById('usr-nome').value.trim() ||
    (editingUserEmail ? (USUARIOS.find(u=>u.email===editingUserEmail)||{}).responsavel || '' : '');

  // Agrupa KPIs por área
  const areas = {};
  for (const k of KPIS) {
    if (!k.ativo) continue;
    if (!areas[k.area]) areas[k.area] = [];
    areas[k.area].push(k);
  }
  let html = '';
  for (const [area, list] of Object.entries(areas)) {
    html += `<div class="usr-kpi-area-label">${areaLabel(area)}</div><div class="usr-kpi-checks">`;
    for (const k of list) {
      const checked = nome && (k.responsaveis || []).includes(nome) ? 'checked' : '';
      html += `<label class="usr-kpi-check">
        <input type="checkbox" value="${k.id}" ${checked}>
        <span><strong>${k.codigo}</strong> ${k.nome.replace('KPI ','')}</span>
      </label>`;
    }
    html += '</div>';
  }
  document.getElementById('usr-kpis-list').innerHTML = html;
}

async function saveUser() {
  const nome  = document.getElementById('usr-nome').value.trim();
  const email = document.getElementById('usr-email').value.trim().toLowerCase();
  const senha = document.getElementById('usr-pwd').value;
  const perfil = document.getElementById('usr-perfil').value;
  const ativo  = document.getElementById('usr-ativo').value === 'true';
  const isNew  = !editingUserEmail;

  if (!nome)  { toast('Informe o nome completo.', 'err'); return; }
  if (!email) { toast('Informe o e-mail.', 'err'); return; }
  if (isNew && !senha) { toast('Defina uma senha para o novo usuário.', 'err'); return; }

  // KPIs selecionados (apenas para Responsavel)
  const selectedKpiIds = perfil === 'Responsavel'
    ? [...document.querySelectorAll('#usr-kpis-list input[type=checkbox]:checked')].map(c => c.value)
    : [];

  if (!isLiveMode()) {
    // ── Demo mode ───────────────────────────────────────────
    if (isNew) {
      if (USUARIOS.find(u => u.email === email)) { toast('E-mail já cadastrado.', 'err'); return; }
      USUARIOS.push({ email, nome, perfil, responsavel: nome, diretoria: '', senha, ativo });
    } else {
      const u = USUARIOS.find(x => x.email === editingUserEmail);
      if (u) { u.nome = nome; u.perfil = perfil; u.ativo = ativo; if (senha) u.senha = senha; }
    }
    // Atualiza responsaveis dos KPIs em memória
    const oldNome = editingUserEmail
      ? (USUARIOS.find(u => u.email === editingUserEmail) || {}).responsavel || ''
      : '';
    for (const k of KPIS) {
      const tinha = (k.responsaveis || []).includes(oldNome || nome);
      const quer  = selectedKpiIds.includes(k.id);
      if (quer && !tinha)  k.responsaveis = [...(k.responsaveis||[]), nome];
      if (!quer && tinha)  k.responsaveis = (k.responsaveis||[]).filter(r => r !== (oldNome||nome));
    }
    closeUserModal();
    toast(isNew ? '✅ Usuário criado!' : '✅ Usuário atualizado!', 'ok');
    loadAndRenderUsers();
    return;
  }

  // ── Live mode (Supabase) ─────────────────────────────────
  try {
    await apiSaveUser({ email, nome, perfil, senha: senha||null, ativo, isNew, currentEmail: editingUserEmail });
    await apiSyncKpiAccess(nome, selectedKpiIds, perfil);
    closeUserModal();
    if (isNew) {
      toast('✅ Usuário criado! Login já ativo — pode entrar com a senha definida.', 'ok');
    } else {
      toast(senha ? '✅ Usuário atualizado (senha redefinida).' : '✅ Usuário atualizado!', 'ok');
    }
    loadAndRenderUsers();
  } catch(e) { toast('Erro ao salvar: ' + e.message, 'err'); }
}

function deleteUserConfirm() {
  const email = editingUserEmail;
  if (!email) return;
  const u = USUARIOS.find(x => x.email === email) || { nome: email };
  if (!confirm(`Excluir o usuário "${u.nome}"?\n\nEle perderá acesso imediatamente.`)) return;

  if (!isLiveMode()) {
    const idx = USUARIOS.findIndex(x => x.email === email);
    if (idx >= 0) USUARIOS.splice(idx, 1);
    // Remove dos KPIs
    for (const k of KPIS) k.responsaveis = (k.responsaveis||[]).filter(r => r !== u.responsavel);
    closeUserModal();
    toast('🗑️ Usuário removido.', '');
    loadAndRenderUsers();
    return;
  }
  apiDeleteUser(email)
    .then((r) => {
      closeUserModal();
      toast(r && r.note ? '🗑️ Login removido (perfil mantido inativo).' : '🗑️ Usuário e login removidos.', '');
      loadAndRenderUsers();
    })
    .catch(e => toast('Erro ao excluir: ' + e.message, 'err'));
}

// ── Inicialização ─────────────────────────────────────────────────
(async function init() {
  const logoEl = document.getElementById('logo-img');
  if (logoEl) logoEl.src = LOGO_B64;
  document.getElementById('app').classList.remove('on');

  // Em modo live, tenta restaurar sessão Supabase existente (ex.: após F5)
  if (isLiveMode()) {
    try {
      const { data: { session } } = await _supa.auth.getSession();
      if (session) {
        const { data: perfil } = await _supa
          .from('usuarios')
          .select('nome, perfil_acesso, responsavel_vinculado, diretoria_vinculada, ativo')
          .eq('email', session.user.email)
          .single();
        if (perfil && perfil.ativo) {
          const perfilMapped = PERFIL_MAP[perfil.perfil_acesso] || perfil.perfil_acesso;
          DB.usuario = { email: session.user.email, nome: perfil.nome, perfil: perfilMapped, responsavel: perfil.responsavel_vinculado, diretoria: perfil.diretoria_vinculada, ativo: true };
          SESSION = DB.usuario;
          await loadData();
          initApp();
        }
      }
    } catch (e) {
      console.warn('Falha ao restaurar sessão:', e);
    }
  }
})();
