import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket_pos/models/product.dart';
import 'package:supermarket_pos/state_management/product_provider.dart';
import 'package:supermarket_pos/state_management/theme_provider.dart';

class PromotionManagementScreen extends StatefulWidget {
  @override
  _PromotionManagementScreenState createState() =>
      _PromotionManagementScreenState();
}

class _PromotionManagementScreenState extends State<PromotionManagementScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController discountController = TextEditingController();
  bool _showForm = false;
  late AnimationController _animationController;
  late Animation<double> _formOpacity;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _formOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Promotion Management',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color:
                      themeProvider.isDarkTheme ? Colors.white : Colors.black)),
        ),
        backgroundColor: themeProvider.isDarkTheme
            ? Colors.black
            : Colors.deepPurpleAccent.shade700,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPromotionForm(context),
        backgroundColor: themeProvider.isDarkTheme
            ? Colors.grey[800]
            : const Color.fromARGB(255, 255, 255, 255),
        child: Icon(Icons.percent),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: themeProvider.isDarkTheme
              ? LinearGradient(
                  colors: [Colors.black87, Colors.black54],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    Colors.deepPurple.shade700,
                    Colors.deepPurpleAccent.shade200
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Apply Discounts to Products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      themeProvider.isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
            ),
            Expanded(
              child: productProvider.products.isEmpty
                  ? Center(
                      child: Text(
                        'No products available',
                        style: TextStyle(
                          color: themeProvider.isDarkTheme
                              ? Colors.white70
                              : Colors.black54,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: productProvider.products.length,
                      itemBuilder: (context, index) {
                        final product = productProvider.products[index];
                        return _buildProductCard(
                            context, product, themeProvider, productProvider);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product,
      ThemeProvider themeProvider, ProductProvider productProvider) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      color: themeProvider.isDarkTheme ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        title: Text(
          product.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Price: \$${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                color:
                    themeProvider.isDarkTheme ? Colors.white70 : Colors.black54,
              ),
            ),
            Text(
              'Current Discount: ${product.discount}%',
              style: TextStyle(
                color:
                    themeProvider.isDarkTheme ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit, color: Colors.blue),
          onPressed: () => _showDiscountDialog(product, productProvider),
        ),
      ),
    );
  }

  void _showDiscountDialog(Product product, ProductProvider productProvider) {
    discountController.text = product.discount.toString();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Set Discount for ${product.name}'),
          content: TextField(
            controller: discountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Discount Percentage',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newDiscount =
                    double.tryParse(discountController.text) ?? 0;
                final updatedProduct = Product(
                  id: product.id,
                  name: product.name,
                  price: product.price,
                  quantity: product.quantity,
                  description: product.description,
                  category: product.category,
                  supplier: product.supplier,
                  discount: newDiscount,
                );
                productProvider.updateProduct(updatedProduct);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _showPromotionForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bulk Apply Promotion',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            TextField(
              controller: discountController,
              decoration: InputDecoration(
                labelText: 'Discount Percentage',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _applyBulkDiscount(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Apply to All'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyBulkDiscount(BuildContext context) {
    final discountValue = double.tryParse(discountController.text) ?? 0;
    if (discountValue > 0) {
      final productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      for (var product in productProvider.products) {
        final updatedProduct = Product(
          id: product.id,
          name: product.name,
          price: product.price,
          quantity: product.quantity,
          description: product.description,
          category: product.category,
          supplier: product.supplier,
          discount: discountValue,
        );
        productProvider.updateProduct(updatedProduct);
      }
      Navigator.of(context).pop();
    } else {
      _showErrorDialog('Please enter a valid discount percentage.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
