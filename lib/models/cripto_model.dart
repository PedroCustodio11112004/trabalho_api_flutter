class CriptoModel {
  final String id;
  final String name;
  final String symbol;
  final String dateAdded;
  final double priceUsd;
  final double priceBrl;

  CriptoModel({
    required this.id,
    required this.name,
    required this.symbol,
    required this.dateAdded,
    required this.priceUsd,
    required this.priceBrl,
  });

  factory CriptoModel.fromJson(Map<String, dynamic> json) {
    final quote = json['quote'] as Map<String, dynamic>? ?? {};
    final usdData = quote['USD'] as Map<String, dynamic>? ?? {'price': 0.0};
    const double usdToBrl = 5.6;

    return CriptoModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
      dateAdded: json['date_added'] ?? '',
      priceUsd: double.tryParse(usdData['price'].toString()) ?? 0.0,
      priceBrl: (double.tryParse(usdData['price'].toString()) ?? 0.0) * usdToBrl,
    );
  }
}