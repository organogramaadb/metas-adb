// ============================================================
// METAS ADB — Google Apps Script Backend v2.0
// Publicar como: Web App → Qualquer pessoa → Execute como: Eu
// ============================================================

const SH_USUARIOS      = 'usuarios';
const SH_KPIS          = 'kpis';
const SH_METAS         = 'metas';
const SH_METAS_MENSAIS = 'metas_mensais';
const SH_PROJETOS      = 'projetos';
const SH_LOGS          = 'logs';

// ── Colunas — devem bater exatamente com os campos do app ────
const COLS_USUARIOS = ['email','nome','perfil','responsavel','senha','ativo'];

const COLS_KPIS = ['id','codigo','nome','area','responsavel','diretoria','descricao','ativo'];

const COLS_METAS = [
  'id','id_kpi','codigo_kpi','seq','nome','descricao','responsavel','diretoria',
  'tipo_formato','unidade_medida','bom_quando','peso','status','obs','ult_at','ativo'
];

const COLS_METAS_MENSAIS = ['id','id_meta','ano','mes','valor_meta','valor_realizado','obs'];

const COLS_PROJETOS = [
  'id','id_kpi','id_meta','nome','descricao','responsavel',
  'status','prioridade','prazo','percentual_evolucao','proxima_acao','responsavel_acao','obs',
  'ativo','data_criacao','data_atualizacao','usuario_atualizacao'
];

const COLS_LOGS = ['id','data_hora','usuario','acao','tabela','id_registro','campo','antes','depois','obs'];

// ── Resposta JSON ────────────────────────────────────────────
function jsonResp(data) {
  return ContentService.createTextOutput(JSON.stringify(data))
    .setMimeType(ContentService.MimeType.JSON);
}

// ── doGet ────────────────────────────────────────────────────
function doGet(e) {
  const action = (e.parameter || {}).action || '';
  try {
    if (action === 'getInitData') return jsonResp(getInitData());
    if (action === 'ping')        return jsonResp({ ok: true, ts: new Date().toISOString() });
    return jsonResp({ ok: true, version: '2.0', ts: new Date().toISOString() });
  } catch (err) { return jsonResp({ error: err.message }); }
}

// ── doPost ───────────────────────────────────────────────────
function doPost(e) {
  let body;
  try { body = JSON.parse(e.postData.contents); }
  catch (_) { return jsonResp({ error: 'JSON inválido' }); }
  const action = body.action || '';
  try {
    if (action === 'authenticate')   return jsonResp(authenticate(body.payload));
    if (action === 'saveMeta')       return jsonResp(saveMeta(body.payload));
    if (action === 'saveMetaMensal') return jsonResp(saveMetaMensal(body.payload));
    if (action === 'saveProject')    return jsonResp(saveProject(body.payload));
    if (action === 'deleteProject')  return jsonResp(deleteProject(body.payload));
    if (action === 'saveKpi')        return jsonResp(saveKpi(body.payload));
    if (action === 'addLog')         return jsonResp(addLog(body.payload));
    return jsonResp({ error: 'Ação desconhecida: ' + action });
  } catch (err) { return jsonResp({ error: err.message }); }
}

// ── getInitData ──────────────────────────────────────────────
function getInitData() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const rawUsuarios = readSheet(ss, SH_USUARIOS,      COLS_USUARIOS);
  const rawKpis     = readSheet(ss, SH_KPIS,          COLS_KPIS);
  const rawMetas    = readSheet(ss, SH_METAS,         COLS_METAS);
  const rawMensais  = readSheet(ss, SH_METAS_MENSAIS, COLS_METAS_MENSAIS);
  const rawProj     = readSheet(ss, SH_PROJETOS,      COLS_PROJETOS);
  const rawLogs     = readSheet(ss, SH_LOGS,          COLS_LOGS);

  const bool = v => v === 'true' || v === true || v === 'TRUE';

  const usuarios = rawUsuarios.map(u => ({ ...u, ativo: bool(u.ativo) }));

  const metas = rawMetas.map(m => ({
    ...m,
    seq:   parseInt(m.seq)    || 1,
    peso:  parseFloat(m.peso) || 0,
    ativo: bool(m.ativo)
  }));

  const metasMensais = rawMensais.map(r => ({
    ...r,
    ano:             parseInt(r.ano)  || 2025,
    mes:             parseInt(r.mes)  || 1,
    valor_meta:      r.valor_meta      !== '' ? parseFloat(r.valor_meta)      : null,
    valor_realizado: r.valor_realizado !== '' ? parseFloat(r.valor_realizado) : null
  }));

  const projetos = rawProj.map(p => ({
    ...p,
    percentual_evolucao: parseFloat(p.percentual_evolucao) || 0,
    ativo: bool(p.ativo)
  }));

  const logs = rawLogs.reverse().slice(0, 200);

  const kpis = rawKpis.map(k => ({ ...k, ativo: bool(k.ativo) }));

  return { usuarios, kpis, metas, metasMensais, projetos, logs };
}

// ── authenticate ─────────────────────────────────────────────
function authenticate(payload) {
  if (!payload || !payload.email || !payload.senha)
    return { error: 'Email e senha obrigatórios' };
  const ss    = SpreadsheetApp.getActiveSpreadsheet();
  const users = readSheet(ss, SH_USUARIOS, COLS_USUARIOS);
  const bool  = v => v === 'true' || v === true || v === 'TRUE';
  const u     = users.find(x =>
    x.email.toLowerCase() === payload.email.toLowerCase() &&
    x.senha === payload.senha && bool(x.ativo)
  );
  if (!u) return { error: 'Credenciais inválidas' };
  const { senha, ...safe } = u;
  return { ok: true, usuario: { ...safe, ativo: true } };
}

// ── saveKpi ───────────────────────────────────────────────────
function saveKpi(payload) {
  if (!payload || !payload.id) return { error: 'id obrigatório' };
  return upsertRow(SH_KPIS, COLS_KPIS, payload);
}

// ── saveMeta ─────────────────────────────────────────────────
function saveMeta(payload) {
  if (!payload || !payload.id) return { error: 'id obrigatório' };
  return upsertRow(SH_METAS, COLS_METAS, payload);
}

// ── saveMetaMensal ───────────────────────────────────────────
function saveMetaMensal(payload) {
  if (!payload || !payload.id) return { error: 'id obrigatório' };
  return upsertRow(SH_METAS_MENSAIS, COLS_METAS_MENSAIS, payload);
}

// ── saveProject ──────────────────────────────────────────────
function saveProject(payload) {
  if (!payload || !payload.id) return { error: 'id obrigatório' };
  return upsertRow(SH_PROJETOS, COLS_PROJETOS, payload);
}

// ── deleteProject ────────────────────────────────────────────
function deleteProject(payload) {
  if (!payload || !payload.id) return { error: 'id obrigatório' };
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sh = ss.getSheetByName(SH_PROJETOS);
  if (!sh) return { error: 'Aba não encontrada' };
  const data = sh.getDataRange().getValues();
  const iId  = data[0].map(h => h.toString().trim()).indexOf('id');
  for (let r = 1; r < data.length; r++) {
    if (String(data[r][iId]) === String(payload.id)) {
      sh.deleteRow(r + 1);
      return { ok: true };
    }
  }
  return { error: 'Projeto não encontrado' };
}

// ── addLog ───────────────────────────────────────────────────
function addLog(payload) {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sh = getOrCreateSheet(ss, SH_LOGS, COLS_LOGS);
  sh.appendRow([
    payload.id || ('log-' + Date.now()),
    payload.data_hora   || new Date().toLocaleString('pt-BR'),
    payload.usuario     || '', payload.acao        || '',
    payload.tabela      || '', payload.id_registro || '',
    payload.campo       || '', payload.antes       || '',
    payload.depois      || '', payload.obs         || ''
  ]);
  return { ok: true };
}

// ── upsertRow — insert ou update por id ──────────────────────
function upsertRow(sheetName, cols, payload) {
  const ss   = SpreadsheetApp.getActiveSpreadsheet();
  const sh   = getOrCreateSheet(ss, sheetName, cols);
  const data = sh.getDataRange().getValues();
  const hdr  = data[0].map(h => h.toString().trim());
  const iId  = hdr.indexOf('id');
  const row  = cols.map(c => (payload[c] !== undefined && payload[c] !== null) ? payload[c] : '');
  for (let r = 1; r < data.length; r++) {
    if (String(data[r][iId]) === String(payload.id)) {
      sh.getRange(r + 1, 1, 1, cols.length).setValues([row]);
      return { ok: true, action: 'updated' };
    }
  }
  sh.appendRow(row);
  return { ok: true, action: 'inserted' };
}

// ── readSheet ────────────────────────────────────────────────
function readSheet(ss, name, cols) {
  const sh = ss.getSheetByName(name);
  if (!sh) return [];
  const data = sh.getDataRange().getValues();
  if (data.length < 2) return [];
  const hdr = data[0].map(h => h.toString().trim());
  return data.slice(1)
    .filter(row => row.some(cell => cell !== '' && cell !== null))
    .map(row => {
      const obj = {};
      cols.forEach(col => {
        const ci = hdr.indexOf(col);
        const v  = ci >= 0 && row[ci] !== undefined ? row[ci] : '';
        obj[col] = v instanceof Date
          ? Utilities.formatDate(v, Session.getScriptTimeZone(), 'yyyy-MM-dd')
          : String(v);
      });
      return obj;
    });
}

// ── getOrCreateSheet ─────────────────────────────────────────
function getOrCreateSheet(ss, name, cols) {
  let sh = ss.getSheetByName(name);
  if (!sh) { sh = ss.insertSheet(name); sh.appendRow(cols); }
  return sh;
}

// ── rebuildSheet — apaga e recria aba com novos cabeçalhos ───
function rebuildSheet(ss, name, cols) {
  const old = ss.getSheetByName(name);
  if (old) ss.deleteSheet(old);
  const sh = ss.insertSheet(name);
  sh.appendRow(cols);
  return sh;
}

// ============================================================
// resetAndSeed() — EXECUTE UMA VEZ no editor GAS para migrar
// os dados demo para as planilhas.
// Menu: Executar → resetAndSeed
// ============================================================
function resetAndSeed() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();

  // ── Recria cabeçalhos corretos ────────────────────────────
  rebuildSheet(ss, SH_METAS,         COLS_METAS);
  rebuildSheet(ss, SH_METAS_MENSAIS, COLS_METAS_MENSAIS);
  rebuildSheet(ss, SH_PROJETOS,      COLS_PROJETOS);
  rebuildSheet(ss, SH_LOGS,          COLS_LOGS);

  // ── Metas ─────────────────────────────────────────────────
  const mSh = ss.getSheetByName(SH_METAS);
  [
    ['m-101-1','kpi-101','1.01',1,'Controle de Despesas Adm.','Manter despesas administrativas centrais dentro do orçamento aprovado','Daniel Benedetti','Fernando Medeiros','moeda','R$','Menor',0.6,'Ativa','','26/05/2025','TRUE'],
    ['m-101-2','kpi-101','1.01',2,'Índice de Satisfação Interna','Pesquisa de satisfação com serviços administrativos (NPS interno)','Daniel Benedetti','Fernando Medeiros','decimal','pontos','Maior',0.4,'Ativa','','15/03/2025','TRUE'],
    ['m-102-1','kpi-102','1.02',1,'Taxa de Turnover','Percentual de saídas voluntárias em relação ao quadro total','Gisele Carneiro','Fernando Medeiros','percentual','%','Menor',0.4,'Ativa','','30/04/2025','TRUE'],
    ['m-102-2','kpi-102','1.02',2,'Posições Preenchidas','Percentual de vagas preenchidas em relação ao headcount aprovado','Gisele Carneiro','Fernando Medeiros','percentual','%','Maior',0.6,'Ativa','Vagas de campo apresentam maior dificuldade','30/04/2025','TRUE'],
    ['m-301-1','kpi-301','3.01',1,'Despesas de Produção','Controle total de despesas operacionais da unidade produtiva de amêndoa','Roberto Barroso','Alcione Albanesi','moeda','R$','Menor',0.5,'Ativa','Impacto da alta do diesel e insumos no Q1','30/04/2025','TRUE'],
    ['m-301-2','kpi-301','3.01',2,'Custo Base Amêndoa','Custo unitário médio da base amêndoa (produção própria + compra)','Roberto Barroso','Alcione Albanesi','decimal','R$/kg','Menor',0.3,'Ativa','','30/04/2025','TRUE'],
    ['m-301-3','kpi-301','3.01',3,'Produção Total','Volume total de amêndoa produzida no período (meta de produção)','Roberto Barroso','Alcione Albanesi','numero_inteiro','kg','Maior',0.2,'Ativa','Safra impactada por estiagem em mar/abr','30/04/2025','TRUE'],
  ].forEach(r => mSh.appendRow(r));

  // ── Metas Mensais ─────────────────────────────────────────
  const mmSh = ss.getSheetByName(SH_METAS_MENSAIS);
  const mm = [
    // KPI 1.01 — Meta 1 (Despesas Adm)
    ['mm-101-1-1','m-101-1',2025,1,195000,182000,''],['mm-101-1-2','m-101-1',2025,2,195000,188000,''],
    ['mm-101-1-3','m-101-1',2025,3,195000,201000,''],['mm-101-1-4','m-101-1',2025,4,195000,178000,''],
    ['mm-101-1-5','m-101-1',2025,5,195000,'',''],['mm-101-1-6','m-101-1',2025,6,195000,'',''],
    ['mm-101-1-7','m-101-1',2025,7,195000,'',''],['mm-101-1-8','m-101-1',2025,8,195000,'',''],
    ['mm-101-1-9','m-101-1',2025,9,195000,'',''],['mm-101-1-10','m-101-1',2025,10,195000,'',''],
    ['mm-101-1-11','m-101-1',2025,11,195000,'',''],['mm-101-1-12','m-101-1',2025,12,195000,'',''],
    // KPI 1.01 — Meta 2 (Satisfação)
    ['mm-101-2-1','m-101-2',2025,1,7.5,'',''],['mm-101-2-2','m-101-2',2025,2,7.5,'',''],
    ['mm-101-2-3','m-101-2',2025,3,7.5,8.1,''],['mm-101-2-4','m-101-2',2025,4,7.5,'',''],
    ['mm-101-2-5','m-101-2',2025,5,7.5,'',''],['mm-101-2-6','m-101-2',2025,6,8.0,'',''],
    ['mm-101-2-7','m-101-2',2025,7,8.0,'',''],['mm-101-2-8','m-101-2',2025,8,8.0,'',''],
    ['mm-101-2-9','m-101-2',2025,9,8.0,'',''],['mm-101-2-10','m-101-2',2025,10,8.0,'',''],
    ['mm-101-2-11','m-101-2',2025,11,8.0,'',''],['mm-101-2-12','m-101-2',2025,12,8.0,'',''],
    // KPI 1.02 — Meta 1 (Turnover)
    ['mm-102-1-1','m-102-1',2025,1,0.02,0.018,''],['mm-102-1-2','m-102-1',2025,2,0.02,0.015,''],
    ['mm-102-1-3','m-102-1',2025,3,0.02,0.023,''],['mm-102-1-4','m-102-1',2025,4,0.02,0.019,''],
    ['mm-102-1-5','m-102-1',2025,5,0.02,'',''],['mm-102-1-6','m-102-1',2025,6,0.02,'',''],
    ['mm-102-1-7','m-102-1',2025,7,0.02,'',''],['mm-102-1-8','m-102-1',2025,8,0.02,'',''],
    ['mm-102-1-9','m-102-1',2025,9,0.02,'',''],['mm-102-1-10','m-102-1',2025,10,0.02,'',''],
    ['mm-102-1-11','m-102-1',2025,11,0.02,'',''],['mm-102-1-12','m-102-1',2025,12,0.02,'',''],
    // KPI 1.02 — Meta 2 (Posições)
    ['mm-102-2-1','m-102-2',2025,1,0.95,0.88,''],['mm-102-2-2','m-102-2',2025,2,0.95,0.91,''],
    ['mm-102-2-3','m-102-2',2025,3,0.95,0.89,''],['mm-102-2-4','m-102-2',2025,4,0.95,0.92,''],
    ['mm-102-2-5','m-102-2',2025,5,0.95,'',''],['mm-102-2-6','m-102-2',2025,6,0.95,'',''],
    ['mm-102-2-7','m-102-2',2025,7,0.95,'',''],['mm-102-2-8','m-102-2',2025,8,0.95,'',''],
    ['mm-102-2-9','m-102-2',2025,9,0.95,'',''],['mm-102-2-10','m-102-2',2025,10,0.95,'',''],
    ['mm-102-2-11','m-102-2',2025,11,0.95,'',''],['mm-102-2-12','m-102-2',2025,12,0.95,'',''],
    // KPI 3.01 — Meta 1 (Despesas Produção)
    ['mm-301-1-1','m-301-1',2025,1,2700000,2876890,''],['mm-301-1-2','m-301-1',2025,2,2100000,2339421,''],
    ['mm-301-1-3','m-301-1',2025,3,2500000,2687405,''],['mm-301-1-4','m-301-1',2025,4,2200000,2349045,''],
    ['mm-301-1-5','m-301-1',2025,5,2400000,'',''],['mm-301-1-6','m-301-1',2025,6,2300000,'',''],
    ['mm-301-1-7','m-301-1',2025,7,2400000,'',''],['mm-301-1-8','m-301-1',2025,8,2300000,'',''],
    ['mm-301-1-9','m-301-1',2025,9,2500000,'',''],['mm-301-1-10','m-301-1',2025,10,2600000,'',''],
    ['mm-301-1-11','m-301-1',2025,11,2700000,'',''],['mm-301-1-12','m-301-1',2025,12,2800000,'',''],
    // KPI 3.01 — Meta 2 (Custo Amêndoa)
    ['mm-301-2-1','m-301-2',2025,1,42.6,41.1,''],['mm-301-2-2','m-301-2',2025,2,42.6,41.7,''],
    ['mm-301-2-3','m-301-2',2025,3,42.6,42.3,''],['mm-301-2-4','m-301-2',2025,4,45.0,44.9,''],
    ['mm-301-2-5','m-301-2',2025,5,45.0,'',''],['mm-301-2-6','m-301-2',2025,6,45.0,'',''],
    ['mm-301-2-7','m-301-2',2025,7,45.0,'',''],['mm-301-2-8','m-301-2',2025,8,45.0,'',''],
    ['mm-301-2-9','m-301-2',2025,9,45.0,'',''],['mm-301-2-10','m-301-2',2025,10,45.0,'',''],
    ['mm-301-2-11','m-301-2',2025,11,45.0,'',''],['mm-301-2-12','m-301-2',2025,12,45.0,'',''],
    // KPI 3.01 — Meta 3 (Produção Total)
    ['mm-301-3-1','m-301-3',2025,1,25200,21509,''],['mm-301-3-2','m-301-3',2025,2,25200,16414,''],
    ['mm-301-3-3','m-301-3',2025,3,25200,15233,''],['mm-301-3-4','m-301-3',2025,4,25200,28879,''],
    ['mm-301-3-5','m-301-3',2025,5,26248,'',''],['mm-301-3-6','m-301-3',2025,6,26248,'',''],
    ['mm-301-3-7','m-301-3',2025,7,26248,'',''],['mm-301-3-8','m-301-3',2025,8,26248,'',''],
    ['mm-301-3-9','m-301-3',2025,9,26248,'',''],['mm-301-3-10','m-301-3',2025,10,26248,'',''],
    ['mm-301-3-11','m-301-3',2025,11,26248,'',''],['mm-301-3-12','m-301-3',2025,12,26248,'',''],
  ];
  mm.forEach(r => mmSh.appendRow(r));

  // ── Projetos ──────────────────────────────────────────────
  const pSh = ss.getSheetByName(SH_PROJETOS);
  [
    ['p-1','kpi-301','m-301-1','Redução de Custos Operacionais — Fase 1','Mapeamento e eliminação de desperdícios na linha de produção','Roberto Barroso','Em andamento','Alta','2025-06-30',45,'Reunião de alinhamento com equipe de produção','Filipe Dorneles','Negociação com fornecedor de diesel em andamento','TRUE','2025-01-15','2025-04-10','roberto.barroso@amigosdobem.org.br'],
    ['p-2','kpi-301','m-301-3','Expansão da Capacidade Produtiva — Sertão Norte','Implantação de novo módulo de beneficiamento','Roberto Barroso','Não iniciado','Média','2025-09-30',0,'Elaborar projeto executivo e solicitar orçamentos','Roberto Barroso','Aguardando aprovação orçamentária','TRUE','2025-02-01','2025-02-01','roberto.barroso@amigosdobem.org.br'],
    ['p-3','kpi-301','m-301-2','Otimização do Processo de Beneficiamento','Revisão do fluxo para reduzir perdas e custo unitário','Filipe Dorneles','Em andamento','Alta','2025-07-31',70,'Validar novo layout do galpão com engenharia','Edmilson Lima','Fase de testes concluída com resultado positivo','TRUE','2025-01-20','2025-04-25','roberto.barroso@amigosdobem.org.br'],
    ['p-4','kpi-101','m-101-1','Revisão de Contratos de Fornecedores Adm.','Renegociação dos principais contratos de serviços administrativos','Daniel Benedetti','Concluído','Alta','2025-03-31',100,'Monitorar execução dos novos contratos','Roberto Zambeli','Economia estimada de R$ 48 mil/ano','TRUE','2025-01-05','2025-03-28','daniel.benedetti@amigosdobem.org.br'],
    ['p-5','kpi-102','m-102-2','Banco de Talentos — Campo','Criação de banco de talentos para vagas operacionais no Sertão','Gisele Carneiro','Em andamento','Média','2025-08-31',30,'Publicar vagas nos canais regionais parceiros','Kathia Cruz','Parceria com SINE local em negociação','TRUE','2025-03-10','2025-04-15','gisele.carneiro@amigosdobem.org.br'],
  ].forEach(r => pSh.appendRow(r));

  Logger.log('✅ resetAndSeed concluído!');
  Logger.log('   Metas: 7 | Mensais: 84 | Projetos: 5');
  Logger.log('   Agora vá em Implantar → Gerenciar implantações → Editar → Nova versão → Implantar');
}

// ── initSheets — garante que todas as abas existem ───────────
function initSheets() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  getOrCreateSheet(ss, SH_USUARIOS,      COLS_USUARIOS);
  getOrCreateSheet(ss, SH_KPIS,          COLS_KPIS);
  getOrCreateSheet(ss, SH_METAS,         COLS_METAS);
  getOrCreateSheet(ss, SH_METAS_MENSAIS, COLS_METAS_MENSAIS);
  getOrCreateSheet(ss, SH_PROJETOS,      COLS_PROJETOS);
  getOrCreateSheet(ss, SH_LOGS,          COLS_LOGS);
  Logger.log('✅ Abas verificadas. ID da planilha: ' + ss.getId());
}

// ── testGetInitData ──────────────────────────────────────────
function testGetInitData() {
  const r = getInitData();
  Logger.log('Usuários:'  + r.usuarios.length + ' | Metas:' + r.metas.length +
             ' | Mensais:' + r.metasMensais.length + ' | Projetos:' + r.projetos.length);
}
