// Apre il sito con Chromium, trova home, una pagina prodotto e il carrello,
// e su ognuna esegue axe-core con le regole WCAG 2.1 A e AA.

import { createRequire } from 'node:module';
import { readFileSync } from 'node:fs';
import { chromium } from 'playwright';

const require = createRequire(import.meta.url);
const AXE = readFileSync(require.resolve('axe-core/axe.min.js'), 'utf8');

export const TAG_WCAG = ['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa'];
const MAX_SCREENSHOT_PER_PAGINA = 12;

export async function apriBrowser() {
  const executablePath = process.env.CHROMIUM_PATH || undefined;
  return chromium.launch({ executablePath });
}

export async function scansionaSito(browser, url, { soloHome = false, log = () => {} } = {}) {
  const home = normalizzaUrl(url);
  const context = await browser.newContext({
    viewport: { width: 1366, height: 900 },
    locale: 'it-IT',
    bypassCSP: true,
  });
  const page = await context.newPage();
  const pagine = [];
  let piattaforma = 'sconosciuta';

  try {
    log(`  home: ${home}`);
    await vaiA(page, home);
    piattaforma = await riconosciPiattaforma(page);
    pagine.push(await analizzaPagina(page, 'home'));

    if (!soloHome) {
      const origine = new URL(page.url()).origin;
      const carrello = (await trovaLinkCarrello(page, origine)) || carrelloPredefinito(piattaforma, origine);
      const prodotto = await trovaLinkProdotto(page, origine, log);

      for (const [tipo, link] of [['prodotto', prodotto], ['carrello', carrello]]) {
        if (!link) {
          log(`  ${tipo}: non trovato, salto`);
          continue;
        }
        log(`  ${tipo}: ${link}`);
        try {
          await vaiA(page, link);
          pagine.push(await analizzaPagina(page, tipo));
        } catch (e) {
          log(`  ${tipo}: errore (${e.message.split('\n')[0]})`);
        }
      }
    }
  } finally {
    await context.close();
  }

  return { url: home, dominio: new URL(home).hostname.replace(/^www\./, ''), piattaforma, pagine };
}

export function normalizzaUrl(url) {
  const u = /^https?:\/\//i.test(url) ? url : `https://${url}`;
  return new URL(u).href;
}

async function vaiA(page, url) {
  await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 45000 });
  // Lascia caricare immagini e script del tema, senza aspettare all'infinito i tracker.
  await page.waitForLoadState('networkidle', { timeout: 8000 }).catch(() => {});
}

async function analizzaPagina(page, tipo) {
  await page.addScriptTag({ content: AXE });
  const risultato = await page.evaluate(
    (tags) => window.axe.run(document, { runOnly: { type: 'tag', values: tags }, resultTypes: ['violations'] }),
    TAG_WCAG,
  );
  const violazioni = risultato.violations.map((v) => ({
    id: v.id,
    impact: v.impact,
    help: v.help,
    description: v.description,
    helpUrl: v.helpUrl,
    tags: v.tags,
    nodi: v.nodes.map((n) => ({
      target: n.target.map(String).join(' » '),
      // Se l'elemento è dentro un iframe axe restituisce più selettori: niente screenshot.
      selettore: n.target.length === 1 ? String(n.target[0]) : null,
      html: n.html.slice(0, 300),
      sintesi: n.failureSummary,
    })),
  }));

  // Uno screenshot del primo elemento di ogni problema, evidenziato in rosso.
  for (const v of violazioni.slice(0, MAX_SCREENSHOT_PER_PAGINA)) {
    v.screenshot = await screenshotElemento(page, v.nodi[0]?.selettore);
  }

  return { tipo, url: page.url(), titolo: await page.title(), violazioni };
}

async function screenshotElemento(page, selettore) {
  if (!selettore) return null;
  try {
    const el = page.locator(`css=${selettore}`).first();
    if (!(await el.isVisible({ timeout: 1000 }))) return null;
    await el.scrollIntoViewIfNeeded({ timeout: 2000 });
    const box = await el.boundingBox();
    const vp = page.viewportSize();
    // Elementi minuscoli o grandi quanto la pagina non danno uno screenshot leggibile.
    if (!box || box.width < 2 || box.height < 2 || box.width > vp.width * 0.8 || box.height > 350) return null;

    const margine = 60;
    const x = Math.max(0, box.x - margine);
    const y = Math.max(0, box.y - margine);
    const clip = {
      x,
      y,
      width: Math.min(box.width + margine * 2, vp.width - x),
      height: Math.min(box.height + margine * 2, vp.height - y),
    };
    await el.evaluate((n) => {
      n.dataset.a11yOutline = n.style.outline;
      n.style.outline = '4px solid #d0021b';
      n.style.outlineOffset = '4px';
    });
    try {
      return await page.screenshot({ clip, timeout: 5000 });
    } finally {
      await el.evaluate((n) => {
        n.style.outline = n.dataset.a11yOutline || '';
        delete n.dataset.a11yOutline;
      });
    }
  } catch {
    return null;
  }
}

async function riconosciPiattaforma(page) {
  return page.evaluate(() => {
    const generator = document.querySelector('meta[name="generator"]')?.content?.toLowerCase() ?? '';
    if (window.Shopify) return 'Shopify';
    if (document.body?.classList.contains('woocommerce') || document.querySelector('link[href*="woocommerce"],script[src*="woocommerce"]'))
      return 'WooCommerce';
    if (window.prestashop || generator.includes('prestashop')) return 'PrestaShop';
    if (document.querySelector('script[type="text/x-magento-init"]')) return 'Magento';
    if (generator.includes('wix')) return 'Wix';
    if (generator.includes('wordpress')) return 'WordPress';
    return 'sconosciuta';
  });
}

// Cerca un prodotto nella home; se non c'è, lo cerca nella prima categoria.
async function trovaLinkProdotto(page, origine, log) {
  const inHome = stessoSito(await page.evaluate(linkProdottoNellaPagina), origine);
  if (inHome) return inHome;
  const categoria = stessoSito(
    await page.evaluate(() => {
      const schema = /\/(collections|categoria|categorie|category|product-category|shop|negozio)(\/|$)/i;
      return [...document.querySelectorAll('a[href]')].find((a) => schema.test(new URL(a.href, location.href).pathname))?.href ?? null;
    }),
    origine,
  );
  if (!categoria) return null;
  try {
    await vaiA(page, categoria);
    return stessoSito(await page.evaluate(linkProdottoNellaPagina), origine);
  } catch (e) {
    log(`  categoria: errore (${e.message.split('\n')[0]})`);
    return null;
  }
}

function linkProdottoNellaPagina() {
  const schemi = [/\/products\/[^/?#]+/, /\/(product|prodotto|prodotti)\/[^/?#]+/, /\/\d+-[\w-]+\.html$/, /\/p\/[^/?#]+/];
  const links = [...document.querySelectorAll('a[href]')].map((a) => a.href);
  for (const s of schemi) {
    const trovato = links.find((h) => s.test(new URL(h, location.href).pathname));
    if (trovato) return trovato;
  }
  return document.querySelector('[class*="product"] a[href]')?.href ?? null;
}

async function trovaLinkCarrello(page, origine) {
  const link = await page.evaluate(() => {
    const a = [...document.querySelectorAll('a[href]')].find((el) =>
      /\/(cart|carrello|basket|checkout\/cart)\/?$/i.test(new URL(el.href, location.href).pathname),
    );
    return a?.href ?? null;
  });
  return stessoSito(link, origine);
}

function carrelloPredefinito(piattaforma, origine) {
  const percorsi = { Shopify: '/cart', WooCommerce: '/cart/', Magento: '/checkout/cart/', PrestaShop: '/carrello' };
  return percorsi[piattaforma] ? origine + percorsi[piattaforma] : null;
}

function stessoSito(link, origine) {
  if (!link) return null;
  try {
    const u = new URL(link);
    return u.origin === origine ? u.href : null;
  } catch {
    return null;
  }
}
