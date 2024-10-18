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
  late Future<List<dynamic>> expenseData;

  @override
  void initState() {
    super.initState();
    _fetchExpenseTypes();
    expenseData = apiService.fetchExpense();
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
  List<Map<String, dynamic>> incomeHistory = [];
  List<String> incomeTypes = [];
  String selectedIncomeType = '';
  int quantity = 1;
  TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchIncomeTypes();
  }

  Future<void> _fetchIncomeTypes() async {
    final incomeTypesData = await apiService.fetchIncomeTypes();
    setState(() {
      // Remove the first item (header)
      incomeTypes = List<String>.from(incomeTypesData)..removeAt(0);
      selectedIncomeType = incomeTypes.isNotEmpty ? incomeTypes.first : '';
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

  Future<void> _saveIncome() async {
    final revenue = int.tryParse(priceController.text) ?? 0;

    if (revenue == 0 || quantity == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid price and quantity')),
      );
      return;
    }

     // Post the income data
    await apiService.addIncome(
      action: "addIncome",
      dateTime: DateTime.now().toIso8601String(),
      transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
      productsName: selectedIncomeType,
      qtyProducts: quantity.toString(),
      revenue: revenue,
      userId: "1",
    );

    // Add the income to history
    setState(() {
      incomeHistory.insert(0, {
        'productsName': selectedIncomeType,
        'revenue': revenue,
        'quantity': quantity,
      });

      // Limit the history to the latest 5 records
      if (incomeHistory.length > 5) {
        incomeHistory = incomeHistory.sublist(0, 5);
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
        title: Text('Income Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Income Name Dropdown
            Text('Income Name', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedIncomeType,
              onChanged: (newValue) {
                setState(() {
                  selectedIncomeType = newValue!;
                });
              },
              items: incomeTypes.map((incomeType) {
                return DropdownMenuItem<String>(
                  value: incomeType,
                  child: Text(incomeType),
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
                            onPressed: _saveIncome,
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
                itemCount: incomeHistory.length,
                itemBuilder: (context, index) {
                  final income = incomeHistory[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(income['productsName']),
                      subtitle: Text(
                          'Price: Rp ${income['revenue']}, Quantity: ${income['quantity']}'),
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