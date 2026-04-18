class Property {
  final String id;
  final String houseNumber;
  final double rentAmount;

  Property({
    required this.id,
    required this.houseNumber,
    required this.rentAmount,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'houseNumber': houseNumber,
    'rentAmount': rentAmount,
  };

  factory Property.fromMap(Map<String, dynamic> map) => Property(
    id: map['id']?.toString() ?? '',
    houseNumber: map['houseNumber']?.toString() ?? '',
    rentAmount: (map['rentAmount'] ?? 0).toDouble(),
  );
}
