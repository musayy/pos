class Product {
  final int id;
  final String name;
  final double price;
  final int quantity;
  final String description;
  final String category;
  final String supplier;
  final double discount;
  final double costPrice;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.description = '',
    this.category = 'General',
    this.supplier = 'Unknown',
    this.discount = 0,
    this.costPrice = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'description': description,
      'category': category,
      'supplier': supplier,
      'discount': discount,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      quantity: map['quantity'],
      description: map['description'] ?? '',
      category: map['category'] ?? 'General',
      supplier: map['supplier'] ?? 'Unknown',
      discount: map['discount'] ?? 0,
    );
  }
}
