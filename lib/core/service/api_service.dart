// lib/services/api_service.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:payment_method_stripe/core/constant/app_constants.dart';
import 'package:payment_method_stripe/core/errors/app_exceptions.dart';
import 'package:payment_method_stripe/core/network/api_result.dart';
import 'package:payment_method_stripe/core/utils/logger.dart';

import '../models/payment_model.dart';

class ApiService {
  final String baseUrl = AppConstants.baseUrl;
  
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // =============================================
  // CREATE PAYMENT INTENT
  // =============================================
  Future<ApiResult<String>> createPaymentIntent({
    required int amount,
    required String currency,
    required int userId,
  }) async {
    try {
      Logger.api('Creating payment intent: amount=$amount, currency=$currency');
      
      final response = await http.post(
        Uri.parse('$baseUrl/create-payment-intent'),
        headers: _headers,
        body: jsonEncode({
          'amount': amount,
          'currency': currency,
          'userId': userId,
        }),
      ).timeout(const Duration(seconds: 30));
      
      Logger.api('Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('clientSecret')) {
          Logger.success('Payment intent created');
          return ApiResult.success(data['clientSecret']);
        } else {
          return ApiResult.failure(
            ApiException(
              message: 'Client secret not found',
              statusCode: response.statusCode,
            ),
          );
        }
      } else {
        final errorData = jsonDecode(response.body);
        return ApiResult.failure(
          ApiException.fromResponse(
            response.statusCode,
            errorData['error'] ?? 'Unknown error',
          ),
        );
      }
    } on SocketException {
      return ApiResult.failure(NetworkException.noInternet());
    } on TimeoutException {
      return ApiResult.failure(NetworkException.timeout());
    } catch (e) {
      return ApiResult.failure(
        ApiException(
          message: 'Payment failed: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }
  
  // =============================================
  // GET PAYMENT HISTORY
  // =============================================
  Future<ApiResult<List<PaymentModel>>> getPaymentHistory(int userId) async {
    try {
      Logger.api('Getting payment history for user: $userId');
      
      final response = await http.get(
        Uri.parse('$baseUrl/payments/$userId'),
        headers: _headers,
      ).timeout(const Duration(seconds: 15));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final payments = data.map((json) => PaymentModel.fromJson(json)).toList();
        Logger.success('Loaded ${payments.length} payments');
        return ApiResult.success(payments);
      } else {
        return ApiResult.failure(
          ApiException.fromResponse(response.statusCode, 'Failed to get history'),
        );
      }
    } on SocketException {
      return ApiResult.failure(NetworkException.noInternet());
    } on TimeoutException {
      return ApiResult.failure(NetworkException.timeout());
    } catch (e) {
      return ApiResult.failure(
        ApiException(
          message: 'Failed to load history: ${e.toString()}',
          originalError: e,
        ),
      );
    }
  }
}