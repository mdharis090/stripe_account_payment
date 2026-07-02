// lib/services/stripe_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide StripeException;
import 'package:payment_method_stripe/core/constant/app_constants.dart';
// stripe_service.dart
import 'package:payment_method_stripe/core/errors/app_exceptions.dart'; 



class StripeService {
  StripeService() {
    _initializeStripe();
  }
  
  void _initializeStripe() {
    try {
      Stripe.publishableKey = AppConstants.stripePublishableKey;
      print(' Stripe initialized');
    } catch (e) {
      throw StripeException(
        message: 'Failed to initialize Stripe',
        originalError: e,
      );
    }
  }
  
  Future<void> initPaymentSheet(String clientSecret) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'test for development',
          style: ThemeMode.light,
        //  primaryButtonColor: Colors.blue,
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'US',
          ),
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: true,
          ),
        ),
      );
      print('✅ Payment sheet initialized');
    } catch (e) {
      print('❌ Payment sheet init error: $e');
      throw StripeException.failed(e);
    }
  }
  
  Future<void> presentPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      print('✅ Payment sheet presented');
    } catch (e) {
      print('❌ Payment sheet error: $e');
      
      if (e.toString().contains('canceled')) {
        throw StripeException.canceled();
      } else if (e.toString().contains('card_declined')) {
        throw StripeException.cardDeclined();
      } else {
        throw StripeException.failed(e);
      }
    }
  }
}