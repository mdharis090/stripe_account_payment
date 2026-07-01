import 'package:flutter/material.dart';

class AmountSelector extends StatelessWidget {
  final int selectedAmount;
  final List<int> presetAmounts;
  final Function(int) onAmountSelected;
  
  const AmountSelector({
    super.key,
    required this.selectedAmount,
    required this.presetAmounts,
    required this.onAmountSelected,
  });
  
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: presetAmounts.map((amount) {
        final isSelected = amount == selectedAmount;
        final amountInDollars = amount / 100;
        
        return GestureDetector(
          onTap: () => onAmountSelected(amount),
          child: Container(
            width: (MediaQuery.of(context).size.width - 60) / 3,
            padding: EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.blue.shade700 : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$${amountInDollars.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    'USD',
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white70 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}