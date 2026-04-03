import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/error/failures.dart';
import '../../domain/entities/currency.dart';
import '../models/exchange_rate_model.dart';

abstract class CurrencyRemoteDataSource {
  /// Calls the ExchangeRate-API endpoint for the latest conversion rates.
  /// Throws a [ServerFailure] for all error codes.
  Future<ExchangeRateModel> getExchangeRate(Currency base, Currency target);
}

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final http.Client client;
  
  // API Key de la cuenta gratuita registrada
  static const String apiKey = 'a94251bcd965538d6428b6a6';

  CurrencyRemoteDataSourceImpl({required this.client});

  @override
  Future<ExchangeRateModel> getExchangeRate(Currency base, Currency target) async {
    // URL de la Versión 6 que utiliza la API Key
    final urlStr = 'https://v6.exchangerate-api.com/v6/$apiKey/latest/${base.code}';
    
    final url = Uri.parse(urlStr);
    
    try {
      final response = await client.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = json.decode(response.body);
        return ExchangeRateModel.fromJson(jsonMap, target);
      } else {
        throw ServerFailure('Failed to fetch exchange rate: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerFailure) rethrow;
      throw ServerFailure('Unable to connect to ExchangeRate-API');
    }
  }
}
