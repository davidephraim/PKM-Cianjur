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

// Expense Screen
class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> expenseData = [];
  List<int> quantities = [];

  @override
  void initState() {
    super.initState();
    // Dummy data for testing
    expenseData = [
      {
        'date': '2024-10-09',
        'transaction_id': 'EXP123',
        'product_name': 'Product A',
        'expense_amount': 10,
        'revenue': 500,
        'user_id': 'User1'
      },
      {
        'date': '2024-10-09',
        'transaction_id': 'EXP124',
        'product_name': 'Product B',
        'expense_amount': 5,
        'revenue': 300,
        'user_id': 'User2'
      },
    ];

    quantities = List<int>.generate(expenseData.length, (index) => expenseData[index]['expense_amount']);
  }

  void _incrementQuantity(int index) {
    setState(() {
      quantities[index]++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (quantities[index] > 0) {
        quantities[index]--;
      }
    });
  }

  Future<void> _saveData(int index) async {
    final productId = expenseData[index]['transaction_id'];
    final newQuantity = quantities[index];

    await apiService.updateExpenseAmount(productId, newQuantity);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved ${expenseData[index]['product_name']} with quantity $newQuantity')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Data'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Transaction ID')),
                  DataColumn(label: Text('Product Name')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Revenue')),
                  DataColumn(label: Text('User ID')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: List<DataRow>.generate(
                  expenseData.length,
                  (index) {
                    return DataRow(
                      cells: [
                        DataCell(Text(expenseData[index]['date'])),
                        DataCell(Text(expenseData[index]['transaction_id'])),
                        DataCell(Text(expenseData[index]['product_name'])),
                        DataCell(Text(quantities[index].toString())),
                        DataCell(Text(expenseData[index]['revenue'].toString())),
                        DataCell(Text(expenseData[index]['user_id'])),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () => _decrementQuantity(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () => _incrementQuantity(index),
                              ),
                              TextButton(
                                onPressed: () => _saveData(index),
                                child: Text('Save'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
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
  List<Map<String, dynamic>> incomeData = [];
  List<int> quantities = [];

  @override
  void initState() {
    super.initState();
    // Dummy data for testing
    incomeData = [
      {
        'date': '2024-10-09',
        'transaction_id': 'TX123',
        'product_name': 'Product A',
        'quantity': 10,
        'revenue': 500,
        'user_id': 'User1'
      },
      {
        'date': '2024-10-09',
        'transaction_id': 'TX124',
        'product_name': 'Product B',
        'quantity': 5,
        'revenue': 300,
        'user_id': 'User2'
      },
    ];

    quantities = List<int>.generate(incomeData.length, (index) => incomeData[index]['quantity']);
  }

  void _incrementQuantity(int index) {
    setState(() {
      quantities[index]++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (quantities[index] > 0) {
        quantities[index]--;
      }
    });
  }

  Future<void> _saveData(int index) async {
    final productId = incomeData[index]['transaction_id'];
    final newQuantity = quantities[index];

    await apiService.updateIncomeQuantity(productId, newQuantity);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved ${incomeData[index]['product_name']} with quantity $newQuantity')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Income Data'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Transaction ID')),
                  DataColumn(label: Text('Product Name')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Revenue')),
                  DataColumn(label: Text('User ID')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: List<DataRow>.generate(
                  incomeData.length,
                  (index) {
                    return DataRow(
                      cells: [
                        DataCell(Text(incomeData[index]['date'])),
                        DataCell(Text(incomeData[index]['transaction_id'])),
                        DataCell(Text(incomeData[index]['product_name'])),
                        DataCell(Text(quantities[index].toString())),
                        DataCell(Text(incomeData[index]['revenue'].toString())),
                        DataCell(Text(incomeData[index]['user_id'])),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () => _decrementQuantity(index),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () => _incrementQuantity(index),
                              ),
                              TextButton(
                                onPressed: () => _saveData(index),
                                child: Text('Save'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
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
