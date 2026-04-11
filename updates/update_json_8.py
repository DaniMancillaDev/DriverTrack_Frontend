import json

en_file = 'assets/i18n/en.i18n.json'
es_file = 'assets/i18n/es.i18n.json'

with open(en_file, 'r') as f:
    en = json.load(f)
with open(es_file, 'r') as f:
    es = json.load(f)

en['validators'] = {
  "requiredParams": "{field} is required",
  "notEmptyParams": "{field} cannot be empty",
  "minParams": "{field} must be at least {min}",
  "maxParams": "{field} cannot exceed {max}",
  "plateRequired": "License plate is required",
  "plateTooShort": "Plate is too short",
  "plateTooLong": "Plate is too long",
  "numberRequired": "Must be a valid number",
  "emailRequired": "Email is required",
  "emailInvalid": "Enter a valid email address",
  "passwordRequired": "Password is required",
  "passwordLength": "Password must be at least 8 characters",
  "passwordUppercase": "Must contain at least one uppercase letter",
  "passwordNumber": "Must contain at least one number",
  "nameRequired": "Full name is required",
  "nameLength": "Name must be at least 3 characters",
  "phoneRequired": "Phone number is required",
  "phoneLength": "Phone must be 10–15 digits",
  "dateRequired": "Date is required",
  "ageRequirement": "You must be at least 16 years old",
  "invalidDateFormat": "Invalid date format"
}

es['validators'] = {
  "requiredParams": "{field} es requerido",
  "notEmptyParams": "El campo {field} no puede estar vacío",
  "minParams": "{field} debe ser al menos {min}",
  "maxParams": "{field} no puede exceder {max}",
  "plateRequired": "La placa es obligatoria",
  "plateTooShort": "La placa es muy corta",
  "plateTooLong": "La placa es muy larga",
  "numberRequired": "Debe ser un número válido",
  "emailRequired": "El correo es obligatorio",
  "emailInvalid": "Ingresa un correo electrónico válido",
  "passwordRequired": "La contraseña es obligatoria",
  "passwordLength": "La contraseña debe tener al menos 8 caracteres",
  "passwordUppercase": "Debe contener al menos una letra mayúscula",
  "passwordNumber": "Debe contener al menos un número",
  "nameRequired": "El nombre completo es obligatorio",
  "nameLength": "El nombre debe tener al menos 3 caracteres",
  "phoneRequired": "El número de teléfono es obligatorio",
  "phoneLength": "El teléfono debe tener entre 10 y 15 dígitos",
  "dateRequired": "La fecha es requerida",
  "ageRequirement": "Debes tener al menos 16 años",
  "invalidDateFormat": "Formato de fecha inválido"
}

with open(en_file, 'w') as f:
    json.dump(en, f, indent=2, ensure_ascii=False)
with open(es_file, 'w') as f:
    json.dump(es, f, indent=2, ensure_ascii=False)

print("JSON updated")
