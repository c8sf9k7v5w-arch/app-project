/* Script comune: menu mobile, orario di oggi e stato aperto/chiuso, mappa a richiesta, modulo di prenotazione. */
(function () {
  var dati = JSON.parse(document.getElementById('dati-farmacia').textContent);

  // Menu mobile
  var burger = document.querySelector('.burger'), menu = document.querySelector('nav.menu');
  if (burger && menu) burger.addEventListener('click', function () {
    var aperto = menu.classList.toggle('aperto');
    burger.setAttribute('aria-expanded', aperto ? 'true' : 'false');
  });

  // Ora corrente a Roma, indipendente dal fuso del visitatore
  function oraRoma() {
    var p = {};
    new Intl.DateTimeFormat('en-GB', { timeZone: 'Europe/Rome', weekday: 'short', hour: '2-digit', minute: '2-digit', hourCycle: 'h23' })
      .formatToParts(new Date()).forEach(function (x) { p[x.type] = x.value; });
    var giorni = { Mon: 0, Tue: 1, Wed: 2, Thu: 3, Fri: 4, Sat: 5, Sun: 6 };
    return { giorno: giorni[p.weekday], minuti: parseInt(p.hour, 10) * 60 + parseInt(p.minute, 10) };
  }
  function fasce(testo) {
    var out = [], re = /(\d{1,2}):(\d{2})\s*-\s*(\d{1,2}):(\d{2})/g, m;
    while ((m = re.exec(testo))) out.push([+m[1] * 60 + +m[2], +m[3] * 60 + +m[4]]);
    return out;
  }
  var ora = oraRoma(), oggi = dati.orari[ora.giorno];
  var aperto = fasce(oggi[1]).some(function (f) { return ora.minuti >= f[0] && ora.minuti < f[1]; });
  document.querySelectorAll('[data-oggi]').forEach(function (el) { el.textContent = oggi[1]; });
  document.querySelectorAll('[data-stato]').forEach(function (el) {
    el.textContent = aperto ? 'Aperto ora' : 'Chiuso ora';
    el.classList.add(aperto ? 'aperto' : 'chiuso');
  });
  document.querySelectorAll('[data-giorno="' + ora.giorno + '"]').forEach(function (el) { el.classList.add('oggi-riga'); });

  // Mappa caricata solo su richiesta: nessun contenuto di terze parti prima del consenso
  document.querySelectorAll('[data-carica-mappa]').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var box = btn.closest('.mappa'), d = 0.004;
      var bbox = [dati.lon - d, dati.lat - d / 1.6, dati.lon + d, dati.lat + d / 1.6].join(',');
      box.innerHTML = '<iframe title="Mappa: ' + dati.nome + '" loading="lazy" src="https://www.openstreetmap.org/export/embed.html?bbox=' +
        bbox + '&layer=mapnik&marker=' + dati.lat + ',' + dati.lon + '"></iframe>';
      box.classList.add('caricata');
    });
  });

  // Prenotazione servizi: senza server, prepara il messaggio per email o WhatsApp
  var form = document.querySelector('form.prenota');
  if (form) {
    var q = new URLSearchParams(location.search).get('servizio');
    if (q && form.servizio) form.servizio.value = q;
    form.addEventListener('submit', function (e) {
      e.preventDefault();
      if (!form.checkValidity()) { form.reportValidity(); return; }
      var f = form.elements;
      var testo = 'Richiesta di prenotazione - ' + dati.nome + '\n' +
        'Servizio: ' + f.servizio.value + '\nNome: ' + f.nome.value + '\nTelefono: ' + f.telefono.value +
        '\nGiorno preferito: ' + (f.giorno.value || 'indifferente') + '\nNote: ' + (f.note.value || '-');
      var esito = form.querySelector('.esito');
      if (dati.whatsapp) {
        window.open('https://wa.me/' + dati.whatsapp + '?text=' + encodeURIComponent(testo), '_blank', 'noopener');
      } else if (dati.email) {
        location.href = 'mailto:' + dati.email + '?subject=' + encodeURIComponent('Prenotazione: ' + f.servizio.value) + '&body=' + encodeURIComponent(testo);
      }
      esito.innerHTML = (dati.whatsapp || dati.email)
        ? 'Abbiamo preparato il messaggio con i tuoi dati: invialo per completare la richiesta. Ti ricontatteremo per confermare giorno e ora.'
        : 'Per completare la prenotazione chiamaci al <a href="tel:' + dati.tel + '">' + dati.telefono + '</a>: ti confermiamo subito giorno e ora.';
      esito.classList.add('vis');
    });
  }
})();
