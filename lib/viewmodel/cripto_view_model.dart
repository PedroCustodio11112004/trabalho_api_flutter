import 'package:api_flutter/data/repositories/cripto_repository.dart';
import 'package:api_flutter/models/cripto_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class CriptoViewModel extends ChangeNotifier{
  final CriptoRepository repository;
  List<CriptoModel> criptoList = [];
  bool isLoading = false;
  String? errorMessage;
  String searchQuery = '';

  CriptoViewModel(this.repository);

  Future<void> fetchCriptoList() async {

    var connectivityResult = await Connectivity().checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.mobile) && 
        !connectivityResult.contains(ConnectivityResult.wifi)) {
          errorMessage = 'Sem conexão com a internet';
          isLoading = false;
          notifyListeners();
          return;
        }

        isLoading = true;
        errorMessage = null;
        notifyListeners();

        try{
          criptoList = await repository.getCriptoList(symbols:searchQuery.isEmpty ? null : searchQuery);
        } catch (e) {
          errorMessage = e.toString();
        }

        isLoading = false;
        notifyListeners();
  }
  
  void updateSearchQuery(String query) {
    searchQuery = query.trim().replaceAll(' ', '');
    fetchCriptoList();
  }
}