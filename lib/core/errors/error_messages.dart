// lib/core/errors/error_messages.dart
class ErrorMessages {
  // Network Errors
  static const String noInternet = 'No internet connection. Please check your network.';
  static const String timeoutError = 'Connection timeout. Please try again.';
  static const String serverError = 'Server error. Please try again later.';
  
  // Payment Errors
  static const String paymentFailed = 'Payment failed. Please try again.';
  static const String paymentCancelled = 'Payment was cancelled.';
  static const String cardDeclined = 'Your card was declined. Please use a different card.';
  static const String invalidAmount = 'Invalid amount. Minimum is \$0.50.';
  
  // Validation Errors
  static const String emptyFields = 'Please fill all required fields.';
  static const String invalidUser = 'Invalid user. Please login again.';
  
  // Generic
  static const String genericError = 'Something went wrong. Please try again.';
  static const String paymentSuccess = 'Payment successful! 🎉';
}