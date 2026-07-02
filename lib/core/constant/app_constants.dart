// lib/core/constants/app_constants.dart
import 'package:flutter/material.dart';
class AppConstants {
  // API URL - Change this according to your environment
  static const String baseUrl = 'http://172.17.2.49:4000';
  // For Android Emulator: http://10.0.2.2:4000
  // For Real Device: http://192.168.1.100:4000 (your PC IP)
  
  // Stripe Keys
  static const String stripePublishableKey = 'pk_test_51Tny3OHZcEjFc9CNG8eSoXhgqLz6DIutYMPAKsnWnbRhDxi2uC4oij9LniPjcUKTdpMjkiKBL6aRzRc1GDndyTpF00XSJBa6k1';
  
  // Payment Constants
  static const int minAmount = 50; // $0.50
  static const List<int> presetAmounts = [500, 1000, 2000, 5000, 10000];
  static const List<String> currencies = ['usd', 'eur', 'gbp', 'pkr', 'inr'];
}