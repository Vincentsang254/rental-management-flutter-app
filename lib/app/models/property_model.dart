class Property {
  final String id;
  final String name;
  final String location;
  final double rentAmount;
  final bool isOccupied;

  Property({
    required this.id,
    required this.name,
    required this.location,
    required this.rentAmount,
    this.isOccupied = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'location': location,
        'rentAmount': rentAmount,
        'isOccupied': isOccupied,
      };

  factory Property.fromMap(Map<String, dynamic> map) => Property(
        id: map['id'] ?? '',
        name: map['name'] ?? '',
        location: map['location'] ?? '',
        rentAmount: (map['rentAmount'] ?? 0).toDouble(),
        isOccupied: map['isOccupied'] ?? false,
      );
}