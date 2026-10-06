# Farmacia Gerardini – sito demo

Sito statico (HTML, CSS, JS, nessuna dipendenza esterna) generato da `siti/_generator` sul modello della struttura del sito
della Farmacia Spadazzi (Home, La farmacia, Reparti, Servizi con prenotazione, Offerte, Farmacie di turno, Contatti),
con identità visiva propria: variante hero **centrata**, colori #4a2d5c / #d4952a,
font DM Serif Display + DM Sans (self-hosted, licenza SIL OFL).

Apri `index.html` nel browser per vederlo. Per pubblicarlo basta caricare la cartella su qualsiasi hosting statico.

## Dati usati (verificati il 06/10/2026)

| Campo | Valore | Fonte |
|---|---|---|
| Nome | Farmacia Gerardini | farmaciediturno.org |
| Ragione sociale (Ministero) | Gerardini Renata | open data Ministero della Salute |
| Codice Ministero | 9716 | open data Ministero della Salute |
| Indirizzo | Largo Damiano Chiesa, 7/A, 00136 Roma | Ministero / farmaciediturno.org |
| Quartiere / Municipio | Balduina / XIV | geocodifica OSM |
| Telefono | 06 35497546 | directory web |
| Email | farm.gerardini@tiscali.it | directory web |
| Coordinate | 41.9194636, 12.4368017 | Ministero / geocodifica |
| Orari | Lunedì 08:30 - 13:00 / 16:00 - 19:30; Martedì 08:30 - 13:00 / 16:00 - 19:30; Mercoledì 08:30 - 13:00 / 16:00 - 19:30; Giovedì 08:30 - 13:00 / 16:00 - 19:30; Venerdì 08:30 - 13:00 / 16:00 - 19:30; Sabato 08:30 - 13:00; Domenica Chiuso | farmaciediturno.org, settimana del 06/10/2026 |

Servizi mostrati (fonte: farmaciediturno.org (servizi dichiarati), directory web (omeopatia, erboristeria, cosmesi, articoli sanitari, veterinaria, noleggio bilance)):

- Elettrocardiogramma (ECG)
- Holter cardiaco
- Holter pressorio
- Prenotazioni CUP
- Vaccinazione antinfluenzale
- Supporto alla terapia
- Tampone rapido
- Test dello streptococco
- Screening del colon-retto
- Misurazione della pressione
- Noleggio bilance pesa-neonati **(da confermare)**

## Da confermare con il titolare

- [ ] **P.IVA** (nel footer è `[DA INSERIRE]`). Nell'open data del Ministero risulta **07642400589**: verificarla in visura.
- [ ] Titolare/i: Dott.ssa Renata Gerardini.
- [ ] Email (farm.gerardini@tiscali.it) e **numero WhatsApp**: senza numero il pulsante WhatsApp porta alla pagina contatti e il modulo di prenotazione invita a telefonare.
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
