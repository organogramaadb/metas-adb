// ============================================================
// METAS ADB — Google Apps Script Backend v1.0
// Publicar como: Web App → Qualquer pessoa → Execute como: Eu
// ============================================================

// ── Nomes das abas ──────────────────────────────────────────
const SH_USUARIOS      = 'usuarios';
const SH_KPIS          = 'kpis';
const SH_METAS         = 'metas';
const SH_METAS_MENSAIS = 'metas_mensais';
const SH_PROJETOS      = 'projetos';
const SH_LOGS          = 'logs';

// ── Colunas de cada aba (ordem deve bater com a planilha) ───
const COLS_USUARIOS = [
  'email','nome','perfil','responsavel','senha','ativo'
];
const COLS_KPIS = [
  'id','nome','area','responsavel','peso_total','ativo'
];
const COLS_METAS = [
  'id','id_kpi','nome','metrica','tipo','unidade','bom_quando','peso','ativo'
];
const COLS_METAS_MENSAIS = [
  'id','id_meta','ano','mes','valor_meta','valor_realizado','obs'
];
const COLS_PROJETOS = [
  'id','id_kpi','id_meta','nome','descricao','responsavel',
  'status','prioridade','prazo','percentual_evolucao','proxima_acao','responsavel_acao','obs',
  'ativo','data_criacao','data_atualizacao','usuario_atualizacao'
];
const COLS_LOGS = [
  'id','data_hora','usuario','acao','tabela',
  'id_registro','campo','antes','depois','obs'
];

// ── jsonResp ────────────────────────────────────────────────
function jsonResp(data) {
  return ContentService.createTextOutput(JSON.stringify(data))
    .setMimeType(ContentService.MimeType.JSON);
}

// ── doGet — leitura ─────────────────────────────────────────
function doGet(e) {
  const action = (e.parameter || {}).action || '';

  try {
    if (action === 'getInitData') return jsonResp(getInitData());
    if (action === 'ping')        return jsonResp({ ok: true, ts: new Date().toISOString() });
    return jsonResp({ ok: true, version: '1.0', ts: new Date().toISOString() });
  } catch (err) {
    return jsonResp({ error: err.message });
  }
}

// ── doPost — escrita ────────────────────────────────────────
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
    if (action === 'addLog')         return jsonResp(addLog(body.payload));
    return jsonResp({ error: 'Ação desconhecida: ' + action });
  } catch (err) {
    return jsonResp({ error: err.message });
  }
}

// ── getInitData — carrega tudo de uma vez ───────────────────
function getInitData() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();

  const rawUsuarios    = readSheet(ss, SH_USUARIOS,      COLS_USUARIOS);
  const rawKpis        = readSheet(ss, SH_KPIS,          COLS_KPIS);
  const rawMetas       = readSheet(ss, SH_METAS,         COLS_METAS);
  const rawMensais     = readSheet(ss, SH_METAS_MENSAIS, COLS_METAS_MENSAIS);
  const rawProjetos    = readSheet(ss, SH_PROJETOS,      COLS_PROJETOS);
  const rawLogs        = readSheet(ss, SH_LOGS,          COLS_LOGS);

  // Normaliza tipos
  const usuarios = rawUsuarios.map(u => ({
    ...u,
    ativo: u.ativo === 'true' || u.ativo === true || u.ativo === 'TRUE'
  }));

  const kpis = rawKpis.map(k => ({
    ...k,
    peso_total: parseFloat(k.peso_total) || 1,
    ativo:      k.ativo === 'true' || k.ativo === true || k.ativo === 'TRUE'
  }));

  const metas = rawMetas.map(m => ({
    ...m,
    peso:  parseFloat(m.peso) || 0,
    ativo: m.ativo === 'true' || m.ativo === true || m.ativo === 'TRUE'
  }));

  const metasMensais = rawMensais.map(r => ({
    ...r,
    ano:              parseInt(r.ano) || 2025,
    mes:              parseInt(r.mes) || 1,
    valor_meta:       r.valor_meta       !== '' ? parseFloat(r.valor_meta)       : null,
    valor_realizado:  r.valor_realizado  !== '' ? parseFloat(r.valor_realizado)  : null
  }));

  const projetos = rawProjetos.map(p => ({
    ...p,
    progresso: parseFloat(p.progresso) || 0
  }));

  // Logs mais recentes primeiro, limite de 200
  const logs = rawLogs.reverse().slice(0, 200);

  return { usuarios, kpis, metas, metasMensais, projetos, logs };
}

// ── authenticate — valida login ─────────────────────────────
function authenticate(payload) {
  if (!payload || !payload.email || !payload.senha) {
    return { error: 'Email e senha obrigatórios' };
  }
  const ss    = SpreadsheetApp.getActiveSpreadsheet();
  const users = readSheet(ss, SH_USUARIOS, COLS_USUARIOS);
  const u = users.find(x =>
    x.email.toLowerCase() === payload.email.toLowerCase() &&
    x.senha === payload.senha &&
    (x.ativo === 'true' || x.ativo === true || x.ativo === 'TRUE')
  );
  if (!u) return { error: 'Credenciais inválidas' };
  // Nunca devolve a senha
  const { senha, ...safe } = u;
  return { ok: true, usuario: { ...safe, ativo: true } };
}

// ── saveMeta — atualiza metadados de uma meta ───────────────
function saveMeta(payload) {
  if (!payload || !payload.id) return { error: 'id obrigatório' };

  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sh = getOrCreateSheet(ss, SH_METAS, COLS_METAS);

  const data = sh.getDataRange().getValues();
  const hdr  = data[0].map(h => h.toString().trim());
  const iId  = hdr.indexOf('id');

  const rowData = COLS_METAS.map(col =>
    payload[col] !== undefined ? payload[col] : ''
  );

  for (let r = 1; r < data.length; r++) {
    if (String(data[r][iId]) === String(payload.id)) {
      sh.getRange(r + 1, 1, 1, COLS_METAS.length).setValues([rowData]);
      return { ok: true, action: 'updated' };
    }
  }
  sh.appendRow(rowData);
  return { ok: true, action: 'inserted' };
}

// ── saveMetaMensal — atualiza valor mensal ──────────────────
function saveMetaMensal(payload) {
  if (!payload || !payload.id) return { error: 'id obrigatório' };

  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sh = getOrCreateSheet(ss, SH_METAS_MENSAIS, COLS_METAS_MENSAIS);

  const data = sh.getDataRange().getValues();
  const hdr  = data[0].map(h => h.toString().trim());
  const iId  = hdr.indexOf('id');

  const rowData = COLS_METAS_MENSAIS.map(col => {
    const v = payload[col];
    return (v !== undefined && v !== null) ? v : '';
  });

  for (let r = 1; r < data.length; r++) {
    if (String(data[r][iId]) === String(payload.id)) {
      sh.getRange(r + 1, 1, 1, COLS_METAS_MENSAIS.length).setValues([rowData]);
      return { ok: true, action: 'updated' };
    }
  }
  sh.appendRow(rowData);
  return { ok: true, action: 'inserted' };
}

// ── saveProject — cria ou atualiza projeto ──────────────────
function saveProject(payload) {
  if (!payload || !payload.id) return { error: 'id obrigatório' };

  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sh = getOrCreateSheet(ss, SH_PROJETOS, COLS_PROJETOS);

  const data = sh.getDataRange().getValues();
  const hdr  = data[0].map(h => h.toString().trim());
  const iId  = hdr.indexOf('id');

  const rowData = COLS_PROJETOS.map(col =>
    payload[col] !== undefined ? payload[col] : ''
  );

  for (let r = 1; r < data.length; r++) {
    if (String(data[r][iId]) === String(payload.id)) {
      sh.getRange(r + 1, 1, 1, COLS_PROJETOS.length).setValues([rowData]);
      return { ok: true, action: 'updated' };
    }
  }
  sh.appendRow(rowData);
  return { ok: true, action: 'inserted' };
}

// ── deleteProject — remove linha de projeto ─────────────────
function deleteProject(payload) {
  if (!payload || !payload.id) return { error: 'id obrigatório' };

  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sh = ss.getSheetByName(SH_PROJETOS);
  if (!sh) return { error: 'Aba projetos não encontrada' };

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

// ── addLog — registra auditoria ─────────────────────────────
function addLog(payload) {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sh = getOrCreateSheet(ss, SH_LOGS, COLS_LOGS);

  const rowData = [
    payload.id          || ('log-' + Date.now()),
    payload.data_hora   || new Date().toLocaleString('pt-BR'),
    payload.usuario     || '',
    payload.acao        || '',
    payload.tabela      || '',
    payload.id_registro || '',
    payload.campo       || '',
    payload.antes       || '',
    payload.depois      || '',
    payload.obs         || ''
  ];
  sh.appendRow(rowData);
  return { ok: true };
}

// ── readSheet — lê aba e retorna objetos ────────────────────
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
        const raw = ci >= 0 && row[ci] !== undefined ? row[ci] : '';
        obj[col] = raw instanceof Date
          ? Utilities.formatDate(raw, Session.getScriptTimeZone(), 'yyyy-MM-dd')
          : String(raw);
      });
      return obj;
    });
}

// ── getOrCreateSheet — garante que a aba existe ─────────────
function getOrCreateSheet(ss, name, cols) {
  let sh = ss.getSheetByName(name);
  if (!sh) {
    sh = ss.insertSheet(name);
    sh.appendRow(cols);
  }
  return sh;
}

// ============================================================
// initSheets() — execute UMA VEZ no editor para criar as abas
// Menu: Executar → initSheets
// ============================================================
function initSheets() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();

  // usuarios
  let sh = getOrCreateSheet(ss, SH_USUARIOS, COLS_USUARIOS);
  if (sh.getLastRow() <= 1) {
    const users = [
      ['admin@amigosdobem.org.br',            'Administrador',         'Admin',       'Administrador',     'admin', 'true'],
      ['daniel.benedetti@amigosdobem.org.br', 'Daniel Benedetti',      'Admin',       'Daniel Benedetti',  'admin', 'true'],
      ['roberto.barroso@amigosdobem.org.br',  'Roberto Barroso',       'Responsavel', 'Roberto Zambeli',   'admin', 'true'],
      ['gisele.carneiro@amigosdobem.org.br',  'Gisele Carneiro',       'Responsavel', 'Gisele Carneiro',   'admin', 'true'],
      ['alceu.caldeira@amigosdobem.org.br',   'Alceu Caldeira',        'DiretorN1',   'Alceu Caldeira',    'admin', 'true'],
    ];
    users.forEach(u => sh.appendRow(u));
  }

  // kpis
  sh = getOrCreateSheet(ss, SH_KPIS, COLS_KPIS);
  if (sh.getLastRow() <= 1) {
    const kpis = [
      ['1.01','Gestão Administrativa','Administrativo','Daniel Benedetti',1,true],
      ['1.02','Gestão de Pessoas','Administrativo','Gisele Carneiro',1,true],
      ['1.03','Tecnologia','Administrativo','Roberto Zambeli',1,true],
      ['1.04','Jurídico','Administrativo','Roberto Zambeli',1,true],
      ['1.05','Comunicação','Administrativo','Daniel Benedetti',1,true],
      ['1.07','Segurança','Administrativo','Alexandre Carrega',1,true],
      ['2.01','Educação','Educação','Alceu Caldeira',1,true],
      ['3.01','Área Produtiva','Produção','Roberto Barroso',1,true],
      ['4.01','Investimentos Sociais','Investimentos','Daniel Benedetti',1,true],
      ['5.02','Programas Sociais','Social','Daniel Benedetti',1,true],
    ];
    kpis.forEach(k => sh.appendRow(k));
  }

  // metas (cabeçalho apenas — dados virão da migração)
  getOrCreateSheet(ss, SH_METAS, COLS_METAS);

  // metas_mensais
  getOrCreateSheet(ss, SH_METAS_MENSAIS, COLS_METAS_MENSAIS);

  // projetos (cabeçalho apenas — dados virão da migração)
  getOrCreateSheet(ss, SH_PROJETOS, COLS_PROJETOS);

  // logs
  getOrCreateSheet(ss, SH_LOGS, COLS_LOGS);

  Logger.log('✅ Abas criadas/verificadas com sucesso!');
  Logger.log('Planilha: ' + ss.getId());
}

// ── testGetInitData — para testar no editor GAS ─────────────
function testGetInitData() {
  const result = getInitData();
  Logger.log('Usuários: '  + result.usuarios.length);
  Logger.log('KPIs: '      + result.kpis.length);
  Logger.log('Metas: '     + result.metas.length);
  Logger.log('Mensais: '   + result.metasMensais.length);
  Logger.log('Projetos: '  + result.projetos.length);
  Logger.log('Logs: '      + result.logs.length);
}
