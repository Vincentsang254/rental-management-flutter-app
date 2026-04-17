class Payment {
  final String id;
  final double amount;
  final bool isPaid;

  Payment({required this.id, required this.amount, this.isPaid = false});

  Map<String, dynamic> toMap() => {
    'id': id,
    'amount': amount,
    'isPaid': isPaid,
  };

  factory Payment.fromMap(Map<String, dynamic> map) => Payment(
    id: map['id'] ?? '',
    amount: (map['amount'] ?? 0).toDouble(),
    isPaid: map['isPaid'] ?? false,
  );
}
