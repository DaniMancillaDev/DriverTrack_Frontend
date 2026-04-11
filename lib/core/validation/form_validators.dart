import 'package:flutter/widgets.dart';
import '../i18n/translations.g.dart';

/// Clase de utilidad que centraliza la lógica de validación de entradas de usuario.
/// 
/// Provee métodos estáticos para validar campos comunes de formularios, 
/// asegurando que los mensajes de error estén internacionalizados mediante [Translations].
class FormValidators {
  /// Valida que una cadena de texto no esté vacía o compuesta solo por espacios.
  static String? notEmpty(
    String? value,
    String fieldName,
    BuildContext context,
  ) {
    if (value == null || value.trim().isEmpty) {
      return Translations.of(
        context,
      ).validators.notEmptyParams.replaceAll('{field}', fieldName);
    }
    return null;
  }

  /// Valida que un valor numérico se encuentre dentro de un rango inclusivo ([min], [max]).
  static String? range(
    num? value,
    num min,
    num max,
    String fieldName,
    BuildContext context,
  ) {
    if (value == null)
      return Translations.of(
        context,
      ).validators.requiredParams.replaceAll('{field}', fieldName);
    if (value < min)
      return Translations.of(context).validators.minParams
          .replaceAll('{field}', fieldName)
          .replaceAll('{min}', min.toString());
    if (value > max)
      return Translations.of(context).validators.maxParams
          .replaceAll('{field}', fieldName)
          .replaceAll('{max}', max.toString());
    return null;
  }

  /// Valida el formato de una placa de vehículo.
  /// 
  /// Verifica la longitud mínima y máxima permitida para asegurar identificadores válidos.
  static String? licensePlate(String? value, BuildContext context) {
    if (value == null || value.isEmpty)
      return Translations.of(context).validators.plateRequired;
    if (value.length < 3)
      return Translations.of(context).validators.plateTooShort;
    if (value.length > 10)
      return Translations.of(context).validators.plateTooLong;
    return null;
  }

  /// Valida un valor de kilometraje.
  /// 
  /// Asegura que el número sea positivo y no exceda el [max] lógico (por defecto 1,000,000).
  static String? mileage(
    String? value,
    BuildContext context, {
    num max = 1000000,
  }) {
    if (value == null || value.isEmpty)
      return Translations.of(context).validators.requiredParams.replaceAll(
        '{field}',
        Translations.of(context).maintenance.mileage,
      );
    final n = num.tryParse(value);
    if (n == null) return Translations.of(context).validators.numberRequired;
    return range(
      n,
      0,
      max,
      Translations.of(context).maintenance.mileage,
      context,
    );
  }

  /// Valida un valor de costo financiero.
  /// 
  /// Asegura que el monto sea un número válido y no exceda límites razonables de transacción.
  static String? cost(String? value, BuildContext context, {num max = 100000}) {
    if (value == null || value.isEmpty)
      return Translations.of(context).validators.requiredParams.replaceAll(
        '{field}',
        Translations.of(context).maintenance.costUsd,
      );
    final n = num.tryParse(value);
    if (n == null) return Translations.of(context).validators.numberRequired;
    return range(
      n,
      0,
      max,
      Translations.of(context).maintenance.costUsd,
      context,
    );
  }

  /// Valida que la cadena tenga un formato de correo electrónico estándar.
  static String? email(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty)
      return Translations.of(context).validators.emailRequired;
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value)) {
      return Translations.of(context).validators.emailInvalid;
    }
    return null;
  }

  /// Valida los requisitos de seguridad de una contraseña.
  /// 
  /// Si [isLogin] es verdadero, solo verifica que no esté vacía.
  /// En registro, requiere longitud mínima, mayúsculas y números.
  static String? password(
    String? value,
    BuildContext context, {
    bool isLogin = false,
  }) {
    if (value == null || value.isEmpty)
      return Translations.of(context).validators.passwordRequired;
    if (isLogin) return null; // Solo check de vacío para login

    if (value.length < 8)
      return Translations.of(context).validators.passwordLength;
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return Translations.of(context).validators.passwordUppercase;
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return Translations.of(context).validators.passwordNumber;
    }
    return null;
  }

  /// Valida un nombre completo (mínimo 3 caracteres).
  static String? fullName(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty)
      return Translations.of(context).validators.nameRequired;
    if (value.trim().length < 3)
      return Translations.of(context).validators.nameLength;
    return null;
  }

  /// Valida un número telefónico extrayendo solo dígitos.
  static String? phone(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty)
      return Translations.of(context).validators.phoneRequired;
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10 || digits.length > 15) {
      return Translations.of(context).validators.phoneLength;
    }
    return null;
  }

  /// Valida una fecha de nacimiento, exigiendo una edad mínima de 16 años.
  static String? birthDate(String? value, BuildContext context) {
    if (value == null || value.isEmpty)
      return Translations.of(context).validators.dateRequired;
    try {
      final dob = DateTime.parse(value);
      final age = DateTime.now().difference(dob).inDays / 365.25;
      if (age < 16) return Translations.of(context).validators.ageRequirement;
    } catch (e) {
      return Translations.of(context).validators.invalidDateFormat;
    }
    return null;
  }
}
