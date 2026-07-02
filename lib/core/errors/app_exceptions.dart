// lib/core/errors/app_exceptions.dart
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  
  AppException({
    required this.message,
    this.code,
    this.originalError,
  });
  
  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException({
    required super.message,
    String? code,
    super.originalError,
  }) : super(
    code: code ?? 'NETWORK_ERROR',
  );
  
  factory NetworkException.noInternet() {
    return NetworkException(
      message: 'No internet connection. Please check your network.',
      code: 'NO_INTERNET',
    );
  }
  
  factory NetworkException.timeout() {
    return NetworkException(
      message: 'Connection timeout. Please try again.',
      code: 'TIMEOUT',
    );
  }
}

class ApiException extends AppException {
  final int? statusCode;
  
  ApiException({
    required super.message,
    this.statusCode,
    String? code,
    super.originalError,
  }) : super(
    code: code ?? 'API_ERROR',
  );
  
  factory ApiException.fromResponse(int statusCode, dynamic response) {
    switch (statusCode) {
      case 400:
        return ApiException(
          message: 'Invalid request. Please check your input.',
          statusCode: 400,
          code: 'BAD_REQUEST',
        );
      case 401:
        return ApiException(
          message: 'Unauthorized. Please login again.',
          statusCode: 401,
          code: 'UNAUTHORIZED',
        );
      case 404:
        return ApiException(
          message: 'Requested resource not found.',
          statusCode: 404,
          code: 'NOT_FOUND',
        );
      case 500:
        return ApiException(
          message: 'Server error. Please try again later.',
          statusCode: 500,
          code: 'SERVER_ERROR',
        );
      default:
        return ApiException(
          message: 'Something went wrong. Please try again.',
          statusCode: statusCode,
          code: 'UNKNOWN_ERROR',
        );
    }
  }
}

class StripeException extends AppException {
  StripeException({
    required super.message,
    String? code,
    super.originalError,
  }) : super(
    code: code ?? 'STRIPE_ERROR',
  );
  
  factory StripeException.canceled() {
    return StripeException(
      message: 'Payment was cancelled.',
      code: 'PAYMENT_CANCELLED',
    );
  }
  
  factory StripeException.failed(dynamic error) {
    return StripeException(
      message: 'Payment failed. Please try again.',
      code: 'PAYMENT_FAILED',
      originalError: error,
    );
  }
  
  factory StripeException.cardDeclined() {
    return StripeException(
      message: 'Your card was declined. Please use a different card.',
      code: 'CARD_DECLINED',
    );
  }
}

class ValidationException extends AppException {
  ValidationException({
    required super.message,
    String? code,
    super.originalError,
  }) : super(
    code: code ?? 'VALIDATION_ERROR',
  );
  
  factory ValidationException.invalidAmount() {
    return ValidationException(
      message: 'Amount must be at least \$0.50',
      code: 'INVALID_AMOUNT',
    );
  }
}