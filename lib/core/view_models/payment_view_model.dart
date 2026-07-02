// lib/view_models/payment_view_model.dart
import 'package:flutter/material.dart';
import 'package:payment_method_stripe/core/constant/app_constants.dart';
import 'package:payment_method_stripe/core/errors/error_handler.dart';
import 'package:payment_method_stripe/core/errors/error_messages.dart';
import 'package:payment_method_stripe/core/service/api_service.dart';
import 'package:payment_method_stripe/core/service/stripe_service.dart';

import '../models/payment_model.dart';


// ✅ Custom Payment Method Enum (Stripe se alag)
enum PaymentMethodType { card, googlePay, applePay }

class PaymentViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StripeService _stripeService = StripeService();
  final ErrorHandler _errorHandler = ErrorHandler();
  
  // =============================================
  // STATE
  // =============================================
  List<PaymentModel> _payments = [];
  bool _isLoading = false;
  bool _isProcessing = false;
  String? _errorMessage;
  String? _successMessage;
  int _selectedAmount = 1000;
  String _selectedCurrency = 'usd';
  PaymentMethodType _selectedMethod = PaymentMethodType.card; // ✅ Custom enum
  
  // =============================================
  // GETTERS
  // =============================================
  List<PaymentModel> get payments => _payments;
  bool get isLoading => _isLoading;
  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  int get selectedAmount => _selectedAmount;
  String get selectedCurrency => _selectedCurrency;
  PaymentMethodType get selectedMethod => _selectedMethod; // ✅ Custom enum
  List<int> get presetAmounts => AppConstants.presetAmounts;
  List<String> get currencies => AppConstants.currencies;
  
  // =============================================
  // ACTIONS
  // =============================================
  void selectAmount(int amount) {
    _selectedAmount = amount;
    notifyListeners();
  }
  
  void selectCurrency(String currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }
  
  void selectPaymentMethod(PaymentMethodType method) { // ✅ Custom enum
    _selectedMethod = method;
    notifyListeners();
  }
  
  // =============================================
  // PROCESS PAYMENT
  // =============================================
  Future<bool> processPayment(int userId) async {
    _setProcessing(true);
    _clearMessages();
    
    try {
      // Step 1: Create Payment Intent
      final result = await _apiService.createPaymentIntent(
        amount: _selectedAmount,
        currency: _selectedCurrency,
        userId: userId,
      );
      
      String clientSecret = '';
      bool apiSuccess = false;
      
      result.handle(
        onSuccess: (data) {
          clientSecret = data;
          apiSuccess = true;
        },
        onFailure: (error) {
          _setError(_errorHandler.handleError(error));
          apiSuccess = false;
        },
      );
      
      if (!apiSuccess) {
        _setProcessing(false);
        return false;
      }
      
      // Step 2: Initialize Payment Sheet
      try {
        await _stripeService.initPaymentSheet(clientSecret);
      } catch (e) {
        _setError(_errorHandler.handleError(e));
        _setProcessing(false);
        return false;
      }
      
      // Step 3: Present Payment Sheet
      try {
        await _stripeService.presentPaymentSheet();
      } catch (e) {
        _setError(_errorHandler.handleError(e));
        _setProcessing(false);
        return false;
      }
      
      // Step 4: Success
      _setSuccess(ErrorMessages.paymentSuccess);
      await getPaymentHistory(userId);
      _setProcessing(false);
      return true;
      
    } catch (e) {
      _setError(_errorHandler.handleError(e));
      _setProcessing(false);
      return false;
    }
  }
  
  // =============================================
  // GET PAYMENT HISTORY
  // =============================================
  Future<void> getPaymentHistory(int userId) async {
    _setLoading(true);
    _clearMessages();
    
    try {
      final result = await _apiService.getPaymentHistory(userId);
      
      result.handle(
        onSuccess: (payments) {
          _payments = payments;
        },
        onFailure: (error) {
          _setError(_errorHandler.handleError(error));
        },
      );
    } catch (e) {
      _setError(_errorHandler.handleError(e));
    } finally {
      _setLoading(false);
    }
  }
  
  // =============================================
  // HELPERS
  // =============================================
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setProcessing(bool processing) {
    _isProcessing = processing;
    notifyListeners();
  }
  
  void _setError(String error) {
    _errorMessage = error;
    _successMessage = null;
    notifyListeners();
  }
  
  void _setSuccess(String message) {
    _successMessage = message;
    _errorMessage = null;
    notifyListeners();
  }
  
  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
  
  String getFormattedAmount(int amount, String currency) {
    final double amountInMainCurrency = amount / 100;
    final symbol = _getCurrencySymbol(currency);
    return '$symbol${amountInMainCurrency.toStringAsFixed(2)}';
  }
  
  String _getCurrencySymbol(String currency) {
    switch (currency.toLowerCase()) {
      case 'usd': return '\$';
      case 'eur': return '€';
      case 'gbp': return '£';
      case 'pkr': return 'Rs.';
      case 'inr': return '₹';
      default: return '\$';
    }
  }
}