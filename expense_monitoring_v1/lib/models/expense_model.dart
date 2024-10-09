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

class Expense {
  final String dateTime;
  final String transactionId;
  final String productsName;
  final int expenseAmounts;
  final double revenue;
  final int user_id;

  Expense({
    required this.dateTime,
    required this.transactionId,
    required this.productsName,
    required this.expenseAmounts,
    required this.revenue,
    required this.user_id,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      dateTime: json[0],
      transactionId: json[1],
      productsName: json[2],
      expenseAmounts: int.parse(json[3]),
      revenue: double.parse(json[4]),
      user_id: int.parse(json[5]),
    );
  }
}
