import 'package:flutter/material.dart';
import 'package:payment_method_stripe/core/view_models/payment_view_model.dart';
import 'package:payment_method_stripe/core/views/payment_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PaymentViewModel()),
      ],
      child: MaterialApp(
        title: 'Payment App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: PaymentScreen(userId: 1), // Pass userId
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}