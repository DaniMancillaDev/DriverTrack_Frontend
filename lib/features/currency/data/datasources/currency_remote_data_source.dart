import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/error/failures.dart';
import '../../domain/entities/currency.dart';
import '../models/exchange_rate_model.dart';

/// Interfaz para la obtención de datos de divisas desde servicios externos.
abstract class CurrencyRemoteDataSource {
  /// Solicita las últimas tasas de cambio para una moneda base.
  /// 
  /// Lanza un [ServerFailure] si la respuesta no es 200 o si hay errores de red.
  Future<ExchangeRateModel> getExchangeRate(Currency base, Currency target);
}

/// Implementación de la fuente de datos remota mediante [ExchangeRate-API].
class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final http.Client client;

  /// Clave de API registrada para el servicio ExchangeRate-API.
  static const String apiKey = 'a94251bcd965538d6428b6a6';

  CurrencyRemoteDataSourceImpl({required this.client});

  @override
  Future<ExchangeRateModel> getExchangeRate(
    Currency base,
    Currency target,
  ) async {
    // Endpoint oficial v6 para tasas 'latest'
    final urlStr =
        'https://v6.exchangerate-api.com/v6/$apiKey/latest/${base.code}';

    final url = Uri.parse(urlStr);

    try {
      final response = await client
          .get(url)
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        return ExchangeRateModel.fromJson(jsonMap, target);
      } else {
        throw ServerFailure(
          'Error al obtener tasa: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw ServerFailure('Error de conexión con ExchangeRate-API');
    }
  }
}
