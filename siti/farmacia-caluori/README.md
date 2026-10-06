# Farmacia Caluori – sito demo

Sito statico (HTML, CSS, JS, nessuna dipendenza esterna) generato da `siti/_generator` sul modello della struttura del sito
della Farmacia Spadazzi (Home, La farmacia, Reparti, Servizi con prenotazione, Offerte, Farmacie di turno, Contatti),
con identità visiva propria: variante hero **split**, colori #1d2f4d / #e2572f,
font Fraunces + Inter (self-hosted, licenza SIL OFL).

Apri `index.html` nel browser per vederlo. Per pubblicarlo basta caricare la cartella su qualsiasi hosting statico.

## Dati usati (verificati il 06/10/2026)

| Campo | Valore | Fonte |
|---|---|---|
| Nome | Farmacia Caluori | farmaciediturno.org |
| Ragione sociale (Ministero) | Caluori S.n.c. di Lucia e Carla Caluori | open data Ministero della Salute |
| Codice Ministero | 9168 | open data Ministero della Salute |
| Indirizzo | Piazzale delle Province, 8/A, 00162 Roma | Ministero / farmaciediturno.org |
| Quartiere / Municipio | Nomentano / II | geocodifica OSM |
| Telefono | 06 44244761 | directory web |
| Email | n.d. | directory web |
| Coordinate | 41.9096282, 12.5214626 | Ministero / geocodifica |
| Orari | Lunedì 08:00 - 20:00; Martedì 08:00 - 20:00; Mercoledì 08:00 - 20:00; Giovedì 08:00 - 20:00; Venerdì 08:00 - 20:00; Sabato 08:30 - 13:00 / 16:00 - 20:00; Domenica Chiuso | farmaciediturno.org, settimana del 06/10/2026 |

Servizi mostrati (fonte: farmaciediturno.org (servizi dichiarati), directory web (foratura lobi, intolleranze, omeopatia, veterinaria, celiachia)):

- Elettrocardiogramma (ECG)
- Holter cardiaco
- Holter pressorio
- Prenotazioni CUP
- Spirometria
- Autoanalisi del sangue
- Test per intolleranze alimentari **(da confermare)**
- Misurazione della pressione
- Tampone rapido
- Test dello streptococco
- Screening del colon-retto
- Test per infezioni urinarie
- Foratura dei lobi **(da confermare)**

## Da confermare con il titolare

- [ ] **P.IVA** (nel footer è `[DA INSERIRE]`). Nell'open data del Ministero risulta **05908751000**: verificarla in visura.
- [ ] Titolare/i: Dott.sse Lucia e Carla Caluori e anno di apertura 1985.
- [ ] Email e **numero WhatsApp**: senza numero il pulsante WhatsApp porta alla pagina contatti e il modulo di prenotazione invita a telefonare.
- [ ] Servizi segnati "da confermare", tempi e costi dei servizi.
- [ ] Testi "Chi siamo", team e foto (oggi il sito non usa foto: vanno aggiunte quelle reali della farmacia).
- [ ] Servizio "Ordina e passa a ritirare".
- [ ] Offerte del mese e marchi trattati.
- [ ] Privacy e cookie policy: testo base da far rivedere al consulente privacy.
- [ ] Dominio: quando c'è, aggiungere `<link rel="canonical">`, `url` nei dati strutturati, `sitemap.xml` e la scheda Google Business Profile.

## Note tecniche

- Dati strutturati schema.org `Pharmacy` (indirizzo, coordinate, orari, servizi) nella home.
- Stato "Aperto ora / Chiuso ora" e orario di oggi calcolati nel browser sull'ora di Roma.
- La mappa OpenStreetMap si carica solo su richiesta: nessun contenuto di terze parti senza un'azione dell'utente, quindi nessun banner cookie necessario.
- Pulsanti fissi "Chiama / WhatsApp / Prenota" su smartphone.
