import json

en_file = 'assets/i18n/en.i18n.json'
es_file = 'assets/i18n/es.i18n.json'

with open(en_file, 'r', encoding='utf-8') as f:
    en = json.load(f)
with open(es_file, 'r', encoding='utf-8') as f:
    es = json.load(f)

en['currency'] = {
    "title": "Currency Converter",
    "refreshTooltip": "Refresh Rate",
    "amountLabel": "Amount ({code})",
    "swapTooltip": "Swap Currencies",
    "convertedAmount": "Converted Amount",
    "rateLabel": "Rate: 1 {from} = {rate} {to}",
    "errorLoad": "Failed to load exchange rates",
    "tryAgain": "Try Again"
}

es['currency'] = {
    "title": "Convertidor de Divisas",
    "refreshTooltip": "Actualizar Tasa",
    "amountLabel": "Monto ({code})",
    "swapTooltip": "Intercambiar Divisas",
    "convertedAmount": "Monto Convertido",
    "rateLabel": "Tasa: 1 {from} = {rate} {to}",
    "errorLoad": "Error al cargar tasas de cambio",
    "tryAgain": "Reintentar"
}

with open(en_file, 'w', encoding='utf-8') as f:
    json.dump(en, f, indent=2, ensure_ascii=False)
with open(es_file, 'w', encoding='utf-8') as f:
    json.dump(es, f, indent=2, ensure_ascii=False)

print("Currency translations added")
