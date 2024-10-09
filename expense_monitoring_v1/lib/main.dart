// import 'package:flutter/material.dart';
// import 'api_service.dart';

// void main() {
//   runApp(ExpenseMonitoringApp());
// }

// class ExpenseMonitoringApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Expense Monitoring',
//       home: IncomeScreen(),
//     );
//   }
// }

// // Income Screen
// class IncomeScreen extends StatefulWidget {
//   @override
//   _IncomeScreenState createState() => _IncomeScreenState();
// }

// class _IncomeScreenState extends State<IncomeScreen> {
//   final ApiService apiService = ApiService();
//   late Future<List<dynamic>> incomeData;

//   @override
//   void initState() {
//     super.initState();
//     incomeData = apiService.fetchIncome();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Income Data'),
//       ),
//       body: FutureBuilder<List<dynamic>>(
//         future: incomeData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             final incomeList = snapshot.data!;
//             return ListView.builder(
//               itemCount: incomeList.length,
//               itemBuilder: (context, index) {
//                 final income = incomeList[index];
//               return ListTile(
//                 title: Text('Product: ${income.nameProducts}'),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text('Date: ${income.dateTime}'),
//                     Text('Quantity: ${income.qtyProducts}'),
//                     Text('Revenue: ${income.revenue.toStringAsFixed(2)}'),
//                     Text('Transaction ID: ${income.transactionId}'),
//                     Text('User ID: ${income.userId}'),
//                   ],
//                 ),
//               );
//               },
//             );
//           } else {
//             return Center(child: Text('No data available'));
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'api_service.dart';

void main() {
  runApp(ExpenseMonitoringApp());
}

class ExpenseMonitoringApp extends StatefulWidget {
  @override
  _ExpenseMonitoringAppState createState() => _ExpenseMonitoringAppState();
}

class _ExpenseMonitoringAppState extends State<ExpenseMonitoringApp> {
  int _selectedIndex = 1; // Start with Dashboard page

  final List<Widget> _pages = [
    ExpenseScreen(),
    DashboardScreen(),
    IncomeScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Monitoring',
      home: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart),
              label: 'Expense',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.money),
              label: 'Income',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
      ),
    );
  }
}

// Income Screen
class IncomeScreen extends StatefulWidget {
  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> incomeData;

  @override
  void initState() {
    super.initState();
    incomeData = apiService.fetchIncome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Income Data'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: incomeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final incomeList = snapshot.data!;
            // Skip the first element (header)
            final filteredIncomeList = incomeList.skip(1).toList();

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Transaction ID')),
                  DataColumn(label: Text('Product Name')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Revenue')),
                  DataColumn(label: Text('User ID')),
                ],
                rows: filteredIncomeList.map((income) {
                  return DataRow(
                    cells: [
                      DataCell(Text(income[0].toString())),
                      DataCell(Text(income[1].toString())),
                      DataCell(Text(income[2].toString())),
                      DataCell(Text(income[3].toString())),
                      DataCell(Text(income[4].toString())),
                      DataCell(Text(income[5].toString())),
                    ],
                  );
                }).toList(),
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

// Expense Screen
class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> expenseData;

  @override
  void initState() {
    super.initState();
    expenseData = apiService.fetchExpense(); // Fetching expense data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Data'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: expenseData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final expenseList = snapshot.data!;
            // Skip the first element (header)
            final filteredExpenseList = expenseList.skip(1).toList();

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Transaction ID')),
                  DataColumn(label: Text('Product Name')),
                  DataColumn(label: Text('Expense Amount')),
                  DataColumn(label: Text('Revenue')),
                  DataColumn(label: Text('User ID')),
                ],
                rows: filteredExpenseList.map((expense) {
                  return DataRow(
                    cells: [
                      DataCell(Text(expense[0].toString())),
                      DataCell(Text(expense[1].toString())),
                      DataCell(Text(expense[2].toString())),
                      DataCell(Text(expense[3].toString())), // Expense Amount
                      DataCell(Text(expense[4].toString())), // Revenue
                      DataCell(Text(expense[5].toString())),
                    ],
                  );
                }).toList(),
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

// Dashboard Screen (Displays Income Data)
class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> incomeData;

  @override
  void initState() {
    super.initState();
    incomeData = apiService.fetchIncome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: incomeData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final incomeList = snapshot.data!;
            // Skip the first element (header)
            final filteredIncomeList = incomeList.skip(1).toList();

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Transaction ID')),
                  DataColumn(label: Text('Product Name')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Revenue')),
                  DataColumn(label: Text('User ID')),
                ],
                rows: filteredIncomeList.map((income) {
                  return DataRow(
                    cells: [
                      DataCell(Text(income[0].toString())),
                      DataCell(Text(income[1].toString())),
                      DataCell(Text(income[2].toString())),
                      DataCell(Text(income[3].toString())),
                      DataCell(Text(income[4].toString())),
                      DataCell(Text(income[5].toString())),
                    ],
                  );
                }).toList(),
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
