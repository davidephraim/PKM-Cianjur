import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://script.google.com/macros/s/AKfycbyYtTWO-ia8Uvd7KBtpLbE6KC81Tfp6WtWkK6HtA11f02uIo51xnb9jNa8Si8VHnwprsg/exec';
  
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

  Future<Map<String, dynamic>> addIncome(String productId, String productName, String quantity, String price) async {
    return await _postRequest(
      addIncomeAction,
      {
        'productId': productId,
        'productName': productName,
        'quantity': quantity,
        'price': price,
      },
    );
  }

  // Future<Map<String, dynamic>> addExpense(String action, String dateTime, String transactionId, String productName, String qtyProducts, String expenseAmounts, String userId) async {
  //   return await _postRequest(
  //     addExpenseAction,
  //     {
  //       'action': action,
  //       'dateTime':dateTime,
  //       'transactionsId':transactionId,
  //       'productsName':productName,
  //       'qtyProducts':qtyProducts,
  //       'expenseAmounts':expenseAmounts,
  //       'userId':userId,
  //     },
  //   );
  // }

  Future<void> addExpense({
  required String action,
  required String dateTime,
  required String transactionId,
  required String qtyProducts,
  required int expenseAmounts,
  required String userId,
  required String productsName,
}) async {
  // Convert int to String
  final Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
    'action': action,
    'dateTime': dateTime,
    'transactionsId': transactionId,
    'qtyProducts': qtyProducts,
    'expenseAmounts': expenseAmounts.toString(),  // Convert to String
    'userId': userId,
    'productsName': productsName,
  });

  final response = await http.post(uri);

  if (response.statusCode == 200) {
    print('Expense berhasil ditambahkan');
    print('Response body: ${response.body}');
  } else {
    print('Gagal menambahkan expense. Status code: ${response.statusCode}');
  }
}


  Future<Map<String, dynamic>> updateExpenseAmount(String expenseId, int newAmount) async {
    return await _postRequest(
      updateExpenseAmountAction,
      {
        'expenseId': expenseId,
        'newAmount': newAmount.toString(),
      },
    );
  }

  Future<Map<String, dynamic>> updateIncomeQuantity(String productId, int quantity) async {
    return await _postRequest(
      updateIncomeQuantityAction,
      {
        'productId': productId,
        'quantity': quantity.toString(),
      },
    );
  }

  Future<Map<String, dynamic>> _postRequest(String action, Map<String, String> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl?action=$action'),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    return _handleResponse(response);
  }

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

}
