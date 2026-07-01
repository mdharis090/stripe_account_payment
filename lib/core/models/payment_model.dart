class PaymentModel {
  final int userId;
  final int amount;
  final String currency;
  final String? paymentIntentId;
  final String status;
  final DateTime? createdAt;

  PaymentModel({
    required this.userId,
    required this.amount,
    required this.currency,
    this.paymentIntentId,
    this.status = 'pending',
    this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      userId: json['user_id'] ?? 0,
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? 'usd',
      paymentIntentId: json['stripe_payment_intent_id'],
      status: json['status'] ?? 'pending',
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'amount': amount,
      'currency': currency,
    };
  }

  String get formattedAmount {
    final double amountInDollars = amount / 100;
    return '\$${amountInDollars.toStringAsFixed(2)}';
  }
}