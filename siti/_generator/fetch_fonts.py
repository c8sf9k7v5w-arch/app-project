"""Scarica in locale (self-hosting, niente richieste a Google dal sito) i font OFL usati dai siti."""
import re, sys, urllib.request, ssl, os, json
CA = os.environ.get('SSL_CERT_FILE', '/root/.ccr/ca-bundle.crt')
ctx = ssl.create_default_context(cafile=CA) if os.path.exists(CA) else ssl.create_default_context()
UA = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/124 Safari/537.36'}
FONTS = {  # famiglia -> pesi
    'Fraunces': [600, 700], 'Inter': [400, 600],
    'DM Serif Display': [400], 'DM Sans': [400, 600],
    'Outfit': [500, 700], 'Nunito Sans': [400, 700],
}
out = os.path.join(os.path.dirname(__file__), 'fonts'); os.makedirs(out, exist_ok=True)
for fam, weights in FONTS.items():
    for w in weights:
        url = 'https://fonts.googleapis.com/css2?family=' + fam.replace(' ', '+') + f':wght@{w}&display=swap'
        css = urllib.request.urlopen(urllib.request.Request(url, headers=UA), context=ctx).read().decode()
        latin = [b for b in css.split('/*') if b.strip().startswith('latin */')][0]
        src = re.search(r'url\((https://[^)]+\.woff2)\)', latin).group(1)
        fn = f"{fam.replace(' ', '')}-{w}.woff2"
        open(os.path.join(out, fn), 'wb').write(urllib.request.urlopen(urllib.request.Request(src, headers=UA), context=ctx).read())
        print('ok', fn)
