import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://script.google.com/macros/s/AKfycbz64gSc8TUky6CRiv6KRo629JQm-JFRwkxLqISxSrzo7S4aVS3n5ONPBRBbT9930cfFRQ/exec';
  
  static const String getIncomeAction = 'getIncome';
  static const String getExpenseAction = 'getExpense';
  static const String getUsersAction = 'getUsers';
  static const String getProductsAction = 'getProducts';
  static const String getServicesAction = 'getServices';
  static const String getDashboardAction = 'getDashboard';
  static const String registerUserAction = 'registerUser';
  static const String addIncomeAction = 'addIncome';
  static const String addExpenseAction = 'addExpense';
  static const String updateExpenseAmountAction = 'updateExpenseAmount';
  static const String updateIncomeQuantityAction = 'updateIncomeQuantity';
  static const String getExpenseTypesAction = 'getExpenseTypes';
  static const String getIncomeTypesAction = 'getIncomeTypes';

  Future<List<dynamic>> fetchIncome() async {
    final response = await http.get(Uri.parse('$baseUrl?action=$getIncomeAction'));
    return _handleResponse(response);
  }

  Future<List<dynamic>> fetchExpense() async {
    final response = await http.get(Uri.parse('$baseUrl?action=$getExpenseAction'));
    return _handleResponse(response);
  }

  Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl?action=$getUsersAction'));
    return _handleResponse(response);
  }

  Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl?action=$getProductsAction'));
    return _handleResponse(response);
  }

  Future<List<dynamic>> fetchServices() async {
    final response = await http.get(Uri.parse('$baseUrl?action=$getServicesAction'));
    return _handleResponse(response);
  }

  Future<List<dynamic>> fetchDashboard() async {
    final response = await http.get(Uri.parse('$baseUrl?action=$getDashboardAction'));
    return _handleResponse(response);
  }
  
  Future<List<dynamic>> fetchExpenseTypes() async {
    final response = await http.get(Uri.parse('$baseUrl?action=$getExpenseTypesAction'));
    return _handleResponse(response);
  }
  
  Future<List<dynamic>> fetchIncomeTypes() async {
    final response = await http.get(Uri.parse('$baseUrl?action=$getIncomeTypesAction'));
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> loginUser(String userName, String userPassword) async {
    final response = await http.get(Uri.parse('$baseUrl?action=$getUsersAction'));
    List<dynamic> users = _handleResponse(response);

    for (var user in users) {
      if (user[1] == userName && user[2] == userPassword) {
        return {'success': true, 'message': 'Login successful', 'userId': user[0]};
      }
    }
    return {'success': false, 'message': 'Invalid username or password'};
  }

  Future<Map<String, dynamic>> registerUser(String userId, String userName, String userPassword, String userProduct, String userService, String userContact) async {
      final uri = Uri.parse(baseUrl).replace(queryParameters: {'action': registerUserAction});
      final response = await http.post(
        uri,
        body: jsonEncode({
          'userId': userId,
          'userName': userName,
          'userPassword': userPassword,
          'userProduct': userProduct,
          'userService': userService,
          'userContact': userContact,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      return _handleResponse(response);
  }

// ADD INCOME [START]
    Future<void> addIncome({
    required String action,
    required String dateTime,
    required String transactionId,
    required String productsName,
    required String qtyProducts,
    required int revenue,
    required String userId,
  }) async {
    final String dateTime = DateTime.now().toIso8601String();

    // Convert int to String
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': action,
      'dateTime': dateTime,
      'transactionsId': transactionId,
      'productsName': productsName,
      'qtyProducts': qtyProducts,
      'revenue': revenue.toString(),
      'userId': userId,
    });

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      print('Income added sucessfully');
      print('Response body: ${response.body}');
    } else {
      print('Failed add income. Status code: ${response.statusCode}');
    }
  }
// ADD INCOME [END]

// ADD EXPENSE [START]
    Future<void> addExpense({
    required String action,
    required String dateTime,
    required String transactionId,
    required String expenseName,
    required String qtyProducts,
    required int expenseAmounts,
    required String userId,
  }) async {
    final String dateTime = DateTime.now().toIso8601String();

    // Convert int to String
    final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
      'action': action,
      'dateTime': dateTime,
      'transactionsId': transactionId,
      'expenseName': expenseName,
      'qtyProducts': qtyProducts,
      'expenseAmounts': expenseAmounts.toString(),
      'userId': userId,
    });

    final response = await http.post(uri);

    if (response.statusCode == 200) {
      print('Expense added successfully');
      print('Response body: ${response.body}');
    } else {
      print('Failed add expense. Status code: ${response.statusCode}');
    }
  }
// ADD EXPENSE [END]

// UPDATE EXPENSE AMOUNT [START]
  Future<Map<String, dynamic>> updateExpenseAmount(String expenseId, int newAmount) async {
    return await _postRequest(
      updateExpenseAmountAction,
      {
        'expenseId': expenseId,
        'newAmount': newAmount.toString(),
      },
    );
  }
// UPDATE EXPENSE AMOUNT [END]

// UPDATE INCOME QUANTITY [START]
  Future<Map<String, dynamic>> updateIncomeQuantity(String productId, int quantity) async {
    return await _postRequest(
      updateIncomeQuantityAction,
      {
        'productId': productId,
        'quantity': quantity.toString(),
      },
    );
  }
// UPDATE INCOME QUANTITY [END]

// POST REQUEST [START]
  Future<Map<String, dynamic>> _postRequest(String action, Map<String, String> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl?action=$action'),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }
// POST REQUEST [END]

// HANDLE RESPONSE [START]
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      try {
        final decodedData = jsonDecode(response.body);
        if (decodedData is Map || decodedData is List) {
          return decodedData;
        } else {
          throw Exception('Unexpected response format');
        }
      } catch (e) {
        print('Error decoding response: $e');
        throw Exception('Error decoding response: $e');
      }
    } else {
      print('Error ${response.statusCode}: ${response.reasonPhrase}');
      throw Exception('Failed to load data: ${response.statusCode} - ${response.reasonPhrase}');
    }
  }
// HANDLE RESPONSE [END]
}
