import 'package:api_flutter/data/datasources/coinmarketcap_datasource.dart';
import 'package:api_flutter/models/cripto_model.dart';

class CriptoRepository {
  final CoinMarketCapDataSource dataSource;

  CriptoRepository(this.dataSource);

  Future<List<CriptoModel>> getCriptoList({String? symbols}) async {
    final result = await dataSource.getCriptoList(symbols: symbols);
    return result;
  }
}