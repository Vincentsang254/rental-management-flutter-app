class Tenant {
  final String id;
  final String name;
  final String phone;

  Tenant({required this.id, required this.name, required this.phone});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'phone': phone};

  factory Tenant.fromMap(Map<String, dynamic> map) => Tenant(
    id: map['id']?.toString() ?? '',
    name: map['name']?.toString() ?? '',
    phone: map['phone']?.toString() ?? '',
  );

  Tenant copyWith({required String phone}) {
    return Tenant(id: id, name: name, phone: phone);
  }
}
