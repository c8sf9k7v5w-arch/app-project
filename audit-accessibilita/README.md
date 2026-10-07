# Audit di accessibilità per e-commerce

Strumento di lavoro per il **Piano 1** dei 30 giorni: trovare i problemi di accessibilità (WCAG 2.1 AA) negli e-commerce italiani, mandare un mini-report gratuito e trasformarlo in un audit pagato.

Non è un sito né un prodotto da vendere: è quello che usi tu ogni giorno per fare i **10 mini-check** della settimana 2 in pochi minuti.

## Cosa fa

Per ogni sito che gli dai:

1. apre la **home**, trova da solo una **pagina prodotto** e il **carrello** e riconosce la piattaforma (Shopify, WooCommerce, PrestaShop, Magento…);
2. su ogni pagina esegue **axe-core** (lo stesso motore di axe DevTools e Lighthouse) con le regole WCAG 2.1 A e AA;
3. sceglie i **3 problemi** più importanti per il percorso d'acquisto e li spiega in italiano semplice;
4. crea la cartella `report/<dominio>/` con:

| File | A cosa serve |
|---|---|
| `mini-report.pdf` | Il mini-report gratuito da mandare a chi risponde, con lo screenshot dei problemi evidenziati in rosso |
| `mini-report.md` | Lo stesso testo, da copiare o modificare |
| `messaggio-linkedin.txt` | La bozza del messaggio di contatto con il problema 1 già inserito |
| `dettaglio-tecnico.md` | Tutti i problemi con priorità alta/media/bassa, selettori CSS ed esempi di codice: la base per l'audit pagato |
| `problema-1.png` … | Gli screenshot, utili anche in chiamata |
| `dati.json` | I risultati grezzi di axe |

e aggiunge una riga a `report/riepilogo.csv` (data, dominio, piattaforma, problemi trovati), da incollare nel foglio dei contatti.

## Installazione (una volta sola)

Serve [Node.js](https://nodejs.org) 20 o più recente.

```bash
cd audit-accessibilita
npm install
npx playwright install chromium
```

## Uso

```bash
# uno o più siti
node src/minicheck.mjs negozio.it altronegozio.com

# tutti i siti della tua lista (colonna "sito" o "url", separatore ; o ,)
node src/minicheck.mjs --lista modelli/aziende.csv

# opzioni
node src/minicheck.mjs --help
```

| Opzione | Effetto |
|---|---|
| `--nome "Maurizio Rossi"` | Nome che firma mini-report e messaggio |
| `--out cartella` | Dove salvare i report (predefinito `report/`) |
| `--solo-home` | Controlla solo la home (più veloce) |
| `--no-pdf` | Salta il PDF |

Ogni sito richiede circa 20-40 secondi.

## La giornata tipo (settimana 2)

1. Scegli 10 aziende dalla lista (`modelli/aziende.csv`, colonna `obbligata` = sì).
2. `node src/minicheck.mjs --lista oggi.csv`
3. **Apri ogni mini-report e controllalo**: guarda il sito, verifica che i 3 problemi siano veri e comprensibili. Se un problema è dentro un'app di terze parti (cookie banner, chat), sceglierne un altro è spesso più convincente.
4. Copia `messaggio-linkedin.txt`, sostituisci `[Nome]` e mandalo su LinkedIn.
5. A chi risponde: manda `mini-report.pdf` e proponi una chiamata di 15 minuti.
6. La domenica aggiorna `modelli/numeri-settimanali.csv`.

## Modelli

| File | Quando |
|---|---|
| [`modelli/aziende.csv`](modelli/aziende.csv) | Giorni 6-7: lista dei 60 e-commerce, con verifica di dipendenti e fatturato, poi stato di ogni contatto |
| [`modelli/numeri-settimanali.csv`](modelli/numeri-settimanali.csv) | Ogni domenica: contatti, risposte, chiamate, preventivi, clienti |
| [`modelli/checklist-manuale.md`](modelli/checklist-manuale.md) | Settimana 4: prova con tastiera, screen reader e zoom su tutto il percorso d'acquisto |
| [`modelli/report-audit-completo.md`](modelli/report-audit-completo.md) | Settimana 4: il report dell'audit pagato (1 pagina per il titolare + elenco tecnico) |

## Limiti, da tenere sempre a mente

- Gli strumenti automatici trovano **solo una parte** dei problemi: l'audit pagato richiede sempre la checklist manuale.
- Il mini-check controlla il carrello **vuoto** e non entra nel checkout: quello lo fai a mano durante l'audit.
- Non promettere mai "conformità garantita" o "certificazione": il report lo dice esplicitamente, e la valutazione legale spetta al cliente e al suo avvocato.
- I widget di accessibilità ("overlay") non sono una soluzione: non proporli.
- Scansiona solo pagine pubbliche, a ritmo normale (un sito alla volta), senza fare acquisti né inserire dati.

## Sviluppo

```bash
npm test   # esegue il mini-check su un negozio di prova con errori noti (test/sito-prova)
```

- `src/scansione.mjs` – apertura del sito, ricerca di prodotto e carrello, esecuzione di axe
- `src/regole.mjs` – spiegazioni in italiano delle regole e calcolo della priorità
- `src/report.mjs` – mini-report, dettaglio tecnico, messaggio LinkedIn, riga CSV
- `src/minicheck.mjs` – comando da terminale

Per aggiungere la spiegazione italiana di una regola nuova, aggiungi una voce in `src/regole.mjs` con l'id di axe (lo trovi in `dettaglio-tecnico.md`). Se Chromium è installato altrove, indica il percorso con la variabile `CHROMIUM_PATH`.
