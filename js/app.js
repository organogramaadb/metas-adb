// ===================================================================
// app.js — Renderização, navegação, interações e inicialização
// ===================================================================

const ANO_ATUAL = 2025;
let currentKpiId = null;
let drawerMetaId = null;
let drawerCurrentTab = 'dados';
let editingProjId = null;

// ── Toast ─────────────────────────────────────────────────────────
let toastTimer;
function toast(msg, tipo = '') {
  const el = document.getElementById('toast');
  el.textContent = msg;
  el.className = 'on ' + tipo;
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => { el.className = ''; }, 3200);
}

// ── Login ─────────────────────────────────────────────────────────
function fillDemo(email, pwd) {
  document.getElementById('inp-email').value = email;
  document.getElementById('inp-pwd').value = pwd;
}

function doLogin(e) {
  e.preventDefault();
  const email = document.getElementById('inp-email').value.trim();
  const pwd   = document.getElementById('inp-pwd').value;
  const u = login(email, pwd);
  if (!u) {
    const err = document.getElementById('lerr');
    err.style.display = 'block';
    setTimeout(() => { err.style.display = 'none'; }, 3000);
    return;
  }
  document.getElementById('lo').style.display = 'none';
  document.getElementById('app').classList.add('on');
  // Preenche header
  const img = document.getElementById('hdr-logo');
  img.src = LOGO_B64;
  document.getElementById('hdr-uname').textContent = u.nome;
  document.getElementById('hdr-urole').textContent = u.perfil === 'Admin' ? 'Administrador' : u.perfil === 'DiretorN1' ? 'Diretoria N1' : 'Responsável';
  document.getElementById('hdr-avatar').textContent = u.nome.charAt(0).toUpperCase();
  renderNav();
  showIndex();
}

function doLogout() {
  logout();
  document.getElementById('app').classList.remove('on');
  document.getElementById('lo').style.display = 'flex';
  document.getElementById('inp-pwd').value = '';
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
        <span>${area}</span><span class="nav-area-arrow">▶</span>
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
  document.getElementById('nav-inner').innerHTML = html;
}

function toggleArea(el) {
  el.parentElement.classList.toggle('open');
}

function highlightNav(kpiId) {
  document.querySelectorAll('.nav-kpi').forEach(el => el.classList.remove('sel'));
  const active = document.querySelector(`.nav-kpi[onclick*="${kpiId}"]`);
  if (active) active.classList.add('sel');
}

// ── View: Index ───────────────────────────────────────────────────
function showIndex() {
  currentKpiId = null;
  document.getElementById('view-kpi').classList.remove('on');
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
      <div class="index-area-title">${area}</div>
      <div class="kpi-cards-grid">`;
    for (const k of list) {
      const { totalPontuacao, ultimoMes } = calcKPI(k.id, ANO_ATUAL);
      const cls = scoreClass(totalPontuacao);
      const pctDisplay = (totalPontuacao * 100).toFixed(1) + '%';
      const barWidth = Math.min(100, totalPontuacao * 100).toFixed(1);
      const periodo = ultimoMes > 0 ? `Até ${MESES_ABREV[ultimoMes-1]}/2025` : 'Sem realizado';
      html += `<div class="kpi-index-card" onclick="showKPI('${k.id}')">
        <div class="kic-code">${k.codigo}</div>
        <div class="kic-name">${k.nome}</div>
        <div class="kic-info">
          <div class="kic-resp">Resp.: <strong>${k.responsavel}</strong></div>
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
  document.getElementById('view-index').classList.remove('on');
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
  document.getElementById('kpi-resp-hd').textContent = kpi.responsavel;
  document.getElementById('kpi-dir-hd').textContent  = kpi.diretoria;
  document.getElementById('kpi-area-hd').textContent = kpi.area;

  const { totalPontuacao, resultados, ultimoMes } = calcKPI(kpiId, ANO_ATUAL);
  document.getElementById('kpi-periodo-hd').textContent =
    ultimoMes > 0 ? `Jan – ${MESES_ABREV[ultimoMes-1]} 2025 (acumulado)` : 'Jan – Dez 2025';

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
  const periodo = ultimoMes > 0 ? `Acum. até ${MESES_ABREV[ultimoMes-1]}/2025` : 'Sem realizado apurado';

  let html = `<div class="card-total">
    <div class="ct-label">Pontuação Total do KPI</div>
    <div class="ct-pct">${pctDisplay}</div>
    <div class="ct-sub">${periodo}</div>
    <div class="ct-bar"><div class="ct-bar-fill" style="width:${barW}%"></div></div>
  </div>`;

  for (const r of resultados) {
    const at = r.atingimento;
    const cls2 = scoreClass(at);
    const atDisplay = at !== null ? fmtPct(at) : '—';
    const barW2 = at !== null ? Math.min(100, at * 100).toFixed(1) : 0;
    const pts = (r.pontuacao * 100).toFixed(1) + '%';
    html += `<div class="card-meta" onclick="openDrawer('${r.meta.id}')">
      <div class="cm-num">Meta ${r.meta.seq}</div>
      <div class="cm-name">${r.meta.nome}</div>
      <div class="cm-pct ${cls2}">${atDisplay}</div>
      <div class="cm-bar"><div class="cm-bar-fill ${cls2}" style="width:${barW2}%"></div></div>
      <div class="cm-foot">
        <span>Peso: ${(r.meta.peso * 100).toFixed(0)}%</span>
        <span>${r.meta.bom_quando === 'Maior' ? '↑ Maior' : '↓ Menor'}</span>
      </div>
      <div class="cm-pts">Pts: ${pts}</div>
    </div>`;
  }

  document.getElementById('kpi-cards-row').innerHTML = html;
  document.getElementById('metas-periodo-sub').textContent =
    ultimoMes > 0 ? `Acumulado Jan – ${MESES_ABREV[ultimoMes-1]}/2025` : 'Sem realizado apurado';
}

// ── Tabela de Metas ───────────────────────────────────────────────
function renderMetasTable(resultados, kpi) {
  const canEdit = isAdmin() || kpi.responsavel === SESSION.responsavel;

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
    const cls = scoreClass(at);
    const atDisplay = at !== null ? fmtPct(at) : '—';
    const metaFmt = r.metaAc !== null ? fmt(r.metaAc, m.tipo_formato) : '—';
    const realFmt = r.realAc !== null ? fmt(r.realAc, m.tipo_formato) : '—';
    const pts = (r.pontuacao * 100).toFixed(1) + '%';
    const bomHtml = m.bom_quando === 'Maior'
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
      : '';

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
  document.getElementById('metas-tbody').innerHTML = rows;
}

// ── Tabela de Projetos ────────────────────────────────────────────
function renderProjTable(kpiId, kpi) {
  const canEdit = isAdmin() || kpi.responsavel === SESSION.responsavel;
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
    const editBtn = canEdit
      ? `<button class="tbl-btn" onclick="openProjModal('${p.id}')">Editar</button>`
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
      <td class="tbl-c">${editBtn}</td>
    </tr>`;
  }
  document.getElementById('proj-tbody').innerHTML = rows;
}

// ── Drawer de Edição de Meta ──────────────────────────────────────
function openDrawer(metaId, kpiId) {
  let meta = metaId ? DB.metas.find(m => m.id === metaId) : null;

  if (!meta) {
    // Nova meta (scaffolding mínimo para demo)
    toast('Criação de nova meta disponível após integração com o banco de dados.', 'warn');
    return;
  }

  drawerMetaId = meta.id;
  document.getElementById('drw-title').textContent = 'Editar Meta';
  document.getElementById('drw-sub').textContent = `${meta.codigo_kpi} · Meta ${meta.seq}`;
  document.getElementById('drw-nome').value    = meta.nome;
  document.getElementById('drw-resp').value    = meta.responsavel;
  document.getElementById('drw-unidade').value = meta.unidade_medida;
  document.getElementById('drw-formato').value = meta.tipo_formato;
  document.getElementById('drw-bom').value     = meta.bom_quando;
  document.getElementById('drw-peso').value    = meta.peso;
  document.getElementById('drw-status').value  = meta.status || 'Ativa';
  document.getElementById('drw-obs').value     = meta.obs || '';
  document.getElementById('drw-ult-at').value  = meta.ult_at || '—';

  buildMonthGrids(meta);
  switchDrawerTab('dados', document.querySelector('.drw-tab.on'));
  document.getElementById('drawer').classList.add('open');
  document.getElementById('drawer-overlay').classList.add('on');
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
      <input type="text" data-mes="${mes}" data-type="meta" value="${mvDisplay}" placeholder="—">
    </div>`;
    realHtml += `<div class="mi">
      <label>${MESES_ABREV[mes-1]}</label>
      <input type="text" data-mes="${mes}" data-type="real" value="${rvDisplay}" class="${rvDisplay?'has-val':''}" placeholder="—"
        oninput="this.classList.toggle('has-val', this.value!='')">
    </div>`;
  }
  document.getElementById('drw-meta-grid').innerHTML = metaHtml;
  document.getElementById('drw-real-grid').innerHTML = realHtml;
  updateDrawerResumo(meta);
}

function updateDrawerResumo(meta) {
  const { metaAc, realAc, atingimento, pontuacao, ultimoMes } = calcMeta(meta, ANO_ATUAL);
  const at = atingimento !== null ? fmtPct(atingimento) : '—';
  const cls = scoreClass(atingimento);
  document.getElementById('drw-resumo').innerHTML = `
    <b>Meta acumulada:</b> ${fmt(metaAc, meta.tipo_formato)}<br>
    <b>Realizado acumulado:</b> ${fmt(realAc, meta.tipo_formato)}<br>
    <b>Atingimento:</b> <span style="color:var(--${cls==='ok'?'ok':cls==='warn'?'warn':'err'})">${at}</span><br>
    <b>Pontuação ponderada:</b> ${(pontuacao*100).toFixed(1)}% (peso ${(meta.peso*100).toFixed(0)}%)<br>
    <b>Último mês apurado:</b> ${ultimoMes > 0 ? MESES_ABREV[ultimoMes-1]+'/2025' : 'Nenhum'}
  `;
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
  document.getElementById('drawer').classList.remove('open');
  document.getElementById('drawer-overlay').classList.remove('on');
  drawerMetaId = null;
}

function saveDrawer() {
  if (!drawerMetaId) return;
  const meta = DB.metas.find(m => m.id === drawerMetaId);
  if (!meta) return;

  if (!canEditMeta(meta)) { toast('Sem permissão para editar esta meta.', 'err'); return; }

  const before = JSON.parse(JSON.stringify(meta));

  // Salva parâmetros
  meta.tipo_formato = document.getElementById('drw-formato').value;
  meta.bom_quando   = document.getElementById('drw-bom').value;
  meta.peso         = parseFloat(document.getElementById('drw-peso').value) || meta.peso;
  meta.status       = document.getElementById('drw-status').value;
  meta.obs          = document.getElementById('drw-obs').value;
  meta.ult_at       = new Date().toLocaleDateString('pt-BR');

  // Salva valores mensais (meta e realizado)
  const metaInputs = document.querySelectorAll('#drw-meta-grid input');
  const realInputs = document.querySelectorAll('#drw-real-grid input');

  for (const inp of metaInputs) {
    const mes = parseInt(inp.dataset.mes);
    const val = parseInput(inp.value, meta.tipo_formato);
    const reg = DB.metasMensais.find(r => r.id_meta === meta.id && r.ano === ANO_ATUAL && r.mes === mes);
    if (reg) {
      if (reg.valor_meta !== val) {
        addLog('UPDATE', 'metas_mensais', reg.id, 'valor_meta', reg.valor_meta, val);
        reg.valor_meta = val;
      }
    }
  }
  for (const inp of realInputs) {
    const mes = parseInt(inp.dataset.mes);
    const val = parseInput(inp.value, meta.tipo_formato);
    const reg = DB.metasMensais.find(r => r.id_meta === meta.id && r.ano === ANO_ATUAL && r.mes === mes);
    if (reg) {
      if (reg.valor_realizado !== val) {
        addLog('UPDATE', 'metas_mensais', reg.id, 'valor_realizado', reg.valor_realizado, val);
        reg.valor_realizado = val;
      }
    }
  }

  // Log de parâmetros alterados
  if (before.peso !== meta.peso) addLog('UPDATE', 'metas', meta.id, 'peso', before.peso, meta.peso);
  if (before.bom_quando !== meta.bom_quando) addLog('UPDATE', 'metas', meta.id, 'bom_quando', before.bom_quando, meta.bom_quando);

  closeDrawer();
  toast('✅ Meta salva com sucesso!', 'ok');

  // Persiste no servidor (fire-and-forget — não bloqueia a UI)
  if (isLiveMode()) {
    apiSaveMeta(meta).catch(err => toast('Erro ao salvar meta: ' + err.message, 'err'));
    for (const inp of [...metaInputs, ...realInputs]) {
      const mes = parseInt(inp.dataset.mes);
      const reg = DB.metasMensais.find(r => r.id_meta === meta.id && r.ano === ANO_ATUAL && r.mes === mes);
      if (reg) apiSaveMetaMensal(reg).catch(() => {});
    }
    // Logs
    DB.logs.filter(l => !l._synced).forEach(l => {
      l._synced = true;
      apiAddLog(l).catch(() => {});
    });
  }

  // Re-renderiza a página do KPI
  if (currentKpiId) showKPI(currentKpiId);
}

// ── Modal de Projeto ──────────────────────────────────────────────
function openProjModal(projId, kpiId) {
  editingProjId = projId || null;
  const kpi = KPIS.find(k => k.id === (kpiId || currentKpiId));

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
    document.getElementById('proj-resp').value  = kpi ? kpi.responsavel : SESSION.nome;
    document.getElementById('proj-status').value = 'Não iniciado';
    document.getElementById('proj-prio').value  = 'Média';
    document.getElementById('proj-prazo').value = '';
    document.getElementById('proj-pct').value   = 0;
    document.getElementById('proj-resp-acao').value = '';
    document.getElementById('proj-prox-acao').value  = '';
    document.getElementById('proj-obs').value        = '';
  }
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
    const newP = {
      id: uid('p'), id_meta: metaId, id_kpi: kpiId,
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

// ── Inicialização ─────────────────────────────────────────────────
(async function init() {
  // Logo na tela de login
  const logoEl = document.getElementById('logo-img');
  if (logoEl) logoEl.src = LOGO_B64;
  document.getElementById('app').classList.remove('on');

  // Tenta carregar dados do servidor (se GAS_URL configurado)
  if (isLiveMode()) {
    await apiInit();
    const badge = document.getElementById('mode-badge');
    if (badge) { badge.textContent = 'LIVE'; badge.classList.add('live'); }
  }
})();
