import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function(int index) onDelete;

  ProductList({required this.products, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: ListTile(
            title: Text(products[index]['name']),
            subtitle: Text(
                'Price: \$${products[index]['price']} - Quantity: ${products[index]['quantity']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => onDelete(index),
            ),
          ),
        );
      },
    );
  }
}
