class Sale {
  final int id;
  final List<int> productIds;
  final double totalAmount;
  final DateTime date;

  Sale({
    required this.id,
    required this.productIds,
    required this.totalAmount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productIds': productIds.join(','),
      'totalAmount': totalAmount,
      'date': date.toIso8601String(),
    };
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      productIds:
          map['productIds'].split(',').map((e) => int.parse(e)).toList(),
      totalAmount: map['totalAmount'],
      date: DateTime.parse(map['date']),
    );
  }
}
