class Customer {
  final int id;
  final String name;
  final String phone;
  final String email;
  final int loyaltyPoints;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    this.email = '',
    this.loyaltyPoints = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'loyaltyPoints': loyaltyPoints,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'] ?? '',
      loyaltyPoints: map['loyaltyPoints'] ?? 0,
    );
  }
}
