double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

class Rental {
  final String id;
  final String propertyId;
  final String tenantId;

  final double expectedAmount;
  final double amountPaid;

  final DateTime billingMonth;
  final DateTime startDate;
  final bool isActive;

  Rental({
    required this.id,
    required this.propertyId,
    required this.tenantId,
    required this.expectedAmount,
    required this.amountPaid,
    required this.billingMonth,
    required this.startDate,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'propertyId': propertyId,
        'tenantId': tenantId,
        'expectedAmount': expectedAmount,
        'amountPaid': amountPaid,
        'billingMonth': billingMonth.toIso8601String(),
        'startDate': startDate.toIso8601String(),
        'isActive': isActive,
      };

  factory Rental.fromMap(Map<String, dynamic> map) => Rental(
        id: map['id']?.toString() ?? '',
        propertyId: map['propertyId']?.toString() ?? '',
        tenantId: map['tenantId']?.toString() ?? '',
        expectedAmount: _toDouble(map['expectedAmount']),
        amountPaid: _toDouble(map['amountPaid']),
        billingMonth:
            DateTime.tryParse(map['billingMonth'] ?? '') ?? DateTime.now(),
        startDate:
            DateTime.tryParse(map['startDate'] ?? '') ?? DateTime.now(),
        isActive: map['isActive'] == true,
      );

  Rental copyWith({
    double? amountPaid,
    bool? isActive,
  }) {
    return Rental(
      id: id,
      propertyId: propertyId,
      tenantId: tenantId,
      expectedAmount: expectedAmount,
      amountPaid: amountPaid ?? this.amountPaid,
      billingMonth: billingMonth,
      startDate: startDate,
      isActive: isActive ?? this.isActive,
    );
  }

  Rental addPayment(double payment) {
    if (payment <= 0) return this;

    return copyWith(amountPaid: amountPaid + payment);
  }

  double get balance => expectedAmount - amountPaid;
  double get remaining => balance > 0 ? balance : 0;

  double get overpaid =>
      amountPaid > expectedAmount ? amountPaid - expectedAmount : 0;

  bool get isPaid => amountPaid >= expectedAmount;
}