import json

en_file = 'assets/i18n/en.i18n.json'
es_file = 'assets/i18n/es.i18n.json'

with open(en_file, 'r') as f:
    en = json.load(f)
with open(es_file, 'r') as f:
    es = json.load(f)

en['currency'].update({
    "refreshRate": "Refresh Rate",
    "amountLabel": "Amount ({code})",
    "swapCurrencies": "Swap Currencies",
    "convertedAmount": "Converted Amount",
    "rateDesc": "Rate: 1 {from} = {rate} {to}",
    "errorLoadingRates": "Failed to load exchange rates",
    "tryAgain": "Try Again"
})

es['currency'].update({
    "refreshRate": "Actualizar tasa",
    "amountLabel": "Monto ({code})",
    "swapCurrencies": "Intercambiar divisas",
    "convertedAmount": "Monto convertido",
    "rateDesc": "Tasa: 1 {from} = {rate} {to}",
    "errorLoadingRates": "Error al cargar tasas de cambio",
    "tryAgain": "Intentar de nuevo"
})

with open(en_file, 'w') as f:
    json.dump(en, f, indent=2, ensure_ascii=False)
with open(es_file, 'w') as f:
    json.dump(es, f, indent=2, ensure_ascii=False)

print("JSON updated")
