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
  int _selectedIndex = 1;

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

// EXPENSE SCREEN [START]
class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> expenseHistory = [];
  List<String> expenseTypes = [];
  String selectedExpenseType = '';
  int quantity = 1;
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchExpenseTypes();
  }

  Future<void> _fetchExpenseTypes() async {
    final expenseTypesData = await apiService.fetchExpenseTypes();
    setState(() {
      // Remove the first item (header)
      expenseTypes = List<String>.from(expenseTypesData)..removeAt(0);
      selectedExpenseType = expenseTypes.isNotEmpty ? expenseTypes.first : '';
    });
  }

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (quantity > 0) {
        quantity--;
      }
    });
  }

  Future<void> _saveExpense() async {
    final expenseAmount = int.tryParse(priceController.text) ?? 0;

    // Ensure price is not empty and quantity is not 0
    if (expenseAmount == 0 || quantity == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid price and quantity')),
      );
      return;
    }

    // Post the expense data
    await apiService.addExpense(
      action: "addExpense",
      dateTime: DateTime.now().toIso8601String(),
      transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
      expenseName: selectedExpenseType,
      qtyProducts: quantity.toString(),
      expenseAmounts: expenseAmount,
      userId: "1",
    );

    // Add the expense to history
    setState(() {
      expenseHistory.insert(0, {
        'expenseName': selectedExpenseType,
        'expenseAmounts': expenseAmount,
        'quantity': quantity,
      });

      // Limit the history to the latest 5 records
      if (expenseHistory.length > 5) {
        expenseHistory = expenseHistory.sublist(0, 5);
      }

      // Clear input fields after saving
      priceController.clear();
      quantity = 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Expense saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Expense Name Dropdown
            Text('Expense Name', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedExpenseType,
              onChanged: (newValue) {
                setState(() {
                  selectedExpenseType = newValue!;
                });
              },
              items: expenseTypes.map((expenseType) {
                return DropdownMenuItem<String>(
                  value: expenseType,
                  child: Text(expenseType),
                );
              }).toList(),
            ),
            SizedBox(height: 16),

            // Price Input
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price', style: TextStyle(fontSize: 16)),
                      TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter price in Rp',
                          prefixText: 'Rp ',
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 16),

                // Quantity and Save Button
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Quantity', style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: _decrementQuantity,
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                quantity.toString(),
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: _incrementQuantity,
                          ),
                          SizedBox(width: 16),

                          ElevatedButton(
                            onPressed: _saveExpense,
                            child: Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // History Section
            Text('History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: expenseHistory.length,
                itemBuilder: (context, index) {
                  final expense = expenseHistory[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(expense['expenseName']),
                      subtitle: Text(
                          'Price: Rp ${expense['expenseAmounts']}, Quantity: ${expense['quantity']}'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// EXPENSE SCREEN [END]

// INCOME SCREEN [START]
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
        'action': "addIncome",
        'dateTime':"2024-10-09",
        'transactionsId':"1",
        'productsName':"1",
        'qtyProducts':1,
        'revenue':11,
        'userId':"1",
      },
    ];

    quantities = List<int>.generate(incomeData.length, (index) => incomeData[index]['qtyProducts']);
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
    final ApiService apiService = ApiService();
    final income = incomeData[index];
    final newQuantity = quantities[index];

    // post data using API - Apps Script
    await apiService.addIncome(
      action: income['action'],
      dateTime: income['dateTime'],
      transactionId: income['transactionsId'],
      productsName: income['productsName'],
      qtyProducts: newQuantity.toString(),
      revenue: income['revenue'],
      userId: income['userId'],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved ${income['productsName']} with quantity $newQuantity')),
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
                        DataCell(Text(incomeData[index]['dateTime'].toString())),
                        DataCell(Text(incomeData[index]['transactionsId'].toString())),
                        DataCell(Text(incomeData[index]['productsName'].toString())),
                        DataCell(Text(quantities[index].toString())),
                        DataCell(Text(incomeData[index]['revenue'].toString())),
                        DataCell(Text(incomeData[index]['userId'].toString())),
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
// INCOME SCREEN [END]

// DASHBOARD SCREEN [START]
class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> incomeData;
  late Future<List<dynamic>> expenseData;

  @override
  void initState() {
    super.initState();
    incomeData = apiService.fetchIncome();
    expenseData = apiService.fetchExpense();
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
// DASHBOARD SCREEN [END]