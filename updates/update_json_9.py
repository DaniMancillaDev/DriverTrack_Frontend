import json

es_file = 'assets/i18n/es.i18n.json'

with open(es_file, 'r') as f:
    es = json.load(f)

es['garage']['plateNotSet'] = "Matrícula no configurada"
es['validators']['plateRequired'] = "La matrícula es obligatoria"
es['validators']['plateTooShort'] = "La matrícula es muy corta"
es['validators']['plateTooLong'] = "La matrícula es muy larga"

with open(es_file, 'w') as f:
    json.dump(es, f, indent=2, ensure_ascii=False)

print("JSON updated")
