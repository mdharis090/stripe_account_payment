import 'package:flutter/material.dart';
import 'package:payment_method_stripe/core/service/api_service.dart';
import 'package:payment_method_stripe/core/service/stripe_service.dart';
import '../models/payment_model.dart';


class PaymentViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StripeService _stripeService = StripeService();
  
  // State Variables
  PaymentModel? _currentPayment;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Getters
  PaymentModel? get currentPayment => _currentPayment;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Payment Method
  PaymentMethod _selectedMethod = PaymentMethod.card;
  PaymentMethod get selectedMethod => _selectedMethod;
  
  // Amount Selection
  int _selectedAmount = 1000; // $10.00
  int get selectedAmount => _selectedAmount;
  
  List<int> presetAmounts = [500, 1000, 2000, 5000, 10000];
  
  void selectAmount(int amount) {
    _selectedAmount = amount;
    notifyListeners();
  }
  
  void selectPaymentMethod(PaymentMethod method) {
    _selectedMethod = method;
    notifyListeners();
  }
  
  // Main Payment Function
  Future<bool> processPayment(int userId) async {
    _setLoading(true);
    _clearError();
    
    try {
      // Step 1: Create Payment Intent via API
      final clientSecret = await _apiService.createPaymentIntent(
        amount: _selectedAmount,
        currency: 'usd',
        userId: userId,
      );
      
      // Step 2: Initialize Stripe Payment Sheet
      await _stripeService.initPaymentSheet(clientSecret);
      
      // Step 3: Present Payment Sheet
      await _stripeService.presentPaymentSheet();
      
      // Step 4: Payment Success
      _setLoading(false);
      return true;
      
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }
  
  // Get Payment History
  Future<List<PaymentModel>> getPaymentHistory(int userId) async {
    try {
      return await _apiService.getPaymentHistory(userId);
    } catch (e) {
      _setError(e.toString());
      return [];
    }
  }
  
  // Private Helpers
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }
  
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

enum PaymentMethod { card, googlePay, applePay }