class Rental {
  final String id;
  final String propertyId;
  final String tenantId;

  final double expectedAmount;
  final DateTime startDate;

  final bool isActive;
  final String amountPaid; // now a status string

  Rental({
    required this.id,
    required this.propertyId,
    required this.tenantId,
    required this.expectedAmount,
    required this.startDate,
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
  };

  factory Rental.fromMap(Map<String, dynamic> map) => Rental(
    id: map['id']?.toString() ?? '',
    propertyId: map['propertyId']?.toString() ?? '',
    tenantId: map['tenantId']?.toString() ?? '',
    expectedAmount:
        double.tryParse(map['expectedAmount']?.toString() ?? '0') ?? 0,
    startDate: DateTime.tryParse(map['startDate'] ?? '') ?? DateTime.now(),
    isActive: map['isActive'] ?? true,
    amountPaid: map['amountPaid']?.toString() ?? "unpaid",
  );

  Rental copyWith({
    String? id,
    String? propertyId,
    String? tenantId,
    double? expectedAmount,
    DateTime? startDate,
    bool? isActive,
    String? amountPaid,
  }) => Rental(
    id: id ?? this.id,
    propertyId: propertyId ?? this.propertyId,
    tenantId: tenantId ?? this.tenantId,
    expectedAmount: expectedAmount ?? this.expectedAmount,
    startDate: startDate ?? this.startDate,
    isActive: isActive ?? this.isActive,
    amountPaid: amountPaid ?? this.amountPaid,
  );

  /// 🔥 Helpers (VERY IMPORTANT)
  bool get isPaid => amountPaid == "paid";

  bool get isPartial => amountPaid == "partial";

  bool get isUnpaid => amountPaid == "unpaid";
}
