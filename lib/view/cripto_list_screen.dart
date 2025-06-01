import 'package:api_flutter/models/cripto_model.dart';
import 'package:api_flutter/viewmodel/cripto_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CriptoListScreen extends StatefulWidget {
  const CriptoListScreen({super.key});

  @override
  State<CriptoListScreen> createState() => _CriptoListScreenState();
}

class _CriptoListScreenState extends State<CriptoListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CriptoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cripto Moedas'),
      ),
      body: RefreshIndicator(
        onRefresh: () => viewModel.fetchCriptoList(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Pesquisar (ex.: BTC,ETH,SOL,BNB,BCH,MKR,AAVE,DOT,SUI,ADA)',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
                onSubmitted: (value) {
                  viewModel.updateSearchQuery(value);
                  _searchController.clear(); 
                },
              ),
            ),
            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.errorMessage != null
                      ? Center(child: Text(viewModel.errorMessage!))
                      : viewModel.criptoList.isEmpty
                          ? const Center(child: Text('Nenhum resultado encontrado'))
                          : ListView.builder(
                              itemCount: viewModel.criptoList.length,
                              itemBuilder: (context, index) {
                                final cripto = viewModel.criptoList[index];
                                final formatoUSD = NumberFormat.currency(locale: 'en_US', symbol: '\$');
                                final formatoBRL = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
                                return ListTile(
                                  title: Text('${cripto.name} (${cripto.symbol})'), 
                                  subtitle: Text(
                                    'USD: ${formatoUSD.format(cripto.priceUsd)}\nBRL: ${formatoBRL.format(cripto.priceBrl)}', 
                                  ),
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => _buildBottomSheet(cripto),
                                    );
                                  },
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.fetchCriptoList(),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildBottomSheet(CriptoModel cripto) {
    final formatoUSD = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    final formatoBRL = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nome: ${cripto.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Símbolo: ${cripto.symbol}'), 
          Text('Data de Adição: ${cripto.dateAdded}'), 
          Text('Preço USD: ${formatoUSD.format(cripto.priceUsd)}'), 
          Text('Preço BRL: ${formatoBRL.format(cripto.priceBrl)}'), 
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fechar'),
            ),
          ),
        ],
      ),
    );
  }
}