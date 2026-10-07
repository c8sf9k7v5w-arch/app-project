# Audit di accessibilità – [Nome negozio]

[Dominio] · Data: [gg mese aaaa] · Versione 1.0
Preparato da: Maurizio – Audit di accessibilità per e-commerce
Standard di riferimento: WCAG 2.1 livello AA (linee guida AgID)

---

## 1. Sintesi per il titolare (1 pagina)

**Cosa abbiamo controllato.** Il percorso d'acquisto: home → [categoria] → [prodotto] → carrello → checkout, su computer e smartphone, con strumenti automatici e prove manuali con tastiera e screen reader.

**Risultato in breve.** Abbiamo trovato **[N] problemi**: [N] a priorità alta, [N] media, [N] bassa.
I più importanti impediscono a [chi] di [cosa], per esempio [esempio concreto: "chi naviga con la tastiera non riesce a scegliere la taglia"].

| Priorità | Quanti | Cosa significa |
|---|---|---|
| Alta | [N] | Bloccano l'acquisto per alcune persone: da correggere subito |
| Media | [N] | Rendono l'acquisto difficile: da correggere entro [1-2 mesi] |
| Bassa | [N] | Migliorano l'esperienza: da pianificare |

**Cosa consigliamo.**
1. Correggere i problemi ad alta priorità (stima: [N] ore di sviluppo).
2. Preparare o aggiornare la dichiarazione di accessibilità, da far validare al vostro legale.
3. Ricontrollare il sito dopo ogni modifica importante al tema o alle app installate.

**Cosa non è questo documento.** Non è una valutazione legale né una certificazione di conformità: è un'analisi tecnica, basata sulle pagine e sulla data indicate, che il vostro consulente legale può usare per le sue valutazioni. I widget di accessibilità ("overlay") non risolvono questi problemi.

---

## 2. Ambito e metodo

| Pagina | URL | Dispositivo |
|---|---|---|
| Home | | desktop + mobile |
| Categoria | | desktop + mobile |
| Prodotto | | desktop + mobile |
| Carrello | | desktop + mobile |
| Checkout (fino al pagamento, senza acquistare) | | desktop + mobile |

Strumenti: axe-core (mini-check automatico), WAVE, Lighthouse, NVDA [versione] + Chrome / VoiceOver + Safari iOS, prova solo tastiera, zoom 200% e 400%.
Piattaforma: [Shopify / WooCommerce / …], tema: [nome], app di terze parti rilevanti: [recensioni, chat, cookie banner…].

---

## 3. Elenco tecnico (per lo sviluppatore)

Copia qui le voci da `dettaglio-tecnico.md` e aggiungi quelle trovate con la checklist manuale. Una scheda per problema:

### [ID] – [Titolo del problema]

- **Priorità:** alta / media / bassa
- **Criterio WCAG:** [es. 4.1.2 Nome, ruolo, valore (A)]
- **Dove:** [pagina, componente, selettore CSS]
- **Come riprodurre:** [passi]
- **Effetto su chi compra:** [chi è bloccato e come]
- **Correzione proposta:** [descrizione + snippet di codice]
- **Stato:** da fare / corretto il [data] / verificato il [data]

---

## 4. Problemi di terze parti

Problemi in componenti che il cliente non controlla direttamente (app, widget di pagamento, cookie banner, chat): segnalare al fornitore. Elenco: [ … ]

## 5. Prossimi passi e monitoraggio

- Correzioni: [pacchetto "Audit + correzioni" / a cura del vostro sviluppatore]
- Ricontrollo mensile dopo le modifiche al sito: 100-200 €/mese

---

_Analisi tecnica svolta con il supporto di strumenti automatici e di intelligenza artificiale (legge 132/2025); tutti i risultati sono stati verificati manualmente da Maurizio, che ne risponde._
