// Trasforma il risultato della scansione in: mini-report per il titolare,
// elenco tecnico per lo sviluppatore, bozza del messaggio LinkedIn.

import { spiega, priorita, punteggio, impattoIt } from './regole.mjs';

const NOMI_PAGINA = { home: 'home page', prodotto: 'pagina prodotto', carrello: 'carrello' };
const IN_PAGINA = { home: 'in home page', prodotto: 'nella pagina prodotto', carrello: 'nel carrello' };
const ORDINE_IMPATTO = ['minor', 'moderate', 'serious', 'critical'];

// Unisce le violazioni delle varie pagine: una voce per regola.
export function aggrega(scansione) {
  const perRegola = new Map();
  for (const pagina of scansione.pagine) {
    for (const v of pagina.violazioni) {
      let voce = perRegola.get(v.id);
      if (!voce) {
        voce = { ...v, nodi: 0, pagine: [], esempi: [], screenshot: null, paginaScreenshot: null };
        perRegola.set(v.id, voce);
      }
      if (ORDINE_IMPATTO.indexOf(v.impact) > ORDINE_IMPATTO.indexOf(voce.impact)) voce.impact = v.impact;
      voce.nodi += v.nodi.length;
      voce.pagine.push(pagina.tipo);
      for (const n of v.nodi) {
        if (voce.esempi.length < 5) voce.esempi.push({ ...n, pagina: pagina.tipo });
      }
      if (!voce.screenshot && v.screenshot) {
        voce.screenshot = v.screenshot;
        voce.paginaScreenshot = pagina.tipo;
      }
    }
  }
  return [...perRegola.values()]
    .map((v) => ({ ...v, spiegazione: spiega(v), priorita: priorita(v), punteggio: punteggio(v) }))
    .sort((a, b) => b.punteggio - a.punteggio || b.nodi - a.nodi);
}

export function dove(v) {
  const pagine = v.pagine.map((p) => NOMI_PAGINA[p] ?? p).join(', ');
  return `${pagine} (${v.nodi} ${v.nodi === 1 ? 'elemento' : 'elementi'})`;
}

function data(d = new Date()) {
  return d.toLocaleDateString('it-IT', { day: 'numeric', month: 'long', year: 'numeric' });
}

function maiuscola(s) {
  return s.charAt(0).toUpperCase() + s.slice(1);
}

const NOTA_LIMITI =
  'Questo è un controllo automatico e parziale di alcune pagine pubbliche. Gli strumenti automatici ' +
  'trovano solo una parte dei problemi di accessibilità: per un quadro completo serve una verifica ' +
  'manuale con tastiera e screen reader su tutto il percorso d\'acquisto. Non è una valutazione legale ' +
  'né una certificazione di conformità.';

// Trasparenza sull'uso dell'AI e degli strumenti automatici (legge 132/2025).
function notaAi(nome) {
  return `Controllo svolto con strumenti automatici (axe-core) e il supporto dell'intelligenza artificiale; risultati verificati da ${nome}.`;
}

// ---------- Mini-report (per il titolare) ----------

export function miniReportMarkdown(scansione, problemi, { nome }) {
  const top = problemi.slice(0, 3);
  const righe = [
    `# Mini-check di accessibilità – ${scansione.dominio}`,
    '',
    `Data: ${data()} · Pagine controllate: ${scansione.pagine.map((p) => NOMI_PAGINA[p.tipo]).join(', ')}`,
    `Standard di riferimento: WCAG 2.1 livello AA (linee guida AgID)`,
    '',
  ];
  if (top.length === 0) {
    righe.push('Il controllo automatico non ha trovato violazioni WCAG 2.1 A/AA nelle pagine analizzate.', '');
  } else {
    righe.push(`## ${top.length === 1 ? 'Il problema principale' : `I ${top.length} problemi principali`}`, '');
    top.forEach((v, i) => {
      const s = v.spiegazione;
      righe.push(
        `### ${i + 1}. ${maiuscola(s.titolo)}`,
        '',
        `- **Perché conta:** ${s.perche}`,
        `- **Dove:** ${dove(v)}`,
        `- **Criterio WCAG:** ${s.wcag}`,
        `- **Come si corregge:** ${s.correzione}`,
        '',
      );
    });
    const altri = problemi.length - top.length;
    if (altri > 0) {
      righe.push(`Oltre a questi, il controllo ha segnalato altri ${altri} tipi di problemi.`, '');
    }
  }
  righe.push(
    '## Prossimo passo',
    '',
    'Un audit completo controlla tutto il percorso home → prodotto → carrello → checkout, anche a mano ' +
      'con tastiera e screen reader, e consegna un report con le priorità per il titolare e l\'elenco ' +
      'tecnico per lo sviluppatore.',
    '',
    `_${NOTA_LIMITI}_`,
    '',
    `${nome} – Audit di accessibilità per e-commerce`,
    '',
    `_${notaAi(nome)}_`,
    '',
  );
  return righe.join('\n');
}

export function miniReportHtml(scansione, problemi, { nome }) {
  const top = problemi.slice(0, 3);
  const altri = problemi.length - top.length;
  const blocchi = top
    .map((v, i) => {
      const s = v.spiegazione;
      const img = v.screenshot
        ? `<figure><img src="data:image/png;base64,${v.screenshot.toString('base64')}" alt="Esempio del problema evidenziato in rosso nella ${esc(
            NOMI_PAGINA[v.paginaScreenshot],
          )}"><figcaption>Esempio evidenziato in rosso (${esc(NOMI_PAGINA[v.paginaScreenshot])})</figcaption></figure>`
        : '';
      return `<section class="problema">
  <h2><span class="num">${i + 1}</span>${esc(maiuscola(s.titolo))}</h2>
  <dl>
    <dt>Perché conta</dt><dd>${esc(s.perche)}</dd>
    <dt>Dove</dt><dd>${esc(dove(v))}</dd>
    <dt>Criterio WCAG</dt><dd>${esc(s.wcag)}</dd>
    <dt>Come si corregge</dt><dd>${esc(s.correzione)}</dd>
  </dl>
  ${img}
</section>`;
    })
    .join('\n');

  return `<!doctype html>
<html lang="it">
<head>
<meta charset="utf-8">
<title>Mini-check di accessibilità – ${esc(scansione.dominio)}</title>
<style>
  @page { size: A4; margin: 16mm 16mm 18mm; }
  body { font: 11pt/1.5 -apple-system, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; color: #1a1a1a; margin: 0; }
  header { border-bottom: 3px solid #0b5cad; padding-bottom: 10px; margin-bottom: 18px; }
  h1 { font-size: 20pt; margin: 0 0 4px; color: #0b5cad; }
  .meta { color: #555; font-size: 9.5pt; }
  .problema { break-inside: avoid; margin: 0 0 18px; padding: 12px 14px; border: 1px solid #d6dbe1; border-radius: 6px; }
  .problema h2 { font-size: 13pt; margin: 0 0 8px; display: flex; gap: 10px; align-items: center; }
  .num { display: inline-grid; place-items: center; width: 24px; height: 24px; border-radius: 50%; background: #0b5cad; color: #fff; font-size: 11pt; }
  dl { display: grid; grid-template-columns: 130px 1fr; gap: 4px 12px; margin: 0; }
  dt { font-weight: 600; color: #333; }
  dd { margin: 0; }
  figure { margin: 10px 0 0; }
  figure img { max-width: 100%; max-height: 170px; border: 1px solid #ccc; }
  figcaption { font-size: 8.5pt; color: #555; }
  h3 { font-size: 12pt; margin: 22px 0 6px; }
  .nota { font-size: 8.5pt; color: #555; border-top: 1px solid #ddd; padding-top: 8px; margin-top: 18px; }
  footer { margin-top: 12px; font-weight: 600; }
</style>
</head>
<body>
<header>
  <h1>Mini-check di accessibilità</h1>
  <div class="meta"><strong>${esc(scansione.dominio)}</strong> · ${esc(data())} · Pagine controllate: ${esc(
    scansione.pagine.map((p) => NOMI_PAGINA[p.tipo]).join(', '),
  )} · Standard: WCAG 2.1 AA (linee guida AgID)</div>
</header>
${top.length ? blocchi : '<p>Il controllo automatico non ha trovato violazioni WCAG 2.1 A/AA nelle pagine analizzate.</p>'}
${altri > 0 ? `<p>Oltre a questi, il controllo ha segnalato altri <strong>${altri}</strong> tipi di problemi.</p>` : ''}
<h3>Prossimo passo</h3>
<p>Un audit completo controlla tutto il percorso home → prodotto → carrello → checkout, anche a mano con tastiera e screen reader, e consegna un report con le priorità per il titolare e l'elenco tecnico per lo sviluppatore.</p>
<p class="nota">${esc(NOTA_LIMITI)}</p>
<footer>${esc(nome)} – Audit di accessibilità per e-commerce</footer>
<p class="nota">${esc(notaAi(nome))}</p>
</body>
</html>`;
}

// ---------- Elenco tecnico (per lo sviluppatore / per te) ----------

export function dettaglioMarkdown(scansione, problemi) {
  const righe = [
    `# Dettaglio tecnico – ${scansione.dominio}`,
    '',
    `Piattaforma: ${scansione.piattaforma} · Data: ${data()}`,
    '',
    '| Pagina | URL |',
    '|---|---|',
    ...scansione.pagine.map((p) => `| ${NOMI_PAGINA[p.tipo]} | ${p.url} |`),
    '',
    '| Priorità | Problema | Impatto | WCAG | Dove |',
    '|---|---|---|---|---|',
    ...problemi.map(
      (v) => `| ${v.priorita} | ${v.spiegazione.titolo} (\`${v.id}\`) | ${impattoIt(v.impact)} | ${v.spiegazione.wcag} | ${dove(v)} |`,
    ),
    '',
  ];
  for (const v of problemi) {
    righe.push(
      `## ${maiuscola(v.spiegazione.titolo)} – \`${v.id}\``,
      '',
      `Priorità **${v.priorita}** · impatto ${impattoIt(v.impact)} · ${v.spiegazione.wcag} · [documentazione](${v.helpUrl})`,
      '',
      `Correzione: ${v.spiegazione.correzione}`,
      '',
      'Esempi:',
      '',
    );
    for (const e of v.esempi) {
      righe.push(`- ${NOMI_PAGINA[e.pagina]}: \`${e.target}\``, '  ```html', `  ${e.html.replace(/\s+/g, ' ')}`, '  ```');
    }
    righe.push('');
  }
  return righe.join('\n');
}

// ---------- Messaggio LinkedIn (bozza da ricontrollare) ----------

export function messaggioLinkedin(scansione, problemi, { nome }) {
  if (problemi.length === 0) {
    return 'Il controllo automatico non ha trovato problemi: non usare il messaggio standard per questo sito.\n';
  }
  const quanti = Math.min(3, problemi.length);
  const p1 = problemi[0];
  return (
    `Buongiorno [Nome], sono ${nome} e mi occupo di audit di accessibilità per e-commerce. ` +
    `Ho fatto un controllo veloce su ${scansione.dominio} e ho trovato ${quanti === 1 ? 'un problema' : `${quanti} problemi`} nel ` +
    `percorso d'acquisto che non ${quanti === 1 ? 'rispetta' : 'rispettano'} le WCAG 2.1 AA, lo standard delle linee guida AgID ` +
    `(per esempio ${p1.spiegazione.titolo} ${IN_PAGINA[p1.pagine[0]]}). ` +
    `Per gli e-commerce della vostra dimensione l'accessibilità è obbligatoria da giugno 2025. ` +
    `Le interessa se le mando il mini-report gratuito?\n`
  );
}

// ---------- Riga per il riepilogo CSV ----------

export const INTESTAZIONE_CSV = 'data;dominio;piattaforma;pagine;tipi_problema;elementi;problema_1;problema_2;problema_3';

export function rigaCsv(scansione, problemi) {
  const campi = [
    new Date().toISOString().slice(0, 10),
    scansione.dominio,
    scansione.piattaforma,
    scansione.pagine.map((p) => p.tipo).join('+'),
    problemi.length,
    problemi.reduce((t, v) => t + v.nodi, 0),
    ...[0, 1, 2].map((i) => problemi[i]?.spiegazione.titolo ?? ''),
  ];
  return campi.map((c) => String(c).replace(/[;\n]/g, ',')).join(';');
}

function esc(s) {
  return String(s ?? '').replace(/[&<>"]/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' })[c]);
}
