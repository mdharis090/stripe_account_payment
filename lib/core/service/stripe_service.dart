import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  static const String publishableKey = 'pk_test_xxxxxxxx'; // Your Publishable Key
  
  StripeService() {
    Stripe.publishableKey = publishableKey;
  }
  
  Future<void> initPaymentSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'Your Store Name',
        style: ThemeMode.light,
       // primaryButtonColor: Colors.blue,
      ),
    );
  }
  
  Future<void> presentPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }
}