import 'package:flutter/material.dart';
import 'package:supermarket_pos/models/sale.dart';
import 'package:supermarket_pos/services/database_service.dart';
import 'package:supermarket_pos/services/sales_service.dart';

class SalesProvider with ChangeNotifier {
  List<Sale> _sales = [];
  final SalesService _salesService = SalesService();
  final DatabaseService _dbService = DatabaseService();

  List<Sale> get sales => _sales;

  Future<void> fetchSales() async {
    final data = await _dbService.queryAll('sales');
    _sales = data.map((item) => Sale.fromMap(item)).toList();
    notifyListeners();
  }

  Future<void> processSale(Sale sale) async {
    await _salesService.processSale(sale.productIds, sale.totalAmount);
    _sales.add(sale);
    notifyListeners();
  }
}
