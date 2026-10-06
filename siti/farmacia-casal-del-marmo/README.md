# Farmacia Casal del Marmo – sito demo

Sito statico (HTML, CSS, JS, nessuna dipendenza esterna) generato da `siti/_generator` sul modello della struttura del sito
della Farmacia Spadazzi (Home, La farmacia, Reparti, Servizi con prenotazione, Offerte, Farmacie di turno, Contatti),
con identità visiva propria: variante hero **fascia**, colori #0b5a87 / #f2b134,
font Outfit + Nunito Sans (self-hosted, licenza SIL OFL).

Apri `index.html` nel browser per vederlo. Per pubblicarlo basta caricare la cartella su qualsiasi hosting statico.

## Dati usati (verificati il 06/10/2026)

| Campo | Valore | Fonte |
|---|---|---|
| Nome | Farmacia Casal del Marmo | farmaciediturno.org |
| Ragione sociale (Ministero) | Farmacia Casal del Marmo | open data Ministero della Salute |
| Codice Ministero | 19872 | open data Ministero della Salute |
| Indirizzo | Via di Casal del Marmo, 201/203/205, 00135 Roma | Ministero / farmaciediturno.org |
| Quartiere / Municipio | Casal del Marmo / XIV | geocodifica OSM |
| Telefono | 06 30816169 | directory web |
| Email | n.d. | directory web |
| Coordinate | 41.9583656, 12.4120573 | Ministero / geocodifica |
| Orari | Lunedì 08:30 - 20:30; Martedì 08:30 - 20:30; Mercoledì 08:30 - 20:30; Giovedì 08:30 - 20:30; Venerdì 08:00 - 20:30; Sabato 08:30 - 20:30; Domenica Chiuso | farmaciediturno.org, settimana del 06/10/2026 |

Servizi mostrati (fonte: farmaciediturno.org (tampone), directory web (pressione, veterinaria, galenica, senza glutine, cosmetica, omeopatia). ECG/holter/CUP risultano sulla scheda della sede di Via Gaverina 10 (stessa titolarità): da confermare):

- Misurazione della pressione
- Tampone rapido
- Preparazioni galeniche
- Consegna a domicilio **(da confermare)**
- Elettrocardiogramma (ECG) **(da confermare)**
- Holter cardiaco **(da confermare)**
- Prenotazioni CUP **(da confermare)**

## Da confermare con il titolare

- [ ] **P.IVA** (nel footer è `[DA INSERIRE]`). Nell'open data del Ministero risulta **14076491001**: verificarla in visura.
- [ ] Titolare/i: Dott. Andrea Cerullo.
- [ ] Email e **numero WhatsApp**: senza numero il pulsante WhatsApp porta alla pagina contatti e il modulo di prenotazione invita a telefonare.
- [ ] Servizi segnati "da confermare", tempi e costi dei servizi.
- [ ] Testi "Chi siamo", team e foto (oggi il sito non usa foto: vanno aggiunte quelle reali della farmacia).
- [ ] Servizio "Ordina e passa a ritirare".
- [ ] Offerte del mese e marchi trattati.
- [ ] Privacy e cookie policy: testo base da far rivedere al consulente privacy.
- [ ] Dominio: quando c'è, aggiungere `<link rel="canonical">`, `url` nei dati strutturati, `sitemap.xml` e la scheda Google Business Profile.
- [ ] Nell'open data del Ministero risulta attiva anche una sede in **Via Gaverina 10** (cod. 9117) con la stessa titolarità: chiarire se esistono due farmacie o se è un trasferimento non ancora aggiornato.

## Note tecniche

- Dati strutturati schema.org `Pharmacy` (indirizzo, coordinate, orari, servizi) nella home.
- Stato "Aperto ora / Chiuso ora" e orario di oggi calcolati nel browser sull'ora di Roma.
- La mappa OpenStreetMap si carica solo su richiesta: nessun contenuto di terze parti senza un'azione dell'utente, quindi nessun banner cookie necessario.
- Pulsanti fissi "Chiama / WhatsApp / Prenota" su smartphone.
