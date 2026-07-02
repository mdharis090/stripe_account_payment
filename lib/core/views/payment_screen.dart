// lib/views/payment_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/payment_view_model.dart';


class PaymentScreen extends StatefulWidget {
  final int userId;
  
  const PaymentScreen({super.key, required this.userId});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentViewModel>().getPaymentHistory(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PaymentViewModel>().getPaymentHistory(widget.userId);
            },
          ),
        ],
      ),
      body: Consumer<PaymentViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount Section
                _buildAmountSection(viewModel),
                const SizedBox(height: 20),
                
                // Currency Section
                _buildCurrencySection(viewModel),
                const SizedBox(height: 20),
                
                // Payment Method Section ✅ Fixed
                _buildPaymentMethodSection(viewModel),
                const SizedBox(height: 20),
                
                // Pay Button
                _buildPayButton(viewModel),
                const SizedBox(height: 16),
                
                // Messages
                _buildMessages(viewModel),
                const SizedBox(height: 20),
                
                // Payment History
                _buildPaymentHistory(viewModel),
              ],
            ),
          );
        },
      ),
    );
  }

  // =============================================
  // AMOUNT SECTION
  // =============================================
  Widget _buildAmountSection(PaymentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Amount',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: viewModel.presetAmounts.map((amount) {
            final isSelected = amount == viewModel.selectedAmount;
            final formatted = viewModel.getFormattedAmount(amount, viewModel.selectedCurrency);
            
            return GestureDetector(
              onTap: () => viewModel.selectAmount(amount),
              child: Container(
                width: (MediaQuery.of(context).size.width - 60) / 3,
                padding: const EdgeInsets.symmetric(vertical: 15),
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
                        formatted,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        viewModel.selectedCurrency.toUpperCase(),
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
        ),
      ],
    );
  }

  // =============================================
  // CURRENCY SECTION
  // =============================================
  Widget _buildCurrencySection(PaymentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Currency',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: viewModel.currencies.map((currency) {
            final isSelected = currency == viewModel.selectedCurrency;
            
            return ChoiceChip(
              label: Text(currency.toUpperCase()),
              selected: isSelected,
              onSelected: (_) => viewModel.selectCurrency(currency),
              selectedColor: Colors.blue,
              backgroundColor: Colors.grey.shade200,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // =============================================
  // PAYMENT METHOD SECTION ✅ FIXED
  // =============================================
  Widget _buildPaymentMethodSection(PaymentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: PaymentMethodType.values.map((method) {
            final isSelected = method == viewModel.selectedMethod;
            final icon = _getPaymentMethodIcon(method);
            final label = _getPaymentMethodLabel(method);
            
            return Expanded(
              child: GestureDetector(
                onTap: () => viewModel.selectPaymentMethod(method),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        color: isSelected ? Colors.blue : Colors.grey.shade700,
                        size: 30,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.blue : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  IconData _getPaymentMethodIcon(PaymentMethodType method) {
    switch (method) {
      case PaymentMethodType.card:
        return Icons.credit_card;
      case PaymentMethodType.googlePay:
        return Icons.payment;
      case PaymentMethodType.applePay:
        return Icons.apple;
    }
  }

  String _getPaymentMethodLabel(PaymentMethodType method) {
    switch (method) {
      case PaymentMethodType.card:
        return 'CARD';
      case PaymentMethodType.googlePay:
        return 'GOOGLE PAY';
      case PaymentMethodType.applePay:
        return 'APPLE PAY';
    }
  }

  // =============================================
  // PAY BUTTON
  // =============================================
  Widget _buildPayButton(PaymentViewModel viewModel) {
    final formattedAmount = viewModel.getFormattedAmount(
      viewModel.selectedAmount,
      viewModel.selectedCurrency,
    );
    
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: viewModel.isProcessing ? null : () async {
          final success = await viewModel.processPayment(widget.userId);
          
          if (success) {
            _showDialog(
              context,
              'Success',
              'Payment successful! 🎉',
              Colors.green,
            );
          } else {
            _showDialog(
              context,
              'Error',
              viewModel.errorMessage ?? 'Payment failed',
              Colors.red,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: viewModel.isProcessing
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text('Processing...'),
                ],
              )
            : Text(
                'Pay $formattedAmount',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  // =============================================
  // MESSAGES
  // =============================================
  Widget _buildMessages(PaymentViewModel viewModel) {
    if (viewModel.errorMessage != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                viewModel.errorMessage!,
                style: TextStyle(color: Colors.red.shade700),
              ),
            ),
          ],
        ),
      );
    }
    
    if (viewModel.successMessage != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                viewModel.successMessage!,
                style: TextStyle(color: Colors.green.shade700),
              ),
            ),
          ],
        ),
      );
    }
    
    return const SizedBox.shrink();
  }

  // =============================================
  // PAYMENT HISTORY
  // =============================================
  Widget _buildPaymentHistory(PaymentViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        const Text(
          'Payment History',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        
        if (viewModel.isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          )
        else if (viewModel.payments.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('No payments yet'),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.payments.length > 5 ? 5 : viewModel.payments.length,
            itemBuilder: (context, index) {
              final payment = viewModel.payments[index];
              final statusColor = _getStatusColor(payment.status);
              final formattedAmount = viewModel.getFormattedAmount(
                payment.amount,
                payment.currency,
              );
              
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: statusColor,
                    child: Icon(
                      payment.status == 'completed' 
                        ? Icons.check 
                        : Icons.pending,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text('$formattedAmount ${payment.currency.toUpperCase()}'),
                  subtitle: Text(
                    'ID: ${payment.paymentIntentId ?? 'N/A'}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      payment.status.toUpperCase(),
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  void _showDialog(BuildContext context, String title, String message, Color color) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          children: [
            Icon(
              color == Colors.green ? Icons.check_circle : Icons.error,
              color: color,
            ),
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}