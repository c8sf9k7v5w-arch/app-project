// Spiegazioni in italiano delle regole axe-core più frequenti negli e-commerce.
// titolo: frase breve per il titolare (va anche nel messaggio LinkedIn)
// perche: conseguenza concreta per chi compra
// correzione: cosa deve fare lo sviluppatore
// wcag: criterio di successo WCAG 2.1
// peso: quanto pesa sul percorso d'acquisto (3 alto, 2 medio, 1 basso)

export const REGOLE = {
  'image-alt': {
    titolo: 'immagini senza testo alternativo',
    perche: 'Chi usa uno screen reader non sa cosa mostrano le foto dei prodotti o dei banner.',
    correzione: 'Aggiungere un attributo alt descrittivo alle immagini informative e alt="" a quelle decorative.',
    wcag: '1.1.1 Contenuti non testuali (A)',
    peso: 3,
  },
  'input-image-alt': {
    titolo: 'pulsanti-immagine senza testo alternativo',
    perche: 'Lo screen reader annuncia un pulsante senza dire cosa fa.',
    correzione: 'Aggiungere alt all\'input type="image" con l\'azione del pulsante.',
    wcag: '1.1.1 Contenuti non testuali (A)',
    peso: 3,
  },
  'role-img-alt': {
    titolo: 'elementi grafici senza descrizione',
    perche: 'Icone e grafiche con ruolo di immagine non vengono descritte a chi non vede.',
    correzione: 'Aggiungere aria-label o aria-labelledby agli elementi con role="img".',
    wcag: '1.1.1 Contenuti non testuali (A)',
    peso: 2,
  },
  'svg-img-alt': {
    titolo: 'icone SVG senza descrizione',
    perche: 'Icone come carrello o account non vengono descritte a chi usa uno screen reader.',
    correzione: 'Aggiungere <title> o aria-label agli SVG con role="img".',
    wcag: '1.1.1 Contenuti non testuali (A)',
    peso: 2,
  },
  'color-contrast': {
    titolo: 'testi con contrasto troppo basso',
    perche: 'Chi ha una vista ridotta, o guarda il telefono al sole, fatica a leggere prezzi e testi.',
    correzione: 'Portare il contrasto ad almeno 4.5:1 per il testo normale e 3:1 per il testo grande.',
    wcag: '1.4.3 Contrasto minimo (AA)',
    peso: 2,
  },
  'link-in-text-block': {
    titolo: 'link distinguibili solo dal colore',
    perche: 'Chi non distingue bene i colori non capisce dove sono i link nel testo.',
    correzione: 'Sottolineare i link nel testo o dare un contrasto di 3:1 rispetto al testo circostante.',
    wcag: '1.4.1 Uso del colore (A)',
    peso: 1,
  },
  label: {
    titolo: 'campi dei moduli senza etichetta',
    perche: 'Chi usa uno screen reader non sa cosa scrivere nei campi (ricerca, newsletter, indirizzo).',
    correzione: 'Collegare ogni campo a una <label> visibile o, in alternativa, usare aria-label.',
    wcag: '1.3.1 Informazioni e correlazioni / 4.1.2 Nome, ruolo, valore (A)',
    peso: 3,
  },
  'select-name': {
    titolo: 'menu a tendina senza etichetta',
    perche: 'Taglia, colore o quantità non vengono annunciati: non si capisce cosa si sta scegliendo.',
    correzione: 'Collegare ogni <select> a una <label> o aggiungere aria-label.',
    wcag: '4.1.2 Nome, ruolo, valore (A)',
    peso: 3,
  },
  'autocomplete-valid': {
    titolo: 'campi con compilazione automatica errata',
    perche: 'Il browser non può compilare in automatico nome, indirizzo ed email al checkout.',
    correzione: 'Usare valori autocomplete validi (name, email, street-address, postal-code…).',
    wcag: '1.3.5 Identificare lo scopo degli input (AA)',
    peso: 2,
  },
  'button-name': {
    titolo: 'pulsanti senza nome',
    perche: 'Lo screen reader dice solo "pulsante": non si capisce se aggiunge al carrello, chiude o apre il menu.',
    correzione: 'Dare a ogni pulsante un testo visibile o un aria-label (es. "Aggiungi al carrello").',
    wcag: '4.1.2 Nome, ruolo, valore (A)',
    peso: 3,
  },
  'link-name': {
    titolo: 'link senza testo',
    perche: 'Link fatti solo di icone o immagini vengono letti come "link" senza destinazione.',
    correzione: 'Aggiungere testo visibile, aria-label o alt all\'immagine contenuta nel link.',
    wcag: '2.4.4 Scopo del link / 4.1.2 Nome, ruolo, valore (A)',
    peso: 3,
  },
  'html-has-lang': {
    titolo: 'lingua della pagina non dichiarata',
    perche: 'Lo screen reader legge l\'italiano con la pronuncia sbagliata.',
    correzione: 'Aggiungere lang="it" al tag <html>.',
    wcag: '3.1.1 Lingua della pagina (A)',
    peso: 1,
  },
  'html-lang-valid': {
    titolo: 'lingua della pagina dichiarata in modo errato',
    perche: 'Lo screen reader può usare la pronuncia sbagliata.',
    correzione: 'Usare un codice lingua valido, es. lang="it".',
    wcag: '3.1.1 Lingua della pagina (A)',
    peso: 1,
  },
  'document-title': {
    titolo: 'pagina senza titolo',
    perche: 'Chi usa uno screen reader non sa in che pagina si trova.',
    correzione: 'Aggiungere un <title> che descriva la pagina.',
    wcag: '2.4.2 Titolo della pagina (A)',
    peso: 1,
  },
  'meta-viewport': {
    titolo: 'zoom bloccato su smartphone',
    perche: 'Chi ha bisogno di ingrandire non riesce a leggere prezzi e descrizioni dal telefono.',
    correzione: 'Togliere user-scalable=no e maximum-scale dal meta viewport.',
    wcag: '1.4.4 Ridimensionamento del testo (AA)',
    peso: 2,
  },
  'aria-hidden-focus': {
    titolo: 'elementi nascosti ma raggiungibili con la tastiera',
    perche: 'Con la tastiera si finisce su elementi invisibili (menu chiusi, popup) e ci si perde.',
    correzione: 'Rendere non focalizzabili gli elementi dentro aria-hidden="true" (tabindex="-1" o inert).',
    wcag: '4.1.2 Nome, ruolo, valore (A)',
    peso: 2,
  },
  'aria-required-attr': {
    titolo: 'componenti interattivi incompleti',
    perche: 'Menu, schede o slider non comunicano il loro stato a chi usa uno screen reader.',
    correzione: 'Aggiungere gli attributi ARIA obbligatori per il ruolo usato.',
    wcag: '4.1.2 Nome, ruolo, valore (A)',
    peso: 2,
  },
  'aria-valid-attr-value': {
    titolo: 'attributi ARIA con valori errati',
    perche: 'Le tecnologie assistive ricevono informazioni sbagliate sugli elementi.',
    correzione: 'Correggere i valori degli attributi ARIA (es. aria-controls deve puntare a un id esistente).',
    wcag: '4.1.2 Nome, ruolo, valore (A)',
    peso: 1,
  },
  'aria-allowed-attr': {
    titolo: 'attributi ARIA non ammessi',
    perche: 'Le tecnologie assistive possono interpretare male gli elementi.',
    correzione: 'Rimuovere gli attributi ARIA non ammessi per quel ruolo.',
    wcag: '4.1.2 Nome, ruolo, valore (A)',
    peso: 1,
  },
  'aria-command-name': {
    titolo: 'comandi senza nome',
    perche: 'Lo screen reader annuncia un comando senza dire cosa fa.',
    correzione: 'Aggiungere testo o aria-label agli elementi con role="button" o "link".',
    wcag: '4.1.2 Nome, ruolo, valore (A)',
    peso: 3,
  },
  'aria-input-field-name': {
    titolo: 'campi personalizzati senza nome',
    perche: 'Campi come selettori di quantità non vengono annunciati.',
    correzione: 'Aggiungere aria-label o aria-labelledby.',
    wcag: '4.1.2 Nome, ruolo, valore (A)',
    peso: 3,
  },
  'aria-toggle-field-name': {
    titolo: 'interruttori senza nome',
    perche: 'Caselle e interruttori personalizzati non dicono cosa attivano.',
    correzione: 'Aggiungere aria-label o aria-labelledby.',
    wcag: '4.1.2 Nome, ruolo, valore (A)',
    peso: 2,
  },
  'frame-title': {
    titolo: 'riquadri incorporati senza titolo',
    perche: 'Mappe, video e widget incorporati non vengono identificati.',
    correzione: 'Aggiungere un attributo title descrittivo a ogni <iframe>.',
    wcag: '4.1.2 Nome, ruolo, valore (A)',
    peso: 1,
  },
  'nested-interactive': {
    titolo: 'controlli annidati uno dentro l\'altro',
    perche: 'Con tastiera e screen reader alcuni pulsanti diventano irraggiungibili.',
    correzione: 'Non mettere link o pulsanti dentro altri elementi interattivi.',
    wcag: '4.1.2 Nome, ruolo, valore (A)',
    peso: 2,
  },
  'scrollable-region-focusable': {
    titolo: 'aree scorrevoli non usabili da tastiera',
    perche: 'Caroselli e liste scorrevoli non si possono scorrere senza mouse.',
    correzione: 'Rendere l\'area focalizzabile (tabindex="0") o contenere elementi focalizzabili.',
    wcag: '2.1.1 Tastiera (A)',
    peso: 2,
  },
  'aria-required-parent': {
    titolo: 'componenti ARIA fuori dal contenitore giusto',
    perche: 'Schede, menu e caroselli vengono annunciati in modo confuso o incompleto.',
    correzione: 'Inserire gli elementi con ruolo (es. tab, menuitem, option) dentro il contenitore richiesto (tablist, menu, listbox).',
    wcag: '1.3.1 Informazioni e correlazioni (A)',
    peso: 2,
  },
  'aria-required-children': {
    titolo: 'componenti ARIA senza gli elementi interni richiesti',
    perche: 'Liste, menu e schede risultano vuoti o incompleti per chi usa uno screen reader.',
    correzione: 'Aggiungere gli elementi figli richiesti dal ruolo o cambiare ruolo al contenitore.',
    wcag: '1.3.1 Informazioni e correlazioni (A)',
    peso: 2,
  },
  list: {
    titolo: 'elenchi costruiti in modo errato',
    perche: 'Lo screen reader non annuncia quanti elementi ci sono (es. voci di menu o filtri).',
    correzione: 'Dentro <ul>/<ol> usare solo <li> (o script/template).',
    wcag: '1.3.1 Informazioni e correlazioni (A)',
    peso: 1,
  },
  listitem: {
    titolo: 'voci di elenco fuori da un elenco',
    perche: 'La struttura delle liste non viene comunicata correttamente.',
    correzione: 'Inserire ogni <li> dentro un <ul> o <ol>.',
    wcag: '1.3.1 Informazioni e correlazioni (A)',
    peso: 1,
  },
  'definition-list': {
    titolo: 'elenchi di definizioni costruiti in modo errato',
    perche: 'Schede tecniche e caratteristiche dei prodotti non vengono lette con la struttura giusta.',
    correzione: 'Dentro <dl> usare solo gruppi <dt>/<dd>.',
    wcag: '1.3.1 Informazioni e correlazioni (A)',
    peso: 1,
  },
  'td-headers-attr': {
    titolo: 'tabelle con intestazioni errate',
    perche: 'Tabelle taglie o prezzi non si capiscono con lo screen reader.',
    correzione: 'Far puntare l\'attributo headers a celle della stessa tabella.',
    wcag: '1.3.1 Informazioni e correlazioni (A)',
    peso: 1,
  },
  'duplicate-id-aria': {
    titolo: 'identificativi duplicati su etichette',
    perche: 'Etichette e descrizioni finiscono sul campo sbagliato.',
    correzione: 'Rendere unici gli id usati da aria-labelledby, aria-describedby e label for.',
    wcag: '4.1.2 Nome, ruolo, valore (A)',
    peso: 1,
  },
  'video-caption': {
    titolo: 'video senza sottotitoli',
    perche: 'Chi non sente non capisce i video di prodotto.',
    correzione: 'Aggiungere sottotitoli sincronizzati (<track kind="captions">).',
    wcag: '1.2.2 Sottotitoli (A)',
    peso: 1,
  },
};

const IMPATTO = { critical: 4, serious: 3, moderate: 2, minor: 1 };
const IMPATTO_IT = { critical: 'critico', serious: 'grave', moderate: 'moderato', minor: 'lieve' };

export function impattoIt(impact) {
  return IMPATTO_IT[impact] ?? 'n.d.';
}

// Spiegazione della regola: quella italiana se esiste, altrimenti quella di axe.
export function spiega(violazione) {
  const r = REGOLE[violazione.id];
  if (r) return r;
  return {
    titolo: violazione.help,
    perche: violazione.description,
    correzione: `Vedi ${violazione.helpUrl}`,
    wcag: criteriDaTag(violazione.tags) || 'WCAG 2.1',
    peso: 1,
  };
}

function criteriDaTag(tags = []) {
  return tags
    .filter((t) => /^wcag\d{3,4}$/.test(t))
    .map((t) => t.slice(4).split('').join('.'))
    .join(', ');
}

// Priorità per il report: alta / media / bassa.
export function priorita(violazione) {
  const p = punteggio(violazione);
  if (p >= 7) return 'alta';
  if (p >= 5) return 'media';
  return 'bassa';
}

// Punteggio usato per scegliere i 3 problemi da mostrare nel mini-check.
// Somma impatto (1-4), peso sul percorso d'acquisto (1-3) e un bonus
// se il problema compare in una pagina di carrello o prodotto.
export function punteggio(violazione) {
  const impatto = IMPATTO[violazione.impact] ?? 1;
  const peso = spiega(violazione).peso;
  const pagine = violazione.pagine ?? [];
  const bonusPagina = pagine.some((p) => p === 'carrello') ? 2 : pagine.some((p) => p === 'prodotto') ? 1 : 0;
  return impatto + peso + bonusPagina + Math.min(2, Math.floor(Math.log10(violazione.nodi + 1) * 2));
}
