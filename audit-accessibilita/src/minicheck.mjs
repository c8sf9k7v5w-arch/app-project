#!/usr/bin/env node
// Mini-check di accessibilità per e-commerce.
//
//   node src/minicheck.mjs negozio.it altro-negozio.com
//   node src/minicheck.mjs --lista aziende.csv
//
// Per ogni sito crea report/<dominio>/ con mini-report (PDF e Markdown),
// dettaglio tecnico, bozza del messaggio LinkedIn e i dati grezzi.

import { mkdirSync, writeFileSync, existsSync, appendFileSync, readFileSync } from 'node:fs';
import { join } from 'node:path';
import { parseArgs } from 'node:util';
import { apriBrowser, scansionaSito } from './scansione.mjs';
import {
  aggrega,
  miniReportMarkdown,
  miniReportHtml,
  dettaglioMarkdown,
  messaggioLinkedin,
  rigaCsv,
  INTESTAZIONE_CSV,
} from './report.mjs';

const { values: opz, positionals } = parseArgs({
  allowPositionals: true,
  options: {
    lista: { type: 'string', short: 'l' },
    out: { type: 'string', short: 'o', default: 'report' },
    nome: { type: 'string', short: 'n', default: process.env.AUDIT_NOME || 'Maurizio' },
    'solo-home': { type: 'boolean', default: false },
    'no-pdf': { type: 'boolean', default: false },
    help: { type: 'boolean', short: 'h' },
  },
});

if (opz.help || (!positionals.length && !opz.lista)) {
  console.log(`Uso:
  node src/minicheck.mjs <sito> [<sito> ...]
  node src/minicheck.mjs --lista aziende.csv

Opzioni:
  -l, --lista <file>  CSV con una colonna "sito" (o "url"), separatore ; o ,
  -o, --out <cartella> dove salvare i report (predefinito: report)
  -n, --nome <nome>   nome che firma report e messaggio (predefinito: Maurizio)
      --solo-home     controlla solo la home page
      --no-pdf        non generare il PDF`);
  process.exit(opz.help ? 0 : 1);
}

const siti = [...positionals, ...(opz.lista ? leggiLista(opz.lista) : [])];
mkdirSync(opz.out, { recursive: true });
const fileCsv = join(opz.out, 'riepilogo.csv');
if (!existsSync(fileCsv)) writeFileSync(fileCsv, INTESTAZIONE_CSV + '\n');

const browser = await apriBrowser();
let falliti = 0;
try {
  for (const [i, sito] of siti.entries()) {
    console.log(`[${i + 1}/${siti.length}] ${sito}`);
    try {
      await controlla(sito);
    } catch (e) {
      falliti++;
      console.log(`  ERRORE: ${e.message.split('\n')[0]}`);
    }
  }
} finally {
  await browser.close();
}
console.log(`\nFatto: ${siti.length - falliti} siti controllati, ${falliti} errori. Riepilogo in ${fileCsv}`);
process.exitCode = falliti ? 1 : 0;

async function controlla(sito) {
  const scansione = await scansionaSito(browser, sito, { soloHome: opz['solo-home'], log: console.log });
  const problemi = aggrega(scansione);
  const cartella = join(opz.out, scansione.dominio);
  mkdirSync(cartella, { recursive: true });

  const firma = { nome: opz.nome };
  writeFileSync(join(cartella, 'mini-report.md'), miniReportMarkdown(scansione, problemi, firma));
  writeFileSync(join(cartella, 'dettaglio-tecnico.md'), dettaglioMarkdown(scansione, problemi));
  writeFileSync(join(cartella, 'messaggio-linkedin.txt'), messaggioLinkedin(scansione, problemi, firma));
  writeFileSync(join(cartella, 'dati.json'), JSON.stringify(senzaImmagini(scansione), null, 2));
  problemi.slice(0, 3).forEach((v, i) => {
    if (v.screenshot) writeFileSync(join(cartella, `problema-${i + 1}.png`), v.screenshot);
  });

  if (!opz['no-pdf']) {
    const html = miniReportHtml(scansione, problemi, firma);
    writeFileSync(join(cartella, 'mini-report.html'), html);
    const page = await browser.newPage();
    await page.setContent(html, { waitUntil: 'load' });
    await page.pdf({ path: join(cartella, 'mini-report.pdf'), format: 'A4', printBackground: true });
    await page.close();
  }

  appendFileSync(fileCsv, rigaCsv(scansione, problemi) + '\n');
  const elenco = problemi.slice(0, 3).map((v, i) => `${i + 1}. ${v.spiegazione.titolo}`).join('  ');
  console.log(`  ${problemi.length} tipi di problema. ${elenco}`);
  console.log(`  → ${cartella}`);
}

function senzaImmagini(scansione) {
  return {
    ...scansione,
    pagine: scansione.pagine.map((p) => ({ ...p, violazioni: p.violazioni.map(({ screenshot, ...v }) => v) })),
  };
}

function leggiLista(file) {
  const righe = readFileSync(file, 'utf8').split(/\r?\n/).filter((r) => r.trim());
  const sep = righe[0].includes(';') ? ';' : ',';
  const intestazione = righe[0].split(sep).map((c) => c.trim().replace(/^"|"$/g, '').toLowerCase());
  const col = intestazione.findIndex((c) => c === 'sito' || c === 'url');
  if (col < 0) throw new Error(`${file}: manca una colonna "sito" o "url"`);
  return righe
    .slice(1)
    .map((r) => r.split(sep)[col]?.trim().replace(/^"|"$/g, ''))
    .filter(Boolean);
}
