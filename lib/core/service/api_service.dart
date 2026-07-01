import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/payment_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:4000'; // Change for real device
  
  Future<String> createPaymentIntent({
    required int amount,
    required String currency,
    required int userId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/create-payment-intent'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': amount,
        'currency': currency,
        'userId': userId,
      }),
    );
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['clientSecret'];
    } else {
      throw Exception('Failed to create payment intent: ${response.body}');
    }
  }
  
  Future<List<PaymentModel>> getPaymentHistory(int userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/payments/$userId'),
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PaymentModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get payment history');
    }
  }
}