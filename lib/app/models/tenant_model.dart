class Tenant {
  final String id;
  final String name;
  final String phone;
  final String house;

  Tenant({
    required this.id,
    required this.name,
    required this.phone,
    required this.house,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'phone': phone,
    'house': house,
  };

  factory Tenant.fromMap(Map<String, dynamic> map) => Tenant(
    id: map['id'] ?? '',
    name: map['name'] ?? '',
    phone: map['phone'] ?? '',
    house: map['house'] ?? '',
  );
}
