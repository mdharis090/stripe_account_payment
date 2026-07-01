import 'package:flutter/material.dart';
import 'package:payment_method_stripe/core/widgets/amount_selector.dart';
import 'package:payment_method_stripe/core/widgets/payment_button.dart';
import 'package:provider/provider.dart';
import '../view_models/payment_view_model.dart';

class PaymentScreen extends StatelessWidget {
  final int userId;
  
  const PaymentScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Payment'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Consumer<PaymentViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount Section
                  Text(
                    'Select Amount',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Amount Selector Widget
                  AmountSelector(
                    selectedAmount: viewModel.selectedAmount,
                    presetAmounts: viewModel.presetAmounts,
                    onAmountSelected: viewModel.selectAmount,
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Payment Method
                  Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  
                  Row(
                    children: PaymentMethod.values.map((method) {
                      return Expanded(
                        child: PaymentMethodTile(
                          method: method,
                          isSelected: viewModel.selectedMethod == method,
                          onTap: () => viewModel.selectPaymentMethod(method),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Payment Button
                  PaymentButton(
                    isLoading: viewModel.isLoading,
                    amount: viewModel.selectedAmount,
                    onPressed: () async {
                      final success = await viewModel.processPayment(userId);
                      
                      if (success) {
                        _showPaymentSuccess(context);
                      } else {
                        _showPaymentError(context, viewModel.errorMessage);
                      }
                    },
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Error Message
                  if (viewModel.errorMessage != null)
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Text(
                        viewModel.errorMessage!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  void _showPaymentSuccess(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Icon(Icons.check_circle, color: Colors.green, size: 60),
        content: Text('Payment Successful! 🎉'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
  
  void _showPaymentError(BuildContext context, String? error) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Icon(Icons.error, color: Colors.red, size: 60),
        content: Text('Payment Failed: ${error ?? "Unknown error"}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

class PaymentMethodTile extends StatelessWidget {
  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;
  
  const PaymentMethodTile({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            method.toString().split('.').last.toUpperCase(),
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}