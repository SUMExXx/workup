import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:workup/models/customer_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final String? apiUrl = dotenv.env['API_BASE_URL'];

  Future<int> register(Customer customer) async {
    final response = await http.post(
      Uri.parse('$apiUrl/customers/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(customer.toJson()),
    );

    return response.statusCode;  // Return true if registration is successful
  }

  Future<int> verifyOTP(String email, String otp) async {

    final response = await http.post(
      Uri.parse('$apiUrl/customers/verify'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"email": email, "otp": otp}),
    );

    return response.statusCode;  // Return true if registration is successful
  }

  Future<Map<String, dynamic>> login(Customer customer) async {

    Map<String, dynamic> returnData = {
      'code': null,
      'message': null,
      'token': null
    };

    final response = await http.post(
      Uri.parse('$apiUrl/customers/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(customer.toJson()),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      returnData['token'] = data['token'];
      returnData['code'] = data['code'];
    } else if(response.statusCode == 300){

    }

    return returnData;  // Return null if login fails
  }

  Future<bool?> verifyLogin(String email, String token) async {
    final response = await http.post(
      Uri.parse('$apiUrl/customers/verifyToken'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if(data['code'] == 'verified') {
        return true;
      } else {
        return false;
      }
    }

    return false;  // Return null if login fails
  }
}