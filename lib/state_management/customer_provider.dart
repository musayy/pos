import 'package:flutter/material.dart';
import 'package:supermarket_pos/models/customer.dart';
import 'package:supermarket_pos/services/database_service.dart';

class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [];
  final DatabaseService _dbService = DatabaseService();

  List<Customer> get customers => _customers;

  Future<void> fetchCustomers() async {
    final data = await _dbService.queryAll('customers');
    _customers = data.map((item) => Customer.fromMap(item)).toList();
    notifyListeners();
  }

  Future<void> addCustomer(Customer customer) async {
    final id = await _dbService.insert('customers', customer.toMap());
    customer = Customer(
      id: id,
      name: customer.name,
      phone: customer.phone,
      email: customer.email,
      loyaltyPoints: customer.loyaltyPoints,
    );
    _customers.add(customer);
    notifyListeners();
  }

  Future<void> updateCustomer(Customer updatedCustomer) async {
    await _dbService.update(
      'customers',
      updatedCustomer.toMap(),
      'id = ?',
      [updatedCustomer.id],
    );
    final index = _customers.indexWhere((c) => c.id == updatedCustomer.id);
    if (index != -1) {
      _customers[index] = updatedCustomer;
      notifyListeners();
    }
  }

  Future<void> deleteCustomer(int id) async {
    await _dbService.delete('customers', 'id = ?', [id]);
    _customers.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}
