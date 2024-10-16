class Income {
  final String dateTime;
  final String transactionId;
  final String productsName;
  final int qtyProducts;
  final double revenue;
  final String userId;

  Income({
    required this.dateTime,
    required this.transactionId,
    required this.productsName,
    required this.qtyProducts,
    required this.revenue,
    required this.userId,
  });

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      dateTime: json['dateTime'],
      transactionId: json['transactionsId'],
      productsName: json['productsName'],
      qtyProducts: int.parse(json['qtyProducts']),
      revenue: double.parse(json['revenue']),
      userId: json['userId']
    );
  }
}
