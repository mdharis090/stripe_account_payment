// lib/core/errors/error_handler.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'app_exceptions.dart';
import 'error_messages.dart';

class ErrorHandler {
  static ErrorHandler? _instance;
  
  factory ErrorHandler() => _instance ??= ErrorHandler._internal();
  
  ErrorHandler._internal();
  
  String handleError(dynamic error) {
    print(' Error: $error');
    
    if (error is NetworkException) {
      return error.message;
    } else if (error is ApiException) {
      return error.message;
    } else if (error is StripeException) {
      return error.message;
    } else if (error is ValidationException) {
      return error.message;
    } else if (error is SocketException) {
      return ErrorMessages.noInternet;
    } else if (error is TimeoutException) {
      return ErrorMessages.timeoutError;
    } else if (error is String) {
      return error;
    } else {
      return ErrorMessages.genericError;
    }
  }
  
  void showErrorDialog({
    required BuildContext context,
    required dynamic error,
    VoidCallback? onRetry,
  }) {
    final message = handleError(error);
    
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            const Text('Error'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onRetry();
              },
              child: const Text('Retry', style: TextStyle(color: Colors.blue)),
            ),
        ],
      ),
    );
  }
  
  void showSuccessDialog({
    required BuildContext context,
    required String message,
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            const Text('Success'),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (onConfirm != null) onConfirm();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}