class Rental {
  final String id;
  final String propertyId;
  final String tenantId;

  final double expectedAmount;
  final DateTime startDate;

  final bool isActive;

  /// "paid", "unpaid"
  final String amountPaid;

  /// 📅 NEW: month tracking
  final String month;

  Rental({
    required this.id,
    required this.propertyId,
    required this.tenantId,
    required this.expectedAmount,
    required this.startDate,
    required this.month,
    this.isActive = true,
    this.amountPaid = "unpaid",
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'propertyId': propertyId,
    'tenantId': tenantId,
    'expectedAmount': expectedAmount,
    'startDate': startDate.toIso8601String(),
    'isActive': isActive,
    'amountPaid': amountPaid,
    'month': month,
  };

  factory Rental.fromMap(Map<String, dynamic> map) => Rental(
    id: map['id']?.toString() ?? '',
    propertyId: map['propertyId']?.toString() ?? '',
    tenantId: map['tenantId']?.toString() ?? '',
    expectedAmount: (map['expectedAmount'] ?? 0).toDouble(),
    startDate: DateTime.tryParse(map['startDate'] ?? '') ?? DateTime.now(),
    isActive: map['isActive'] ?? true,
    amountPaid: map['amountPaid'] ?? "unpaid",
    month: map['month'] ?? _currentMonth(),
  );

  Rental copyWith({String? amountPaid, bool? isActive}) => Rental(
    id: id,
    propertyId: propertyId,
    tenantId: tenantId,
    expectedAmount: expectedAmount,
    startDate: startDate,
    month: month,
    isActive: isActive ?? this.isActive,
    amountPaid: amountPaid ?? this.amountPaid,
  );

  static String _currentMonth() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}";
  }
}
