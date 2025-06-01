import 'dart:convert';
import 'package:api_flutter/models/cripto_model.dart';
import 'package:http/http.dart' as http;

class CoinMarketCapDataSource {
  final String apiKey = '19ac10df-1588-462f-9787-fd85f3e9c237';
  final String baseUrl = 'https://pro-api.coinmarketcap.com';
  final String simbolosDefault = 'BTC,ETH,SOL,BNB,BCH,MKR,AAVE,DOT,SUI,ADA,XRP,TIA,NEO,NEAR,PENDLE,RENDER,LINK,TON,XAI,SEI,IMX,ETHFI,UMA,SUPER,FET,USUAL,GALA,PAAL,AERO';

  Future<List<CriptoModel>> getCriptoList({String? symbols}) async {
    final uri = Uri.parse('$baseUrl/v2/cryptocurrency/quotes/latest?symbol=${symbols ?? simbolosDefault}&convert=USD');
    final response = await http.get(
      uri,
      headers: {
        'Accept': 'application/json',
        'X-CMC_PRO_API_KEY': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final dynamic criptoData = data['data'];
      List<CriptoModel> criptoList = [];

      if (criptoData is Map<String, dynamic>) {
        criptoData.forEach((symbol, value) {
          if (value is List<dynamic>) {
            for (var item in value) {
              if (item is Map<String, dynamic> && item.containsKey('id') && item.containsKey('name')) {
                criptoList.add(CriptoModel.fromJson(item));
              }
            }
          }
        });
      } else if (criptoData is List<dynamic>) {
        for (var item in criptoData) {
          if (item is Map<String, dynamic> && item.containsKey('id') && item.containsKey('name')) {
            criptoList.add(CriptoModel.fromJson(item));
          }
        }
      } else {
        throw Exception('Formato de dados inesperado: ${criptoData.runtimeType}');
      }

      return criptoList;
    } else {
      final errorData = jsonDecode(response.body);
      final errorMessage = errorData['status']?['error_message'] ?? 'Erro desconhecido';
      throw Exception('Erro na API: ${response.statusCode} - $errorMessage');
    }
  }
}