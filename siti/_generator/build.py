"""Genera i siti statici delle farmacie in ../<slug>/ e l'indice ../index.html.

Uso:  python3 build.py
Dati: sites.json (una voce per farmacia). Testi condivisi: catalogo.py.
Le parti da verificare con il titolare sono marcate con [DA CONFERMARE CON IL TITOLARE] o [DA INSERIRE].
"""
import html, json, os, re, shutil
from catalogo import ICONE, SERVIZI, CATEGORIE, REPARTI, CONSIGLI

QUI = os.path.dirname(os.path.abspath(__file__))
SITI = os.path.dirname(QUI)
CONF = '<span class="conf">DA CONFERMARE CON IL TITOLARE</span>'
INS = '<span class="conf">DA INSERIRE</span>'
GIORNI_EN = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
PAGINE = [('index.html', 'Home'), ('farmacia.html', 'La farmacia'), ('servizi.html', 'Servizi'),
          ('reparti.html', 'Reparti'), ('offerte.html', 'Offerte'), ('turni.html', 'Farmacie di turno'),
          ('contatti.html', 'Contatti')]
FORME = {  # raggi per variante: card, icone
    'split': ('18px', '14px'), 'centrata': ('22px', '50%'), 'fascia': ('10px', '8px')}

e = html.escape


def ico(nome, cls='ico'):
    return f'<svg class="{cls}" viewBox="0 0 24 24" aria-hidden="true">{ICONE[nome]}</svg>'


def luminanza(hexc):
    r, g, b = (int(hexc[i:i + 2], 16) / 255 for i in (1, 3, 5))
    f = lambda c: c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4
    return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b)


def contrasto(a, b):
    la, lb = sorted((luminanza(a), luminanza(b)), reverse=True)
    return (la + 0.05) / (lb + 0.05)


def tel_link(t):
    return '+39' + re.sub(r'\D', '', t)


def logo_svg(s):
    v, t = s['tema']['variante'], s['tema']
    iniziale = e(s['nome'].replace('Farmacia ', '')[0])
    forma = {'split': '<rect x="2" y="2" width="44" height="44" rx="12" fill="{p}"/>',
             'centrata': '<circle cx="24" cy="24" r="22" fill="{p}"/>',
             'fascia': '<path d="M24 2l19 11v22L24 46 5 35V13z" fill="{p}"/>'}[v].format(p=t['primario'])
    return (f'<svg viewBox="0 0 48 48" aria-hidden="true">{forma}'
            f'<path d="M30 9h6v6h6v6h-6v6h-6v-6h-6v-6h6z" fill="{t["accento"]}"/>'
            f'<text x="17" y="36" text-anchor="middle" font-family="{t["font_titoli"]}, serif" font-size="22" fill="#fff">{iniziale}</text></svg>')


def tema_css(s):
    t = s['tema']
    card, icor = FORME[t['variante']]
    su_acc = '#ffffff' if contrasto(t['accento'], '#ffffff') >= 4.5 else t['primario_scuro'] if contrasto(t['accento'], t['primario_scuro']) >= 4.5 else '#111111'
    font = ''
    for fam, pesi in ((t['font_titoli'], t['pesi_titoli']), (t['font_testo'], t['pesi_testo'])):
        for w in pesi:
            font += (f"@font-face{{font-family:'{fam}';font-style:normal;font-weight:{w};font-display:swap;"
                     f"src:url(fonts/{fam.replace(' ', '')}-{w}.woff2) format('woff2')}}\n")
    return font + (
        f":root{{--primario:{t['primario']};--primario-scuro:{t['primario_scuro']};--accento:{t['accento']};"
        f"--accento-testo:{t['accento_testo']};--su-accento:{su_acc};--sfondo:{t['sfondo']};--superficie:{t['superficie']};"
        f"--tenue:{t['tenue']};--testo:{t['testo']};--testo-soft:{t['testo_soft']};"
        f"--f-titoli:'{t['font_titoli']}';--f-testo:'{t['font_testo']}';--w-titoli:{max(t['pesi_titoli'])};"
        f"--w-forte:{max(t['pesi_testo'])};--raggio:{'24px' if t['raggio'] == '999px' else t['raggio']};"
        f"--raggio-btn:{t['raggio']};--raggio-card:{card};--raggio-ico:{icor}}}\n")


def orari_spec(s):
    spec = []
    for i, (_, testo) in enumerate(s['orari']):
        for a, b in re.findall(r'(\d{2}:\d{2})\s*-\s*(\d{2}:\d{2})', testo):
            spec.append({'@type': 'OpeningHoursSpecification', 'dayOfWeek': GIORNI_EN[i], 'opens': a, 'closes': b})
    return spec


def json_ld(s):
    d = {'@context': 'https://schema.org', '@type': 'Pharmacy', 'name': s['nome'],
         'address': {'@type': 'PostalAddress', 'streetAddress': s['indirizzo'], 'postalCode': s['cap'],
                     'addressLocality': 'Roma', 'addressRegion': 'RM', 'addressCountry': 'IT'},
         'geo': {'@type': 'GeoCoordinates', 'latitude': s['lat'], 'longitude': s['lon']},
         'telephone': tel_link(s['telefono']), 'openingHoursSpecification': orari_spec(s),
         'areaServed': s['zona_seo'] + ', Roma Nord', 'medicalSpecialty': 'Pharmacy',
         'availableService': [{'@type': 'MedicalProcedure', 'name': SERVIZI[k][0]} for k in s['servizi']]}
    if s['email']:
        d['email'] = s['email']
    return json.dumps(d, ensure_ascii=False, indent=1)


def maps_url(s):
    from urllib.parse import quote
    return 'https://www.google.com/maps/search/?api=1&query=' + quote(f"{s['nome']}, {s['indirizzo']}, {s['cap']} Roma")


def whatsapp_href(s):
    return f"https://wa.me/{s['whatsapp']}" if s['whatsapp'] else 'contatti.html#whatsapp'


def da_conf(s, chiave):
    return ' ' + CONF if chiave in s.get('servizi_da_confermare', []) else ''


def lista_orari(s, tag='ul'):
    if tag == 'ul':
        return '<ul>' + ''.join(f'<li data-giorno="{i}"><span>{g}</span><span>{e(o)}</span></li>' for i, (g, o) in enumerate(s['orari'])) + '</ul>'
    return ('<table class="orari"><caption class="muted" style="text-align:left;padding:.4rem 0">Orario continuato e pause come da tabella. '
            'Nei giorni di turno l\'orario può essere esteso.</caption><tbody>' +
            ''.join(f'<tr data-giorno="{i}"><th scope="row">{g}</th><td>{e(o)}</td></tr>' for i, (g, o) in enumerate(s['orari'])) + '</tbody></table>')


def card_oggi(s, compatta=False):
    return f'''<div class="card-oggi">
  <h2>Orario di oggi</h2>
  <div class="oggi" data-oggi>—</div>
  <div class="stato" data-stato aria-live="polite">Orario</div>
  {lista_orari(s)}
</div>'''


def pagina(s, file, titolo, descr, corpo, extra_head=''):
    t = s['tema']
    nav = ''.join(f'<li><a href="{f}"{" aria-current=page" if f == file else ""}>{n}</a></li>' for f, n in PAGINE)
    tel = tel_link(s['telefono'])
    titolo_pag = f"{s['nome']} – Farmacia a {s['quartiere']}, Roma Nord" if file == 'index.html' else f"{titolo} – {s['nome']}, {s['quartiere']} Roma"
    dati = json.dumps({'nome': s['nome'], 'orari': s['orari'], 'lat': s['lat'], 'lon': s['lon'], 'email': s['email'],
                       'whatsapp': s['whatsapp'], 'telefono': s['telefono'], 'tel': tel}, ensure_ascii=False)
    email_footer = f'<li><a href="mailto:{e(s["email"])}">{e(s["email"])}</a> {CONF}</li>' if s['email'] else f'<li>Email {CONF}</li>'
    return f'''<!doctype html>
<html lang="it">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{e(titolo_pag)}</title>
<meta name="description" content="{e(descr)}">
<meta name="theme-color" content="{t['primario']}">
<meta property="og:type" content="website">
<meta property="og:locale" content="it_IT">
<meta property="og:title" content="{e(titolo_pag)}">
<meta property="og:description" content="{e(descr)}">
<meta name="geo.region" content="IT-RM">
<meta name="geo.placename" content="Roma, {e(s['quartiere'])}">
<meta name="geo.position" content="{s['lat']};{s['lon']}">
<link rel="icon" href="favicon.svg" type="image/svg+xml">
<link rel="stylesheet" href="assets/style.css">
{extra_head}</head>
<body>
<a class="skip" href="#contenuto">Vai al contenuto</a>
<div class="top"><div class="wrap">
  <span class="top-ind">{ico('pin')} {e(s['indirizzo'])} – {s['cap']} Roma</span>
  <span><span class="stato" data-stato>Orario</span>&nbsp;·&nbsp;oggi <span data-oggi>—</span></span>
  <a class="top-tel" href="tel:{tel}">{ico('telefono')} {e(s['telefono'])}</a>
</div></div>
<header class="nav"><div class="wrap">
  <a class="logo" href="index.html">{logo_svg(s)}<span><b>{e(s['nome'])}</b><small>{e(s['quartiere'])} · Roma Nord</small></span></a>
  <nav class="menu" aria-label="Menu principale"><ul>{nav}</ul></nav>
  <a class="btn btn-prim nav-cta" href="servizi.html#prenota">{ico('calendario')} Prenota</a>
  <button class="burger" aria-label="Apri il menu" aria-expanded="false">{ico('menu')}</button>
</div></header>
<main id="contenuto">
{corpo}
</main>
<footer class="piede"><div class="wrap">
  <div>
    <h2>{e(s['nome'])}</h2>
    <p>{e(s['indirizzo'])}<br>{s['cap']} Roma (RM) – {e(s['quartiere'])}, Municipio {s['municipio']}</p>
    <p><a href="{maps_url(s)}" rel="noopener" target="_blank">Apri in Google Maps</a></p>
  </div>
  <div>
    <h2>Contatti</h2>
    <ul><li><a href="tel:{tel}">{e(s['telefono'])}</a></li>{email_footer}<li><a href="{whatsapp_href(s)}">WhatsApp</a></li></ul>
  </div>
  <div>
    <h2>Orari</h2>
    <ul>{''.join(f'<li>{g}: {e(o)}</li>' for g, o in s['orari'])}</ul>
  </div>
  <div class="legale">
    <span>© 2026 {e(s['ragione_sociale'])} · P.IVA {INS}</span>
    <span><a href="privacy.html">Privacy policy</a> · <a href="cookie.html">Cookie policy</a> · <a href="turni.html">Farmacie di turno</a></span>
  </div>
</div></footer>
<div class="azioni-fisse">
  <a class="btn btn-prim" href="tel:{tel}">{ico('telefono')} Chiama</a>
  <a class="btn btn-sec" href="{whatsapp_href(s)}">{ico('chat')} WhatsApp</a>
  <a class="btn btn-sec" href="servizi.html#prenota">{ico('calendario')} Prenota</a>
</div>
<script type="application/json" id="dati-farmacia">{dati}</script>
<script src="assets/site.js" defer></script>
</body>
</html>
'''


def testata(titolo, sotto, file):
    return f'''<div class="testata"><div class="wrap">
  <div class="briciole"><a href="index.html">Home</a> / {e(titolo)}</div>
  <h1>{e(titolo)}</h1>{f'<p>{sotto}</p>' if sotto else ''}
</div></div>'''


def card_servizio(s, k, link=True):
    nome, icona, _, testo = SERVIZI[k]
    return f'''<article class="card"><div class="bolla">{ico(icona)}</div><h3>{e(nome)}{da_conf(s, k)}</h3><p>{e(testo)}</p>
{f'<a class="link" href="servizi.html?servizio={e(nome)}#prenota">Prenota {ico("freccia")}</a>' if link else ''}</article>'''


def home(s):
    t = s['tema']; v = t['variante']; tel = tel_link(s['telefono'])
    titolo = f"La tua farmacia a {s['quartiere']}"
    lead = e(s['claim']) + f" Ci trovi in {e(s['indirizzo'])}."
    azioni = f'''<div class="azioni"><a class="btn btn-prim" href="servizi.html#prenota">{ico('calendario')} Prenota un servizio</a>
<a class="btn btn-sec" href="tel:{tel}">{ico('telefono')} Chiama {e(s['telefono'])}</a></div>'''
    if v == 'split':
        hero = f'''<section class="hero hero-split"><div class="forma"></div><div class="wrap">
  <div><div class="eyebrow">Farmacia a {e(s['quartiere'])} · Roma Nord</div><h1>{e(titolo)}</h1><p class="lead">{lead}</p>{azioni}</div>
  {card_oggi(s)}
</div></section>'''
    elif v == 'centrata':
        chips = ''.join(f'<li><a href="servizi.html?servizio={e(SERVIZI[k][0])}#prenota">{ico(SERVIZI[k][1])} {e(SERVIZI[k][0])}</a></li>' for k in s['servizi_evidenza'])
        hero = f'''<section class="hero hero-centrata"><div class="wrap">
  <div class="eyebrow">Farmacia a {e(s['quartiere'])} · Roma Nord</div><h1>{e(titolo)}</h1><p class="lead">{lead}</p>{azioni}
  <ul class="chips" aria-label="Servizi più richiesti">{chips}</ul>
  {card_oggi(s)}
</div></section>'''
    else:
        hero = f'''<section class="hero hero-fascia"><div class="wrap">
  <div class="eyebrow" style="color:{t['accento']}">Farmacia a {e(s['quartiere'])} · Roma Nord</div><h1>{e(titolo)}</h1><p class="lead">{lead}</p>{azioni}
</div><div class="onde"><svg viewBox="0 0 1440 90" preserveAspectRatio="none" aria-hidden="true"><path fill="currentColor" d="M0 60c240-50 480-50 720-10s480 40 720-10v50H0z"/></svg></div></section>
<div class="wrap fascia-card">{card_oggi(s)}</div>'''
    evid = ''.join(card_servizio(s, k) for k in s['servizi_evidenza'])
    reparti = ''.join(f'<article class="card"><div class="bolla">{ico(REPARTI[k][1])}</div><h3>{e(REPARTI[k][0])}</h3><p>{e(REPARTI[k][2])}</p></article>' for k in s['reparti'][:4])
    consigli = ''.join(f'<details class="consiglio"><summary>{e(a)}</summary><p>{e(b)}</p></details>' for a, b in CONSIGLI)
    corpo = f'''{hero}
<section class="sez"><div class="wrap">
  <div class="intest"><div><div class="eyebrow">Servizi in farmacia</div><h2>Controlli e prenotazioni, sotto casa</h2></div>
  <a class="btn btn-sec" href="servizi.html">Tutti i servizi {ico('freccia')}</a></div>
  <div class="griglia">{evid}</div>
</div></section>
<section class="sez alt"><div class="wrap">
  <div class="banda"><div><h2>Ordina e passa a ritirare</h2><p>Mandaci la lista dei prodotti o il numero della ricetta elettronica: prepariamo tutto e ti avvisiamo quando è pronto. {CONF}</p></div>
  <div class="azioni"><a class="btn btn-chiaro" href="{whatsapp_href(s)}">{ico('chat')} Scrivici</a><a class="btn btn-sec" href="tel:{tel}">{ico('telefono')} Chiama</a></div></div>
</div></section>
<section class="sez"><div class="wrap">
  <div class="intest"><div><div class="eyebrow">Reparti</div><h2>Non solo farmaci</h2></div><a class="btn btn-sec" href="reparti.html">Tutti i reparti {ico('freccia')}</a></div>
  <div class="griglia">{reparti}</div>
</div></section>
<section class="sez alt"><div class="wrap due">
  <div><div class="eyebrow">Hai bisogno di un consiglio?</div><h2>Chiedi al farmacista</h2>
  <p class="muted">Siamo a disposizione per orientarti su prodotti da banco, integratori e servizi. Per diagnosi e terapie il riferimento resta il tuo medico.</p>
  <div class="azioni" style="display:flex;gap:.7rem;flex-wrap:wrap"><a class="btn btn-prim" href="tel:{tel}">{ico('telefono')} {e(s['telefono'])}</a><a class="btn btn-sec" href="contatti.html">Come raggiungerci</a></div></div>
  <div>{consigli}</div>
</div></section>'''
    descr = f"{s['nome']}, farmacia a {s['quartiere']} ({s['zona_seo']}), Roma Nord: orari, servizi di telemedicina, prenotazioni CUP e contatti. {s['indirizzo']}."
    return pagina(s, 'index.html', 'Home', descr, corpo,
                  f'<script type="application/ld+json">\n{json_ld(s)}\n</script>\n')


def farmacia(s):
    dal = f"dal {s['dal']} {CONF}" if s['dal'] else CONF
    corpo = testata('La farmacia', f"{e(s['nome'])}, {e(s['indirizzo'])} – {e(s['quartiere'])}, Roma Nord.", 'farmacia.html') + f'''
<section class="sez"><div class="wrap due">
  <div class="prosa">
    <h2>Chi siamo</h2>
    <p>La {e(s['nome'])} è un punto di riferimento per {e(s['zona_seo'])}: {dal}.
    Titolare: {e(s['titolari'])} {CONF}.</p>
    <p>Ogni giorno al banco ascoltiamo, spieghiamo e consigliamo: dal farmaco con ricetta al prodotto da banco, fino ai servizi di controllo e alle prenotazioni sanitarie.</p>
    <h2>Il nostro team</h2>
    <p>Presentazione dei farmacisti e foto della squadra {INS}</p>
    <h2>Come lavoriamo</h2>
    <p>Riservatezza, tempi chiari e collaborazione con i medici del territorio. Se un prodotto non è disponibile lo ordiniamo, di norma in giornata.</p>
  </div>
  <div>{card_oggi(s)}<p style="margin-top:1rem"><a class="btn btn-sec" href="contatti.html">{ico('pin')} Dove siamo</a></p></div>
</div></section>'''
    return pagina(s, 'farmacia.html', 'La farmacia', f"Chi siamo: {s['nome']}, farmacia a {s['quartiere']}, Roma Nord.", corpo)


def servizi(s):
    blocchi = ''
    for cat, nome_cat in CATEGORIE.items():
        voci = [k for k in s['servizi'] if SERVIZI[k][2] == cat]
        if not voci:
            continue
        righe = ''.join(f'''<div class="servizio-riga"><div class="card" style="padding:0;border:0;background:none"><div class="bolla">{ico(SERVIZI[k][1])}</div></div>
<div><h3 style="margin:0">{e(SERVIZI[k][0])}{da_conf(s, k)}</h3><p>{e(SERVIZI[k][3])}</p></div>
<a class="btn btn-sec" href="?servizio={e(SERVIZI[k][0])}#prenota">Prenota</a></div>''' for k in voci)
        blocchi += f'<h2 style="margin-top:1.4em">{nome_cat}</h2><div class="servizio-lista">{righe}</div>'
    opzioni = ''.join(f'<option>{e(SERVIZI[k][0])}</option>' for k in s['servizi'])
    canale = 'via WhatsApp' if s['whatsapp'] else 'via email' if s['email'] else 'telefonicamente'
    corpo = testata('Servizi', 'Telemedicina, esami rapidi e servizi alla persona. Per i servizi con referto, il risultato va sempre condiviso con il tuo medico.', 'servizi.html') + f'''
<section class="sez"><div class="wrap">
  {blocchi}
  <p class="muted" style="margin-top:1.2rem">Disponibilità, tempi e costi dei singoli servizi: chiedi in farmacia. {CONF}</p>
</div></section>
<section class="sez alt" id="prenota"><div class="wrap due">
  <div><div class="eyebrow">Prenotazione</div><h2>Prenota un servizio</h2>
  <p class="muted">Compila il modulo: la richiesta viene inviata {canale} e ti richiamiamo per confermare giorno e ora. Nessun dato viene salvato da questo sito.</p>
  {card_oggi(s)}</div>
  <form class="prenota" novalidate>
    <label>Servizio<select name="servizio" required>{opzioni}</select></label>
    <div class="campi"><label>Nome e cognome<input name="nome" autocomplete="name" required></label>
    <label>Telefono<input name="telefono" type="tel" autocomplete="tel" required></label></div>
    <label>Giorno preferito<input name="giorno" type="date"></label>
    <label>Note<textarea name="note" rows="3" placeholder="Es. fascia oraria preferita"></textarea></label>
    <label class="check"><input type="checkbox" required> <span>Ho letto l'<a href="privacy.html">informativa privacy</a> e acconsento a essere ricontattato per questa richiesta.</span></label>
    <button class="btn btn-prim" type="submit">{ico('calendario')} Invia richiesta</button>
    <div class="esito" role="status"></div>
  </form>
</div></section>'''
    return pagina(s, 'servizi.html', 'Servizi', f"Servizi della {s['nome']} a {s['quartiere']}, Roma: " + ', '.join(SERVIZI[k][0] for k in s['servizi'][:6]) + '. Prenota online.', corpo)


def reparti(s):
    cards = ''.join(f'<article class="card"><div class="bolla">{ico(REPARTI[k][1])}</div><h3>{e(REPARTI[k][0])}</h3><p>{e(REPARTI[k][2])}</p></article>' for k in s['reparti'])
    corpo = testata('Reparti', 'I prodotti che trovi in farmacia, oltre ai farmaci.', 'reparti.html') + f'''
<section class="sez"><div class="wrap"><div class="griglia">{cards}</div>
<p class="muted" style="margin-top:1.2rem">Marchi trattati e assortimento {CONF}</p></div></section>'''
    return pagina(s, 'reparti.html', 'Reparti', f"Reparti della {s['nome']} a {s['quartiere']}: " + ', '.join(REPARTI[k][0] for k in s['reparti']) + '.', corpo)


def offerte(s):
    corpo = testata('Offerte del mese', 'Promozioni su prodotti da banco, cosmesi e parafarmaco.', 'offerte.html') + f'''
<section class="sez"><div class="wrap"><div class="griglia">
{''.join(f'<article class="card"><div class="bolla">{ico("stelle")}</div><h3>Offerta {i} {INS}</h3><p>Prodotto, sconto e periodo di validità a cura della farmacia.</p></article>' for i in (1, 2, 3))}
</div><p class="muted" style="margin-top:1.2rem">Le promozioni non riguardano i farmaci con obbligo di ricetta. Offerte valide fino a esaurimento scorte.</p></div></section>'''
    return pagina(s, 'offerte.html', 'Offerte', f"Offerte del mese della {s['nome']}, {s['quartiere']} Roma.", corpo)


def turni(s):
    corpo = testata('Farmacie di turno', 'Quando siamo chiusi, trovi sempre una farmacia aperta in zona.', 'turni.html') + f'''
<section class="sez"><div class="wrap due">
  <div class="prosa">
    <p>A Roma le farmacie garantiscono il servizio notturno e festivo a rotazione. Il calendario aggiornato è esposto anche sulla nostra vetrina.</p>
    <ul>
      <li><a href="https://www.ordinefarmacistiroma.it/" rel="noopener" target="_blank">Ordine dei Farmacisti della Provincia di Roma</a> – turni ufficiali</li>
      <li><a href="https://www.farmaciediturno.org/farmacia.asp?idf={s['cod_ministero']}" rel="noopener" target="_blank">Scheda della {e(s['nome'])} su farmaciediturno.org</a></li>
    </ul>
    <p>In caso di emergenza sanitaria chiama il <strong>112</strong>. Per consigli medici non urgenti fuori orario puoi contattare la guardia medica (continuità assistenziale) al <strong>116117</strong>.</p>
  </div>
  <div>{card_oggi(s)}</div>
</div></section>'''
    return pagina(s, 'turni.html', 'Farmacie di turno', f"Farmacie di turno vicino a {s['quartiere']}, Roma Nord, e orari della {s['nome']}.", corpo)


def contatti(s):
    tel = tel_link(s['telefono'])
    email = f'<a href="mailto:{e(s["email"])}">{e(s["email"])}</a> {CONF}' if s['email'] else CONF
    wa = f'<a href="https://wa.me/{s["whatsapp"]}">Scrivici</a>' if s['whatsapp'] else f'Numero WhatsApp {CONF}'
    corpo = testata('Orari e contatti', f"{e(s['indirizzo'])} – {s['cap']} Roma · {e(s['quartiere'])}, Municipio {s['municipio']}", 'contatti.html') + f'''
<section class="sez"><div class="wrap due">
  <div>
    <ul class="contatti-lista">
      <li><span class="bolla">{ico('pin')}</span><div><strong>Indirizzo</strong><br>{e(s['indirizzo'])}, {s['cap']} Roma<br><a href="{maps_url(s)}" rel="noopener" target="_blank">Indicazioni stradali</a></div></li>
      <li><span class="bolla">{ico('telefono')}</span><div><strong>Telefono</strong><br><a href="tel:{tel}">{e(s['telefono'])}</a></div></li>
      <li id="whatsapp"><span class="bolla">{ico('chat')}</span><div><strong>WhatsApp</strong><br>{wa}</div></li>
      <li><span class="bolla">{ico('mail')}</span><div><strong>Email</strong><br>{email}</div></li>
    </ul>
    <h2 style="margin-top:1.6rem">Orari</h2>
    {lista_orari(s, 'table')}
  </div>
  <div class="mappa"><div><p><strong>Mappa</strong></p><p class="muted">La mappa è fornita da OpenStreetMap e viene caricata solo se lo chiedi.</p>
  <button class="btn btn-prim" type="button" data-carica-mappa>{ico('pin')} Mostra la mappa</button>
  <p style="margin-top:1rem"><a href="{maps_url(s)}" rel="noopener" target="_blank">Oppure apri Google Maps</a></p></div></div>
</div></section>'''
    return pagina(s, 'contatti.html', 'Orari e contatti', f"Orari, telefono e indirizzo della {s['nome']}: {s['indirizzo']}, {s['cap']} Roma ({s['quartiere']}).", corpo)


def privacy(s):
    corpo = testata('Privacy policy', 'Informativa ai sensi degli artt. 13-14 del Regolamento (UE) 2016/679 (GDPR).', 'privacy.html') + f'''
<section class="sez"><div class="wrap prosa">
  <p><span class="conf">TESTO BASE DA FAR VERIFICARE AL CONSULENTE PRIVACY DELLA FARMACIA</span></p>
  <h2>Titolare del trattamento</h2>
  <p>{e(s['ragione_sociale'])}, {e(s['indirizzo'])}, {s['cap']} Roma – P.IVA {INS} – contatti: {e(s['telefono'])}{(' – ' + e(s['email'])) if s['email'] else ''}.</p>
  <h2>Dati trattati e finalità</h2>
  <p>Il sito non richiede registrazione e non usa cookie di profilazione. Se compili il modulo di prenotazione, i dati che inserisci (nome, telefono, servizio richiesto, note) sono usati solo per ricontattarti e gestire la prenotazione. Il modulo non salva dati sul sito: prepara un messaggio che invii tu, via email o WhatsApp, oppure ti invita a telefonare.</p>
  <h2>Base giuridica e conservazione</h2>
  <p>Il trattamento si basa sulla tua richiesta (misure precontrattuali) e, per eventuali dati relativi alla salute indicati nelle note, sul tuo consenso esplicito. I dati sono conservati per il tempo necessario a gestire la richiesta {INS}.</p>
  <h2>Destinatari</h2>
  <p>Fornitori dei servizi di posta elettronica o messaggistica che scegli di usare; eventuali partner per i servizi di telemedicina, nominati responsabili del trattamento {INS}.</p>
  <h2>I tuoi diritti</h2>
  <p>Puoi chiedere accesso, rettifica, cancellazione, limitazione e portabilità dei dati, opporti al trattamento e revocare il consenso, scrivendo al titolare. Puoi anche presentare reclamo al Garante per la protezione dei dati personali (www.garanteprivacy.it).</p>
</div></section>'''
    return pagina(s, 'privacy.html', 'Privacy policy', f"Informativa privacy del sito della {s['nome']}.", corpo)


def cookie(s):
    corpo = testata('Cookie policy', '', 'cookie.html') + f'''
<section class="sez"><div class="wrap prosa">
  <p>Questo sito non installa cookie di profilazione né strumenti di statistica di terze parti. I caratteri tipografici sono ospitati sul sito stesso.</p>
  <p>La mappa nella pagina <a href="contatti.html">Contatti</a> è fornita da OpenStreetMap e viene caricata solo se premi “Mostra la mappa”: da quel momento si applica l'informativa di OpenStreetMap Foundation. I link a Google Maps e WhatsApp aprono servizi esterni con le rispettive informative.</p>
  <p>Se in futuro venissero aggiunti strumenti di analisi o di marketing, questa pagina e un banner di consenso verranno aggiornati. {CONF}</p>
</div></section>'''
    return pagina(s, 'cookie.html', 'Cookie policy', f"Cookie policy del sito della {s['nome']}.", corpo)


def readme(s):
    def r(k):
        return f"- {SERVIZI[k][0]}" + (' **(da confermare)**' if k in s.get('servizi_da_confermare', []) else '')
    return f"""# {s['nome']} – sito demo

Sito statico (HTML, CSS, JS, nessuna dipendenza esterna) generato da `siti/_generator` sul modello della struttura del sito
della Farmacia Spadazzi (Home, La farmacia, Reparti, Servizi con prenotazione, Offerte, Farmacie di turno, Contatti),
con identità visiva propria: variante hero **{s['tema']['variante']}**, colori {s['tema']['primario']} / {s['tema']['accento']},
font {s['tema']['font_titoli']} + {s['tema']['font_testo']} (self-hosted, licenza SIL OFL).

Apri `index.html` nel browser per vederlo. Per pubblicarlo basta caricare la cartella su qualsiasi hosting statico.

## Dati usati (verificati il 06/10/2026)

| Campo | Valore | Fonte |
|---|---|---|
| Nome | {s['nome']} | farmaciediturno.org |
| Ragione sociale (Ministero) | {s['ragione_sociale']} | open data Ministero della Salute |
| Codice Ministero | {s['cod_ministero']} | open data Ministero della Salute |
| Indirizzo | {s['indirizzo']}, {s['cap']} Roma | Ministero / farmaciediturno.org |
| Quartiere / Municipio | {s['quartiere']} / {s['municipio']} | geocodifica OSM |
| Telefono | {s['telefono']} | directory web |
| Email | {s['email'] or 'n.d.'} | directory web |
| Coordinate | {s['lat']}, {s['lon']} | Ministero / geocodifica |
| Orari | {'; '.join(f'{g} {o}' for g, o in s['orari'])} | farmaciediturno.org, settimana del 06/10/2026 |

Servizi mostrati (fonte: {s['fonti_servizi']}):

{chr(10).join(r(k) for k in s['servizi'])}

## Da confermare con il titolare

- [ ] **P.IVA** (nel footer è `[DA INSERIRE]`). Nell'open data del Ministero risulta **{s['piva_ministero']}**: verificarla in visura.
- [ ] Titolare/i: {s['titolari']}{' e anno di apertura ' + s['dal'] if s['dal'] else ''}.
- [ ] Email{' (' + s['email'] + ')' if s['email'] else ''} e **numero WhatsApp**: senza numero il pulsante WhatsApp porta alla pagina contatti e il modulo di prenotazione invita a telefonare.
- [ ] Servizi segnati "da confermare", tempi e costi dei servizi.
- [ ] Testi "Chi siamo", team e foto (oggi il sito non usa foto: vanno aggiunte quelle reali della farmacia).
- [ ] Servizio "Ordina e passa a ritirare".
- [ ] Offerte del mese e marchi trattati.
- [ ] Privacy e cookie policy: testo base da far rivedere al consulente privacy.
- [ ] Dominio: quando c'è, aggiungere `<link rel="canonical">`, `url` nei dati strutturati, `sitemap.xml` e la scheda Google Business Profile.
{s.get('nota_readme', '')}
## Note tecniche

- Dati strutturati schema.org `Pharmacy` (indirizzo, coordinate, orari, servizi) nella home.
- Stato "Aperto ora / Chiuso ora" e orario di oggi calcolati nel browser sull'ora di Roma.
- La mappa OpenStreetMap si carica solo su richiesta: nessun contenuto di terze parti senza un'azione dell'utente, quindi nessun banner cookie necessario.
- Pulsanti fissi "Chiama / WhatsApp / Prenota" su smartphone.
"""


def genera(s):
    out = os.path.join(SITI, s['slug'])
    if os.path.isdir(out):
        shutil.rmtree(out)
    os.makedirs(os.path.join(out, 'assets')); os.makedirs(os.path.join(out, 'fonts'))
    t = s['tema']
    for fam, pesi in ((t['font_titoli'], t['pesi_titoli']), (t['font_testo'], t['pesi_testo'])):
        for w in pesi:
            fn = f"{fam.replace(' ', '')}-{w}.woff2"
            shutil.copy(os.path.join(QUI, 'fonts', fn), os.path.join(out, 'fonts', fn))
    css = tema_css(s).replace('url(fonts/', 'url(../fonts/') + open(os.path.join(QUI, 'base.css')).read()
    open(os.path.join(out, 'assets', 'style.css'), 'w').write(css)
    shutil.copy(os.path.join(QUI, 'site.js'), os.path.join(out, 'assets', 'site.js'))
    open(os.path.join(out, 'favicon.svg'), 'w').write(logo_svg(s).replace('<svg ', '<svg xmlns="http://www.w3.org/2000/svg" '))
    for fn, f in (('index.html', home), ('farmacia.html', farmacia), ('servizi.html', servizi), ('reparti.html', reparti),
                  ('offerte.html', offerte), ('turni.html', turni), ('contatti.html', contatti),
                  ('privacy.html', privacy), ('cookie.html', cookie)):
        open(os.path.join(out, fn), 'w').write(f(s))
    open(os.path.join(out, 'robots.txt'), 'w').write('User-agent: *\nAllow: /\n')
    open(os.path.join(out, 'README.md'), 'w').write(readme(s))


def indice(siti):
    cards = ''
    for s in siti:
        t = s['tema']
        cards += f'''<article class="sito" style="--p:{t['primario']};--a:{t['accento']};--s:{t['sfondo']}">
  <div class="anteprima"><iframe src="{s['slug']}/index.html" title="Anteprima {e(s['nome'])}" loading="lazy" tabindex="-1"></iframe></div>
  <div class="info"><h2>{e(s['nome'])}</h2>
  <p>{e(s['indirizzo'])} · {e(s['quartiere'])}, Municipio {s['municipio']}</p>
  <p class="pal"><span style="background:{t['primario']}"></span><span style="background:{t['accento']}"></span><span style="background:{t['sfondo']}"></span> {e(t['font_titoli'])} + {e(t['font_testo'])} · hero “{t['variante']}”</p>
  <p><a class="apri" href="{s['slug']}/index.html">Apri il sito</a> · <a href="{s['slug']}/README.md">Dati e punti da confermare</a></p></div>
</article>'''
    return f'''<!doctype html>
<html lang="it"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1">
<title>Siti demo farmacie Roma Nord</title>
<style>
body{{margin:0;font-family:system-ui,-apple-system,"Segoe UI",sans-serif;background:#f4f4f2;color:#1d1f24}}
header{{padding:2.5rem 16px 1rem;max-width:1200px;margin:auto}}
h1{{margin:0 0 .3rem;font-size:clamp(1.7rem,4vw,2.4rem)}}
header p{{margin:0;color:#5a5f6a;max-width:46em}}
main{{display:grid;grid-template-columns:repeat(auto-fit,minmax(320px,1fr));gap:1.4rem;max-width:1200px;margin:1.5rem auto 3rem;padding:0 16px}}
.sito{{background:#fff;border-radius:16px;overflow:hidden;box-shadow:0 10px 30px -18px rgba(0,0,0,.35);border-top:6px solid var(--p)}}
.anteprima{{height:300px;overflow:hidden;position:relative;background:var(--s)}}
.anteprima iframe{{width:1280px;height:1000px;border:0;transform:scale(.3);transform-origin:0 0;pointer-events:none;position:absolute;left:0;top:0}}
.info{{padding:1rem 1.2rem 1.3rem}}
.info h2{{margin:0 0 .3rem;font-size:1.25rem;color:var(--p)}}
.info p{{margin:.3rem 0;color:#4a4f5a;font-size:.93rem}}
.pal span{{display:inline-block;width:16px;height:16px;border-radius:50%;vertical-align:-3px;border:1px solid rgba(0,0,0,.12)}}
a{{color:var(--p,#1d2f4d);font-weight:600}}
@media (min-width:1100px){{.anteprima iframe{{transform:scale(.29)}}}}
</style></head><body>
<header><h1>Siti demo – farmacie di Roma Nord</h1>
<p>Prova della Fase 2: {len(siti)} siti costruiti sulla struttura del sito della Farmacia Spadazzi, ognuno con un'identità visiva propria e i dati reali raccolti nella Fase 1 (06/10/2026). Le parti gialle sono da confermare con il titolare.</p></header>
<main>{cards}</main>
</body></html>
'''


if __name__ == '__main__':
    siti = json.load(open(os.path.join(QUI, 'sites.json')))
    for s in siti:
        genera(s)
        print('generato', s['slug'])
    open(os.path.join(SITI, 'index.html'), 'w').write(indice(siti))
    print('generato index.html')
