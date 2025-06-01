import 'package:api_flutter/data/datasources/coinmarketcap_datasource.dart';
import 'package:api_flutter/data/repositories/cripto_repository.dart';
import 'package:api_flutter/view/cripto_list_screen.dart';
import 'package:api_flutter/viewmodel/cripto_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CriptoViewModel(
            CriptoRepository(CoinMarketCapDataSource()),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Cripto App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const CriptoListScreen(),
      ),
    );
  }
}
