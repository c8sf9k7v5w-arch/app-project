"""Testi e icone condivisi: servizi e reparti.

I testi sono informativi e neutri (niente promesse terapeutiche, niente prezzi),
in linea con le regole sulla pubblicità sanitaria. Ogni farmacia sceglie quali
voci mostrare in sites.json.
"""

# Icone: path SVG 24x24, tratto (stroke) - disegnate a mano, nessuna risorsa esterna.
ICONE = {
    'cuore': '<path d="M12 20s-7-4.4-7-10a4 4 0 0 1 7-2.6A4 4 0 0 1 19 10c0 5.6-7 10-7 10z"/><path d="M5.5 12h3l1.5-3 2 6 1.5-3h5"/>',
    'onda': '<path d="M3 12h4l2-6 4 12 2-6h6"/>',
    'manicotto': '<circle cx="12" cy="13" r="6"/><path d="M12 13l3-2"/><path d="M9 3h6"/><path d="M12 3v4"/>',
    'calendario': '<rect x="3.5" y="5" width="17" height="15" rx="2"/><path d="M3.5 10h17M8 3v4M16 3v4"/><path d="M8 14h3v3H8z"/>',
    'polmoni': '<path d="M12 4v8"/><path d="M12 10c-2 0-3-2-5-2-2 0-3 3-3 7 0 3 2 4 4 4s4-1 4-4z"/><path d="M12 10c2 0 3-2 5-2 2 0 3 3 3 7 0 3-2 4-4 4s-4-1-4-4z"/>',
    'goccia': '<path d="M12 3s6 6.5 6 11a6 6 0 0 1-12 0c0-4.5 6-11 6-11z"/><path d="M9.5 14.5a2.5 2.5 0 0 0 2.5 2.5"/>',
    'lista': '<rect x="5" y="3.5" width="14" height="17" rx="2"/><path d="M9 3.5h6v3H9z"/><path d="M8.5 11h7M8.5 14.5h7M8.5 18h4"/>',
    'tampone': '<path d="M5 19L15 9"/><rect x="14" y="3" width="7" height="7" rx="3.5" transform="rotate(45 17.5 6.5)"/>',
    'scudo': '<path d="M12 3l7 3v5c0 5-3.2 8.3-7 10-3.8-1.7-7-5-7-10V6z"/><path d="M9 12l2 2 4-4"/>',
    'siringa': '<path d="M14 4l6 6M17 7l-9 9-4 1 1-4 9-9"/><path d="M11 10l3 3"/>',
    'pillola': '<rect x="3" y="8.5" width="18" height="7" rx="3.5" transform="rotate(-35 12 12)"/><path d="M10 9l5 6"/>',
    'furgone': '<path d="M3 7h11v9H3zM14 10h4l3 3v3h-7"/><circle cx="7" cy="17.5" r="1.8"/><circle cx="17" cy="17.5" r="1.8"/>',
    'orecchino': '<path d="M9 8a4 4 0 1 1 6 3.5c-1 .6-1.5 1.5-1.5 2.5v1a2.5 2.5 0 0 1-5 0"/><circle cx="17" cy="18" r="2"/>',
    'bilancia': '<rect x="4" y="4" width="16" height="16" rx="3"/><path d="M8.5 9a3.5 3.5 0 0 1 7 0z"/><path d="M12 9l1.2-2"/>',
    'mortaio': '<path d="M4 11h16l-2 7H6z"/><path d="M14 11l5-7"/><path d="M8 18v2h8v-2"/>',
    'foglia': '<path d="M5 19c0-8 5-14 15-14 0 10-6 15-14 15"/><path d="M5 19l8-8"/>',
    'zampa': '<circle cx="7" cy="9" r="1.8"/><circle cx="11" cy="6" r="1.8"/><circle cx="15" cy="6.5" r="1.8"/><circle cx="18" cy="10" r="1.8"/><path d="M8 16c0-3 2-5 4.5-5s4.5 2 4.5 4.5c0 2-1.5 3.5-4.5 3.5S8 18 8 16z"/>',
    'biberon': '<path d="M10 3h4l1 4H9z"/><rect x="8" y="7" width="8" height="14" rx="3"/><path d="M8 12h8M8 16h8"/>',
    'stelle': '<path d="M12 4l1.6 4.4L18 10l-4.4 1.6L12 16l-1.6-4.4L6 10l4.4-1.6z"/><path d="M18.5 15.5l.7 1.8 1.8.7-1.8.7-.7 1.8-.7-1.8-1.8-.7 1.8-.7z"/>',
    'spiga': '<path d="M12 21V8"/><path d="M12 12c-2.5 0-4-1.5-4-4 2.5 0 4 1.5 4 4zM12 12c2.5 0 4-1.5 4-4-2.5 0-4 1.5-4 4zM12 8c-2 0-3-1.2-3-3.2 2 0 3 1.2 3 3.2zM12 8c2 0 3-1.2 3-3.2-2 0-3 1.2-3 3.2z"/><path d="M4 4l16 16"/>',
    'croce': '<path d="M9 3h6v6h6v6h-6v6H9v-6H3V9h6z"/>',
    'stampella': '<path d="M9 3h6M12 3v18M8 9h8"/><path d="M10 21h4"/>',
    'telefono': '<path d="M5 4h3l2 5-2.5 1.5a11 11 0 0 0 6 6L15 14l5 2v3a2 2 0 0 1-2 2A16 16 0 0 1 3 6a2 2 0 0 1 2-2z"/>',
    'chat': '<path d="M4 18.5l1.2-3.6A8 8 0 1 1 8.6 18z"/><path d="M9.5 9.5c0 3 2 5 5 5l1-1.5-2-1-1 1c-1-.5-1.5-1-2-2l1-1-1-2z"/>',
    'pin': '<path d="M12 21s7-6.2 7-11.5A7 7 0 0 0 5 9.5C5 14.8 12 21 12 21z"/><circle cx="12" cy="9.5" r="2.5"/>',
    'orologio': '<circle cx="12" cy="12" r="8.5"/><path d="M12 7.5V12l3 2"/>',
    'mail': '<rect x="3.5" y="5.5" width="17" height="13" rx="2"/><path d="M4 7l8 6 8-6"/>',
    'menu': '<path d="M4 7h16M4 12h16M4 17h16"/>',
    'freccia': '<path d="M5 12h14M13 6l6 6-6 6"/>',
    'luna': '<path d="M19 14.5A7.5 7.5 0 0 1 9.5 5a7.5 7.5 0 1 0 9.5 9.5z"/>',
}

SERVIZI = {
    'ecg': ('Elettrocardiogramma (ECG)', 'cuore', 'telemedicina',
            "Registrazione dell'ECG in farmacia con refertazione a distanza da parte di un cardiologo, in genere entro poche ore."),
    'holter-cardiaco': ('Holter cardiaco', 'onda', 'telemedicina',
                        "Monitoraggio dell'attività del cuore per 24 ore con un piccolo registratore portatile; il tracciato viene refertato da un medico specialista."),
    'holter-pressorio': ('Holter pressorio', 'manicotto', 'telemedicina',
                         'Misurazione automatica della pressione arteriosa nell\'arco di 24 ore, con referto dello specialista.'),
    'cup': ('Prenotazioni CUP', 'calendario', 'servizi',
            'Prenotazione di visite ed esami del Servizio Sanitario Regionale direttamente al banco, con la ricetta del medico.'),
    'spirometria': ('Spirometria', 'polmoni', 'telemedicina',
                    'Esame semplice e non invasivo che misura la capacità respiratoria; il risultato viene valutato da uno specialista.'),
    'autoanalisi': ('Autoanalisi del sangue', 'goccia', 'esami',
                    'Controllo rapido di parametri come glicemia, colesterolo e trigliceridi da una goccia di sangue capillare.'),
    'intolleranze': ('Test per intolleranze alimentari', 'lista', 'esami',
                     'Test di orientamento disponibili in farmacia: chiedici quali sono e come prepararti.'),
    'pressione': ('Misurazione della pressione', 'manicotto', 'servizi',
                  'Misurazione della pressione arteriosa al banco, con apparecchi validati.'),
    'tampone': ('Tampone rapido', 'tampone', 'esami',
                'Test antigenici rapidi su campione nasale o orofaringeo, con esito in pochi minuti.'),
    'streptococco': ('Test dello streptococco', 'tampone', 'esami',
                     'Test rapido sul tampone faringeo per la ricerca dello streptococco.'),
    'colon-retto': ('Screening del colon-retto', 'scudo', 'servizi',
                    'Ritiro e riconsegna del kit per lo screening regionale gratuito del colon-retto, per le persone nella fascia d\'età prevista.'),
    'infezioni-urinarie': ('Test per infezioni urinarie', 'lista', 'esami',
                           'Test rapido su campione di urina, utile come primo orientamento da condividere con il medico.'),
    'foratura-lobi': ('Foratura dei lobi', 'orecchino', 'servizi',
                      'Foratura dei lobi con dispositivi sterili monouso e orecchini anallergici.'),
    'vaccino-influenza': ('Vaccinazione antinfluenzale', 'siringa', 'servizi',
                          'Vaccinazione antinfluenzale in farmacia durante la campagna regionale, per gli adulti che ne hanno diritto.'),
    'aderenza': ('Supporto alla terapia', 'pillola', 'servizi',
                 'Ti aiutiamo a organizzare orari e dosi dei farmaci prescritti dal medico, con promemoria personalizzati.'),
    'noleggio-bilance': ('Noleggio bilance pesa-neonati', 'bilancia', 'servizi',
                         'Noleggio di bilance per neonati: chiedi disponibilità e modalità al banco.'),
    'galenica-servizio': ('Preparazioni galeniche', 'mortaio', 'servizi',
                          'Preparazioni magistrali su ricetta medica, allestite nel laboratorio della farmacia.'),
    'consegna': ('Consegna a domicilio', 'furgone', 'servizi',
                 'Per chi non può muoversi, prepariamo l\'ordine e lo consegniamo a casa. Chiedi orari e zone servite.'),
}

CATEGORIE = {'telemedicina': 'Telemedicina', 'esami': 'Esami rapidi', 'servizi': 'Servizi alla persona'}

REPARTI = {
    'dermocosmesi': ('Dermocosmesi', 'stelle', 'Detergenza, protezione solare e cura della pelle, con il consiglio per il tuo tipo di pelle.'),
    'omeopatia': ('Omeopatia', 'goccia', 'Una selezione di prodotti omeopatici, disponibili anche su ordinazione.'),
    'veterinaria': ('Veterinaria', 'zampa', 'Farmaci veterinari su ricetta, antiparassitari e prodotti per la cura degli animali.'),
    'senza-glutine': ('Senza glutine', 'spiga', 'Alimenti senza glutine, anche con buoni del Servizio Sanitario per le persone celiache.'),
    'integratori': ('Integratori', 'pillola', 'Vitamine, minerali e integratori: ti aiutiamo a orientarti nella scelta.'),
    'infanzia': ('Mamma e bambino', 'biberon', 'Alimentazione, igiene e accessori per la prima infanzia.'),
    'galenica': ('Laboratorio galenico', 'mortaio', 'Preparazioni su misura allestite in farmacia, su ricetta medica.'),
    'erboristeria': ('Erboristeria e fitoterapia', 'foglia', 'Tisane, estratti e prodotti a base vegetale.'),
    'articoli-sanitari': ('Articoli sanitari', 'stampella', 'Ausili, medicazioni e dispositivi per la casa.'),
}

CONSIGLI = [
    ('Come conservare i farmaci a casa',
     'Luogo fresco e asciutto, lontano da luce e bambini: il bagno non è il posto migliore. '
     'Tieni la confezione originale con il foglietto illustrativo e controlla periodicamente le scadenze; '
     'i farmaci scaduti vanno gettati negli appositi contenitori per la raccolta, presenti in molte farmacie.'),
    ('Misurare la pressione nel modo giusto',
     'Siediti e riposa qualche minuto, con il braccio appoggiato all\'altezza del cuore. '
     'Evita caffè e fumo nella mezz\'ora prima, e annota i valori per mostrarli al tuo medico. '
     'Se hai dubbi sull\'apparecchio di casa, portalo: lo confrontiamo con il nostro.'),
    ('Viaggi: cosa mettere nel kit',
     'Cerotti, disinfettante, termometro, i farmaci che usi abitualmente in quantità sufficiente e la copia delle ricette. '
     'Per le mete lontane chiedi al medico con anticipo: insieme prepariamo la lista.'),
]
