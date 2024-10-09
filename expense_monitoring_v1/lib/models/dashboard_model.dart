class Dashboard {
  final double totalRevenue;
  final double totalExpense;
  final double profit;
  final double growthRate;
  final String reportDate;

  Dashboard({
    required this.totalRevenue,
    required this.totalExpense,
    required this.profit,
    required this.growthRate,
    required this.reportDate,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      totalRevenue: double.parse(json['totalRevenue'].toString()),
      totalExpense: double.parse(json['totalExpense'].toString()),
      profit: double.parse(json['profit'].toString()),
      growthRate: double.parse(json['growthRate'].toString()),
      reportDate: json['reportDate'],
    );
  }
}
