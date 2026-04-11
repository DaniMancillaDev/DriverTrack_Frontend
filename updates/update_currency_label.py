import json

en_file = 'assets/i18n/en.i18n.json'
es_file = 'assets/i18n/es.i18n.json'

with open(en_file, 'r', encoding='utf-8') as f:
    en = json.load(f)
with open(es_file, 'r', encoding='utf-8') as f:
    es = json.load(f)

en['currency']['converterLabel'] = "CURRENCY CONVERTER"
es['currency']['converterLabel'] = "CONVERTIDOR DE DIVISAS"

with open(en_file, 'w', encoding='utf-8') as f:
    json.dump(en, f, indent=2, ensure_ascii=False)
with open(es_file, 'w', encoding='utf-8') as f:
    json.dump(es, f, indent=2, ensure_ascii=False)

print("Currency label added")
