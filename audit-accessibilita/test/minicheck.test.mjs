// Esegue il mini-check sul negozio di prova in test/sito-prova,
// che contiene errori noti, e controlla report e messaggio.

import { test, before, after } from 'node:test';
import assert from 'node:assert/strict';
import { createServer } from 'node:http';
import { readFile, stat } from 'node:fs/promises';
import { join, extname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { apriBrowser, scansionaSito } from '../src/scansione.mjs';
import { aggrega, miniReportMarkdown, messaggioLinkedin, rigaCsv } from '../src/report.mjs';

const radice = fileURLToPath(new URL('./sito-prova/', import.meta.url));
let server, browser, base;

before(async () => {
  server = createServer(async (req, res) => {
    let file = join(radice, decodeURIComponent(new URL(req.url, 'http://x').pathname));
    if ((await stat(file).catch(() => null))?.isDirectory()) file = join(file, 'index.html');
    const corpo = await readFile(file).catch(() => null);
    if (!corpo) return res.writeHead(404).end();
    res.writeHead(200, { 'content-type': extname(file) === '.html' ? 'text/html; charset=utf-8' : 'application/octet-stream' });
    res.end(corpo);
  });
  await new Promise((r) => server.listen(0, '127.0.0.1', r));
  base = `http://127.0.0.1:${server.address().port}/`;
  browser = await apriBrowser();
});

after(async () => {
  await browser?.close();
  server?.close();
});

test('trova home, prodotto e carrello e riconosce Shopify', async () => {
  const s = await scansionaSito(browser, base);
  assert.equal(s.piattaforma, 'Shopify');
  assert.deepEqual(s.pagine.map((p) => p.tipo), ['home', 'prodotto', 'carrello']);
});

test('individua gli errori inseriti nel negozio di prova', async () => {
  const problemi = aggrega(await scansionaSito(browser, base));
  const id = problemi.map((v) => v.id);
  for (const atteso of ['image-alt', 'button-name', 'select-name', 'color-contrast', 'html-has-lang', 'meta-viewport', 'autocomplete-valid']) {
    assert.ok(id.includes(atteso), `manca ${atteso}`);
  }
  // I primi tre sono problemi gravi sul percorso d'acquisto.
  assert.ok(problemi.slice(0, 3).every((v) => ['critical', 'serious'].includes(v.impact)));
  assert.equal(problemi.find((v) => v.id === 'image-alt').priorita, 'alta');
});

test('mini-report, messaggio e CSV sono in italiano e senza promesse di conformità', async () => {
  const s = await scansionaSito(browser, base);
  const problemi = aggrega(s);
  const md = miniReportMarkdown(s, problemi, { nome: 'Maurizio' });
  assert.match(md, /I 3 problemi principali/);
  assert.match(md, /Non è una valutazione legale né una certificazione/);
  assert.doesNotMatch(md, /conformità garantita/i);

  const msg = messaggioLinkedin(s, problemi, { nome: 'Maurizio' });
  assert.match(msg, /ho trovato 3 problemi/);
  assert.match(msg, /per esempio immagini senza testo alternativo in home page/);

  assert.equal(rigaCsv(s, problemi).split(';').length, 9);
});
