class Rental {
  final String id;
  final String propertyId;
  final String tenantId;

  final double rentAmount;
  final DateTime startDate;

  final bool isActive;
  final bool isPaid; // KEEP for simplicity (manual toggle)

  Rental({
    required this.id,
    required this.propertyId,
    required this.tenantId,
    required this.rentAmount,
    required this.startDate,
    this.isActive = true,
    this.isPaid = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'propertyId': propertyId,
    'tenantId': tenantId,
    'rentAmount': rentAmount,
    'startDate': startDate.toIso8601String(),
    'isActive': isActive,
    'isPaid': isPaid,
  };

  factory Rental.fromMap(Map<String, dynamic> map) => Rental(
    id: map['id']?.toString() ?? '',
    propertyId: map['propertyId']?.toString() ?? '',
    tenantId: map['tenantId']?.toString() ?? '',
    rentAmount: (map['rentAmount'] ?? 0).toDouble(),
    startDate: DateTime.tryParse(map['startDate'] ?? '') ?? DateTime.now(),
    isActive: map['isActive'] ?? true,
    isPaid: map['isPaid'] ?? false,
  );

  Rental copyWith({
    String? id,
    String? propertyId,
    String? tenantId,
    double? rentAmount,
    DateTime? startDate,
    bool? isActive,
    bool? isPaid,
  }) => Rental(
    id: id ?? this.id,
    propertyId: propertyId ?? this.propertyId,
    tenantId: tenantId ?? this.tenantId,
    rentAmount: rentAmount ?? this.rentAmount,
    startDate: startDate ?? this.startDate,
    isActive: isActive ?? this.isActive,
    isPaid: isPaid ?? this.isPaid,
  );
}
