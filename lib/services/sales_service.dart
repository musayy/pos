import 'package:supermarket_pos/services/database_service.dart';

class SalesService {
  final DatabaseService _dbService = DatabaseService();

  Future<void> processSale(List<int> productIds, double totalAmount) async {
    final saleData = {
      'productIds': productIds.join(','),
      'totalAmount': totalAmount,
      'date': DateTime.now().toIso8601String(),
    };
    await _dbService.insert('sales', saleData);
  }

  Future<List<Map<String, dynamic>>> getAllSales() async {
    return await _dbService.queryAll('sales');
  }
}
