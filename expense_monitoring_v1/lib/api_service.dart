// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ApiService {
//   static const String baseUrl = 'https://script.google.com/macros/s/AKfycbw2gpq7vys0ylcTobXVag9MUFwXqqVBozp_tMje2aQtxUQL9VVQhzpYbGwKzhj51BWcTA/exec';

//   Future<List<dynamic>> fetchIncome() async {
//     return _fetchData('getIncome');
//   }

//   Future<List<dynamic>> fetchExpense() async {
//     return _fetchData('getExpense');
//   }

//   Future<List<dynamic>> fetchUsers() async {
//     return _fetchData('getUsers');
//   }

//   Future<List<dynamic>> fetchProducts() async {
//     return _fetchData('getProducts');
//   }

//   Future<List<dynamic>> fetchServices() async {
//     return _fetchData('getServices');
//   }

//   Future<List<dynamic>> _fetchData(String action) async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl?action=$action')).timeout(Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         var decodedResponse = jsonDecode(response.body);
//         if (decodedResponse is List) {
//           return decodedResponse;
//         } else {
//           throw Exception('Expected a list response');
//         }
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       throw Exception('Error: $e');
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://script.google.com/macros/s/AKfycbw2gpq7vys0ylcTobXVag9MUFwXqqVBozp_tMje2aQtxUQL9VVQhzpYbGwKzhj51BWcTA/exec';

  Future<List<dynamic>> fetchIncome() async {
    final response = await http.get(Uri.parse('$baseUrl?action=getIncome'));
    return _handleResponse(response);
  }

  Future<List<dynamic>> fetchExpense() async {
    final response = await http.get(Uri.parse('$baseUrl?action=getExpense'));
    return _handleResponse(response);
  }

  Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl?action=getUsers'));
    return _handleResponse(response);
  }

  Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl?action=getProducts'));
    return _handleResponse(response);
  }

  Future<List<dynamic>> fetchServices() async {
    final response = await http.get(Uri.parse('$baseUrl?action=getServices'));
    return _handleResponse(response);
  }

  Future<List<dynamic>> fetchDashboard() async {
    final response = await http.get(Uri.parse('$baseUrl?action=getDashboard'));
    return _handleResponse(response);
  }

  List<dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
