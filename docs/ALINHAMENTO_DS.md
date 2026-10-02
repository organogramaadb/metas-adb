# Alinhamento ao Design System Amigos do Bem — Metas ADB (Gestão de Desempenho)

> Registro das decisões de identidade visual deste **aplicativo interno de gestão** em relação ao
> **Design System institucional** da Amigos do Bem (`adb-design-system`, rev. 25/09/2026).
> Última atualização: 02/10/2026.

## Contexto e princípio

O Design System (DS) foi escrito para o **site institucional público** (amigosdobem.org): sua "lei" é
composta por hero com foto, seções narrativas, botões de doação, faixa de urgência e coluna editorial.
O **Metas ADB é um painel interno de KPIs** (tabelas densas, cards de indicador, drill-down, formulários),
com necessidades diferentes. Por isso adotamos a **linguagem visual da marca** (cor de ação, fonte, ícones,
formas, superfícies quentes) **sem** adotar a composição de página institucional.

O próprio DS autoriza isso (vocabulário "PREFERIR": *"fuja do padrão só com um motivo concreto — e registre
o motivo"*). As divergências estão listadas e justificadas na seção final.

## O que foi alinhado ao DS (02/10/2026)

| Fase | Mudança | Referência no DS |
|---|---|---|
| **1. Superfícies quentes** | Fundos passam de cinza frio (`#f0f0f0/#fafafa`) para **branco/areia** (`--surface:#fff`, `--surface-2:#FAF7F1`, `--page-bg:#FAF5EE`); bordas `#ddd` → **`#ECE7DF`** (linha do DS). Sombras curtas → **difusas e suaves** (`0 6px 20px / 0 14px 36px`). | §3 (areia, sem cinza frio), §6.2 (sombras) |
| **2. Cor de ação laranja** | Cor de destaque/ação passa de preto para **laranja `#FF6B00`** (botão primário, nav ativo, realces). **Foco visível laranja** em tudo que é clicável; campos com **foco de borda laranja**. | §3.1 (laranja = ação), §7.11 (campos), §10.2 (foco) |
| **3. Tipografia** | Fonte do app passa de `Segoe UI/system-ui` para **Inter** (Montserrat carregada para uso em nav/formulários). | §4.1 (Inter + Montserrat) |
| **4. Ícones** | **Todos os emojis** usados como ícone foram substituídos por **Font Awesome Free (solid)** — menu, cards de status, pilares, botões, estados vazios. | §9.2 ("PROIBIDO emojis como ícone") |
| **5. Formas** | Botões primários em **pílula** (`999px`) com texto peso **800**; cards/painéis com cantos **mais suaves** (12–16px). | §6.1 (pílula, cantos arredondados) |

### Tokens de marca adicionados (`style.css :root`)

`--adb-orange #FF6B00` · `--adb-orange-dark #E65300` · `--adb-orange-soft #FFF1E7` · `--adb-orange-text #B84600`
(laranja acessível para texto) · `--adb-sand #FAF5EE` · `--adb-sand-dark #F3E6D4` · `--adb-line #ECE7DF` ·
`--adb-blue #0047BA` · `--adb-text #2B2B2B` · `--adb-muted #6B6B6B`.

### Dependências adicionadas (via CDN, no `<head>`)

- **Inter + Montserrat** (Google Fonts, carregamento não-bloqueante `media=print onload`).
- **Font Awesome Free** (cdnjs) — ícones `solid`.

## Divergências deliberadas (com motivo)

Pontos em que **não** seguimos o DS ao pé da letra, por serem incompatíveis com a natureza de um
painel de dados interno:

1. **Cores de status (verde / âmbar / vermelho).** O DS não tem vocabulário de *data-viz*; um painel de KPI
   depende dessas cores para sinalizar saúde (no alvo / atenção / crítico). **Mantidas.** O vermelho de erro
   segue próximo do `#F04438` do DS.
2. **Modo escuro.** O DS é claro/quente apenas (páginas públicas). O Metas ADB é ferramenta de uso prolongado;
   o modo escuro é uma **exceção de produtividade**, mantida como opção do usuário.
3. **Cantos de card 12–16px (não 28px).** Os 28px do DS são editoriais; em tabelas e cards densos de dados eles
   quebram a leitura. Usamos cantos suaves porém compactos.
4. **Sem hero / doação / faixa de urgência / tom de voz institucional.** São padrões de página pública; não se
   aplicam a uma ferramenta interna de gestão.
5. **Cabeçalho escuro (`#111`).** Barra superior neutra, padrão comum de dashboard. O DS reserva o laranja como
   destaque, não como fundo de grandes áreas — então a barra permanece neutra.
6. **Contraste do laranja.** O próprio DS reconhece que branco-sobre-laranja reprova WCAG AA (2,86:1). Seguimos a
   **regra provisória §3.4**: branco sobre laranja só em **botões de texto grande/pesado** (peso 800); para texto
   laranja pequeno usamos `#B84600` (passa AA).

## Escopo e reversão

- Mudanças apenas no **frontend** (`style.css`, `index.html`, `js/engine.js`, `js/app.js`, `js/api.js`).
- **Não** altera dados, cálculos, permissões ou backend.
- Reversível por `git revert` do commit de alinhamento (tag de backup criada no deploy).

## A definir com a Comunicação

- Confirmar a versão oficial do logotipo e eventual arquivo de marca (hoje usamos `assets/logo_adb.png`).
- Validar o tom novo `#B84600` para texto laranja (o DS marca como SUGESTÃO dependente da Comunicação).
- Caso a Comunicação prefira, migrar Font Awesome Free 6 → 7 (o DS cita a 7).
