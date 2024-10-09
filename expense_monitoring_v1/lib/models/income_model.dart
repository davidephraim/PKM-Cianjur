// class Income {
//   final String dateTime;
//   final int transactionId;
//   final String nameProducts;
//   final int qtyProducts;
//   final double revenue;
//   final int userId;

//   Income({
//     required this.dateTime,
//     required this.transactionId,
//     required this.nameProducts,
//     required this.qtyProducts,
//     required this.revenue,
//     required this.userId,
//   });

//   factory Income.fromJson(List<dynamic> json, List<dynamic> headers) {
//     return Income(
//       dateTime: json[headers.indexOf("date_time")].toString(),
//       transactionId: json[headers.indexOf("transactions_id")],
//       nameProducts: json[headers.indexOf("name_products")].toString(),
//       qtyProducts: json[headers.indexOf("qty_products")],
//       revenue: json[headers.indexOf("revenue")].toDouble(),
//       userId: json[headers.indexOf("user_id")],
//     );
//   }
// }

class Income {
  final String dateTime;
  final String transactionId;
  final String productsName;
  final int qty;
  final double revenue;
  final int userId;

  Income({
    required this.dateTime,
    required this.transactionId,
    required this.productsName,
    required this.qty,
    required this.revenue,
    required this.userId,
  });

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      dateTime: json[0],
      transactionId: json[1],
      productsName: json[2],
      qty: int.parse(json[3]),
      revenue: double.parse(json[4]),
      userId: int.parse(json[5]),
    );
  }
}
