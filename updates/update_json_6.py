import json

en_file = 'assets/i18n/en.i18n.json'
es_file = 'assets/i18n/es.i18n.json'

with open(en_file, 'r') as f:
    en = json.load(f)
with open(es_file, 'r') as f:
    es = json.load(f)

en['profile']['favoritesSaved'] = {
    "one": "1 favorite saved",
    "zero": "No favorites saved",
    "other": "{count} favorites saved"
}

es['profile']['favoritesSaved'] = {
    "one": "1 favorito guardado",
    "zero": "Sin favoritos guardados",
    "other": "{count} favoritos guardados"
}

with open(en_file, 'w') as f:
    json.dump(en, f, indent=2, ensure_ascii=False)
with open(es_file, 'w') as f:
    json.dump(es, f, indent=2, ensure_ascii=False)

print("JSON updated")
