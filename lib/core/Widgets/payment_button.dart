import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class PaymentButton extends StatelessWidget {
  final bool isLoading;
  final int amount;
  final VoidCallback onPressed;
  
  const PaymentButton({
    super.key,
    required this.isLoading,
    required this.amount,
    required this.onPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    final amountInDollars = amount / 100;
    
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        child: isLoading
            ? LoadingAnimationWidget.threeArchedCircle(
                color: Colors.white,
                size: 30,
              )
            : Text(
                'Pay \$${amountInDollars.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}