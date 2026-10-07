# Checklist manuale – audit completo

Da fare **dopo** il mini-check automatico, sul percorso home → prodotto → carrello → checkout.
Gli strumenti automatici trovano solo una parte dei problemi: questa verifica è quella che il cliente paga.

Strumenti: Chrome con axe DevTools e WAVE, Lighthouse, uno screen reader (NVDA su Windows, VoiceOver su Mac/iPhone).
Per ogni punto segna: ✅ ok · ❌ problema (con pagina, screenshot e passi per riprodurlo) · — non applicabile.

## 1. Solo tastiera (scollega il mouse)

| # | Controllo | WCAG | Esito | Note |
|---|---|---|---|---|
| 1.1 | Con Tab si raggiungono tutti i link, pulsanti e campi, in un ordine logico | 2.1.1, 2.4.3 | | |
| 1.2 | Si vede sempre dove si trova il focus (contorno visibile) | 2.4.7 | | |
| 1.3 | C'è un link "Salta al contenuto" o si arriva al contenuto senza 30 Tab | 2.4.1 | | |
| 1.4 | Menu e sottomenu si aprono e chiudono con Invio/Spazio/Esc | 2.1.1 | | |
| 1.5 | Banner cookie e popup newsletter si chiudono con la tastiera e il focus non resta intrappolato | 2.1.2 | | |
| 1.6 | Su prodotto: taglia, colore, quantità e "Aggiungi al carrello" funzionano da tastiera | 2.1.1 | | |
| 1.7 | Il carrello laterale (drawer) riceve il focus quando si apre e lo restituisce quando si chiude | 2.4.3 | | |
| 1.8 | Checkout completabile fino al pagamento senza mouse | 2.1.1 | | |
| 1.9 | Caroselli: si possono fermare e scorrere da tastiera | 2.2.2, 2.1.1 | | |

## 2. Screen reader

| # | Controllo | WCAG | Esito | Note |
|---|---|---|---|---|
| 2.1 | Il titolo della pagina dice dove sono | 2.4.2 | | |
| 2.2 | Titoli (H1, H2…) descrivono la struttura; c'è un solo H1 sensato | 1.3.1 | | |
| 2.3 | Le foto prodotto hanno una descrizione utile (non "IMG_1234") | 1.1.1 | | |
| 2.4 | Pulsanti icona (carrello, cerca, account, chiudi, preferiti) hanno un nome | 4.1.2 | | |
| 2.5 | Prezzo, prezzo scontato e disponibilità vengono letti in modo comprensibile | 1.3.1 | | |
| 2.6 | Aggiungendo al carrello viene annunciata la conferma | 4.1.3 | | |
| 2.7 | Ogni campo del checkout ha un'etichetta letta ad alta voce | 1.3.1, 3.3.2 | | |
| 2.8 | Gli errori nei form vengono annunciati e dicono come correggerli | 3.3.1, 3.3.3 | | |
| 2.9 | La lingua della pagina è italiana (pronuncia corretta) | 3.1.1 | | |

## 3. Vista e zoom

| # | Controllo | WCAG | Esito | Note |
|---|---|---|---|---|
| 3.1 | Zoom al 200%: nessun testo tagliato o sovrapposto | 1.4.4 | | |
| 3.2 | Larghezza 320 px (zoom 400%): niente scorrimento orizzontale | 1.4.10 | | |
| 3.3 | Contrasto testi ≥ 4.5:1, icone e bordi dei campi ≥ 3:1 | 1.4.3, 1.4.11 | | |
| 3.4 | Le informazioni non sono date solo dal colore (taglie esaurite, errori) | 1.4.1 | | |
| 3.5 | Su smartphone lo zoom con due dita funziona | 1.4.4 | | |
| 3.6 | Spaziatura testo aumentata (bookmarklet "text spacing"): nessun testo perso | 1.4.12 | | |
| 3.7 | Contenuti che appaiono al passaggio del mouse si possono chiudere e non spariscono | 1.4.13 | | |

## 4. Multimedia e tempo

| # | Controllo | WCAG | Esito | Note |
|---|---|---|---|---|
| 4.1 | I video hanno sottotitoli | 1.2.2 | | |
| 4.2 | Niente audio che parte da solo per più di 3 secondi | 1.4.2 | | |
| 4.3 | Timer (es. carrello che scade) avvisano e si possono estendere | 2.2.1 | | |
| 4.4 | Niente lampeggiamenti più di 3 volte al secondo | 2.3.1 | | |

## Regole di lavoro

- Mai sul sito live senza ok scritto del cliente: lavora su una copia del tema.
- Accesso come collaboratore (Shopify) o utente dedicato (WordPress), mai la password del titolare.
- Ogni correzione scritta con Claude va provata e ricontrollata riga per riga prima della consegna.
