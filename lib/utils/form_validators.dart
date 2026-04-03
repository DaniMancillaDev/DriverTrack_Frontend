import 'package:flutter/widgets.dart';
import '../core/i18n/translations.g.dart';

class FormValidators {
  /// Validates that a string is not empty.
  static String? notEmpty(String? value, String fieldName, BuildContext context) {
    if (value == null || value.trim().isEmpty) {
      return Translations.of(context).validators.notEmptyParams.replaceAll('{field}', fieldName);
    }
    return null;
  }

  /// Validates that a number is within a specific range.
  static String? range(num? value, num min, num max, String fieldName, BuildContext context) {
    if (value == null) return Translations.of(context).validators.requiredParams.replaceAll('{field}', fieldName);
    if (value < min) return Translations.of(context).validators.minParams.replaceAll('{field}', fieldName).replaceAll('{min}', min.toString());
    if (value > max) return Translations.of(context).validators.maxParams.replaceAll('{field}', fieldName).replaceAll('{max}', max.toString());
    return null;
  }

  /// Validates a license plate format (simplified example).
  static String? licensePlate(String? value, BuildContext context) {
    if (value == null || value.isEmpty) return Translations.of(context).validators.plateRequired;
    if (value.length < 3) return Translations.of(context).validators.plateTooShort;
    if (value.length > 10) return Translations.of(context).validators.plateTooLong;
    return null;
  }

  /// Validates a mileage value.
  static String? mileage(String? value, BuildContext context, {num max = 1000000}) {
    if (value == null || value.isEmpty) return Translations.of(context).validators.requiredParams.replaceAll('{field}', Translations.of(context).maintenance.mileage);
    final n = num.tryParse(value);
    if (n == null) return Translations.of(context).validators.numberRequired;
    return range(n, 0, max, Translations.of(context).maintenance.mileage, context);
  }

  /// Validates a cost value.
  static String? cost(String? value, BuildContext context, {num max = 100000}) {
    if (value == null || value.isEmpty) return Translations.of(context).validators.requiredParams.replaceAll('{field}', Translations.of(context).maintenance.costUsd);
    final n = num.tryParse(value);
    if (n == null) return Translations.of(context).validators.numberRequired;
    return range(n, 0, max, Translations.of(context).maintenance.costUsd, context);
  }

  /// Validates an email address.
  static String? email(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) return Translations.of(context).validators.emailRequired;
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value)) {
      return Translations.of(context).validators.emailInvalid;
    }
    return null;
  }

  /// Validates a password.
  static String? password(String? value, BuildContext context, {bool isLogin = false}) {
    if (value == null || value.isEmpty) return Translations.of(context).validators.passwordRequired;
    if (isLogin) return null; // Only check emptiness for login

    if (value.length < 8) return Translations.of(context).validators.passwordLength;
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return Translations.of(context).validators.passwordUppercase;
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return Translations.of(context).validators.passwordNumber;
    }
    return null;
  }

  /// Validates a full name.
  static String? fullName(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) return Translations.of(context).validators.nameRequired;
    if (value.trim().length < 3) return Translations.of(context).validators.nameLength;
    return null;
  }

  /// Validates a phone number.
  static String? phone(String? value, BuildContext context) {
    if (value == null || value.trim().isEmpty) return Translations.of(context).validators.phoneRequired;
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10 || digits.length > 15) {
      return Translations.of(context).validators.phoneLength;
    }
    return null;
  }

  /// Validates a birth date (must be at least 16 years old).
  static String? birthDate(String? value, BuildContext context) {
    if (value == null || value.isEmpty) return Translations.of(context).validators.dateRequired;
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
