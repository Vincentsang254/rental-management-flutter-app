class Rental {
  final String id;
  final String propertyId;
  final String tenantName;
  final String startDate;
  final double rentAmount;
  final bool isActive;

  Rental({
    required this.id,
    required this.propertyId,
    required this.tenantName,
    required this.startDate,
    required this.rentAmount,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'propertyId': propertyId,
    'tenantName': tenantName,
    'startDate': startDate,
    'rentAmount': rentAmount,
    'isActive': isActive,
  };

  factory Rental.fromMap(Map<String, dynamic> map) => Rental(
    id: map['id'] ?? '',
    propertyId: map['propertyId'] ?? '',
    tenantName: map['tenantName'] ?? '',
    startDate: map['startDate'] ?? '',
    rentAmount: (map['rentAmount'] ?? 0).toDouble(),
    isActive: map['isActive'] ?? true,
  );
}
