import json

en_file = 'assets/i18n/en.i18n.json'
es_file = 'assets/i18n/es.i18n.json'

with open(en_file, 'r') as f:
    en = json.load(f)
with open(es_file, 'r') as f:
    es = json.load(f)

en['garage']['recentServiceLabel'] = "LAST SERVICE"
en['garage']['recentMaintenance'] = "RECENT MAINTENANCE"
en['garage']['recordsCount'] = {
    "one": "1 record",
    "zero": "0 records",
    "other": "{count} records"
}

es['garage']['recentServiceLabel'] = "ÚLTIMO"
es['garage']['recentMaintenance'] = "MANTENIMIENTO RECIENTE"
es['garage']['recordsCount'] = {
    "one": "1 registro",
    "zero": "0 registros",
    "other": "{count} registros"
}

with open(en_file, 'w') as f:
    json.dump(en, f, indent=2, ensure_ascii=False)
with open(es_file, 'w') as f:
    json.dump(es, f, indent=2, ensure_ascii=False)

print("JSON updated")
