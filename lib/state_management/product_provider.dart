import 'package:flutter/material.dart';
import 'package:supermarket_pos/models/product.dart';
import 'package:supermarket_pos/services/database_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  final DatabaseService _dbService = DatabaseService();

  List<Product> get products => _products;

  Future<void> fetchProducts() async {
    final data = await _dbService.queryAll('products');
    _products = data.map((item) => Product.fromMap(item)).toList();
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final id = await _dbService.insert('products', product.toMap());
    product = Product(
      id: id,
      name: product.name,
      price: product.price,
      quantity: product.quantity,
      description: product.description,
      category: product.category,
      supplier: product.supplier,
    );
    _products.add(product);
    notifyListeners();
  }

  Future<void> updateProduct(Product updatedProduct) async {
    await _dbService.update(
      'products',
      updatedProduct.toMap(),
      'id = ?',
      [updatedProduct.id],
    );
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  Future<void> updateStock(int productId, int newQuantity) async {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index] = Product(
        id: _products[index].id,
        name: _products[index].name,
        price: _products[index].price,
        quantity: newQuantity,
        description: _products[index].description,
        category: _products[index].category,
        supplier: _products[index].supplier,
      );
      await _dbService.update(
        'products',
        _products[index].toMap(),
        'id = ?',
        [productId],
      );
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int id) async {
    await _dbService.delete('products', 'id = ?', [id]);
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
