class Expense {
  final String dateTime;
  final String transactionId;
  final String expenseName;
  final int qtyProducts;
  final double expenseAmount;
  final String userId;

  Expense({
    required this.dateTime,
    required this.transactionId,
    required this.expenseName,
    required this.qtyProducts,
    required this.expenseAmount,
    required this.userId,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      dateTime: json['dateTime'],
      transactionId: json['transactionsId'],
      expenseName: json['expenseName'],
      qtyProducts: int.parse(json['qtyProducts']),
      expenseAmount: double.parse(json['expenseAmounts']),
      userId: json['userId']
    );
  }
}
