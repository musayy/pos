import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket_pos/models/product.dart';
import 'package:supermarket_pos/utils/payment_methods.dart';
import 'package:supermarket_pos/state_management/product_provider.dart';
import 'package:supermarket_pos/state_management/theme_provider.dart';
import 'package:supermarket_pos/services/database_service.dart';
import 'package:supermarket_pos/utils/list_extensions.dart';

class SalesScreen extends StatefulWidget {
  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<Product> cartItems = [];
  Map<int, int> productQuantities = {};
  TextEditingController barcodeController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  PaymentMethod selectedPaymentMethod = PaymentMethod.cash;
  double totalAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Sales Checkout',
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
          children: [
            _buildBarcodeInput(themeProvider, productProvider),
            _buildSearchInput(themeProvider, productProvider),
            _buildProductDropdown(productProvider, themeProvider),
            Expanded(child: _buildCartList(themeProvider)),
            _buildPaymentSection(themeProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildBarcodeInput(
      ThemeProvider themeProvider, ProductProvider productProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: barcodeController,
        style: TextStyle(
            fontSize: 16,
            color: themeProvider.isDarkTheme ? Colors.white : Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.qr_code_scanner,
              color: themeProvider.isDarkTheme
                  ? Colors.white70
                  : Colors.deepPurpleAccent.shade700),
          labelText: 'Scan Product Barcode',
          labelStyle: TextStyle(
              color: themeProvider.isDarkTheme ? Colors.white70 : Colors.black),
          filled: true,
          fillColor:
              themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onSubmitted: (value) {
          _addProductByBarcode(value, productProvider);
          barcodeController.clear();
        },
      ),
    );
  }

  Widget _buildSearchInput(
      ThemeProvider themeProvider, ProductProvider productProvider) {
    List<Product> filteredProducts = [];

    return StatefulBuilder(builder: (context, setState) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              style: TextStyle(
                fontSize: 16,
                color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: themeProvider.isDarkTheme
                      ? Colors.white70
                      : Colors.deepPurpleAccent.shade700,
                ),
                labelText: 'Search Product by Name',
                labelStyle: TextStyle(
                  color:
                      themeProvider.isDarkTheme ? Colors.white70 : Colors.black,
                ),
                filled: true,
                fillColor:
                    themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: (value) {
                setState(() {
                  filteredProducts = productProvider.products.where((product) {
                    return product.name
                        .toLowerCase()
                        .contains(value.toLowerCase());
                  }).toList();
                });
              },
            ),
            if (filteredProducts.isNotEmpty && searchController.text.isNotEmpty)
              Container(
                constraints: BoxConstraints(maxHeight: 150),
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                decoration: BoxDecoration(
                  color: themeProvider.isDarkTheme
                      ? Colors.grey[800]
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ListTile(
                      title: Text(
                        product.name,
                        style: TextStyle(
                          color: themeProvider.isDarkTheme
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      onTap: () {
                        _addProductToCart(product);
                        searchController.clear();
                        setState(() {
                          filteredProducts.clear();
                        });
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildProductDropdown(
      ProductProvider productProvider, ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: DropdownButton<Product>(
        hint: Text(
          'Select Product',
          style: TextStyle(
              color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        isExpanded: true,
        items: productProvider.products.map((product) {
          return DropdownMenuItem<Product>(
            value: product,
            child: Text(product.name,
                style: TextStyle(
                    color: themeProvider.isDarkTheme
                        ? Colors.white
                        : Colors.black)),
          );
        }).toList(),
        onChanged: (product) {
          if (product != null) {
            _addProductToCart(product);
          }
        },
      ),
    );
  }

  Widget _buildCartList(ThemeProvider themeProvider) {
    return cartItems.isEmpty
        ? Center(
            child: Text(
              'Cart is empty',
              style: TextStyle(
                color:
                    themeProvider.isDarkTheme ? Colors.white70 : Colors.black54,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                final quantity = productQuantities[product.id] ?? 1;
                final discountedPrice =
                    product.price * quantity * (1 - product.discount / 100);
                return Card(
                  color: themeProvider.isDarkTheme
                      ? Colors.grey[900]
                      : Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 3,
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: themeProvider.isDarkTheme
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price: \$${discountedPrice.toStringAsFixed(2)} (${product.discount}% off)',
                          style: TextStyle(
                              color: themeProvider.isDarkTheme
                                  ? Colors.white70
                                  : Colors.grey[600]),
                        ),
                        Row(
                          children: [
                            Text(
                              'Quantity: ',
                              style: TextStyle(
                                  color: themeProvider.isDarkTheme
                                      ? Colors.white70
                                      : Colors.grey[600]),
                            ),
                            IconButton(
                              icon: Icon(Icons.remove_circle,
                                  color: themeProvider.isDarkTheme
                                      ? Colors.redAccent
                                      : Colors.redAccent),
                              onPressed: () {
                                _updateProductQuantity(product, -1);
                              },
                            ),
                            Text(
                              '$quantity',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: themeProvider.isDarkTheme
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            IconButton(
                              icon: Icon(Icons.add_circle,
                                  color: themeProvider.isDarkTheme
                                      ? Colors.green
                                      : Colors.green),
                              onPressed: () {
                                _updateProductQuantity(product, 1);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        _removeProductFromCart(product);
                      },
                    ),
                  ),
                );
              },
            ),
          );
  }

  Widget _buildPaymentSection(ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 12.0),
          Text(
            'Select Payment Method:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
          Row(
            children: [
              _buildPaymentOption(PaymentMethod.cash, 'Cash', themeProvider),
              _buildPaymentOption(PaymentMethod.card, 'Card', themeProvider),
              _buildPaymentOption(
                  PaymentMethod.digitalWallet, 'Digital Wallet', themeProvider),
            ],
          ),
          SizedBox(height: 16.0),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: cartItems.isEmpty ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeProvider.isDarkTheme
                      ? Colors.grey[800]
                      : const Color.fromARGB(255, 106, 0, 255),
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 12,
                  ),
                  textStyle: TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Process Payment',
                    style: TextStyle(
                        color: themeProvider.isDarkTheme
                            ? Colors.white
                            : const Color.fromARGB(255, 0, 0, 0))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
      PaymentMethod method, String label, ThemeProvider themeProvider) {
    return Expanded(
      child: RadioListTile<PaymentMethod>(
        title: Text(label,
            style: TextStyle(
                color:
                    themeProvider.isDarkTheme ? Colors.white : Colors.black)),
        value: method,
        groupValue: selectedPaymentMethod,
        onChanged: (PaymentMethod? value) {
          if (value != null) {
            setState(() {
              selectedPaymentMethod = value;
            });
          }
        },
      ),
    );
  }

  void _addProductByBarcode(String barcode, ProductProvider productProvider) {
    final Product? product = productProvider.products.firstWhereOrNull(
      (p) => p.id.toString() == barcode,
    );

    if (product != null) {
      _addProductToCart(product);
    } else {
      _showErrorDialog('Product not found');
    }
  }

  void _searchProductByName(ProductProvider productProvider) {
    final searchQuery = searchController.text.toLowerCase();

    final Product? matchingProduct = productProvider.products.firstWhereOrNull(
      (product) => product.name.toLowerCase().contains(searchQuery),
    );

    if (matchingProduct != null) {
      _addProductToCart(matchingProduct);
    } else {
      _showErrorDialog('Product not found');
    }
  }

  void _addProductToCart(Product product) {
    setState(() {
      cartItems.add(product);
      productQuantities[product.id] = (productQuantities[product.id] ?? 0) + 1;
      totalAmount += product.price * (1 - product.discount / 100);
    });
  }

  void _updateProductQuantity(Product product, int change) {
    setState(() {
      final currentQuantity = productQuantities[product.id] ?? 1;
      final newQuantity = (currentQuantity + change).clamp(1, 100);

      productQuantities[product.id] = newQuantity;
      totalAmount += product.price * change * (1 - product.discount / 100);
    });
  }

  void _removeProductFromCart(Product product) {
    final quantity = productQuantities[product.id] ?? 1;
    final discountedPrice =
        product.price * quantity * (1 - product.discount / 100);

    setState(() {
      totalAmount -= discountedPrice;
      cartItems.removeWhere((p) => p.id == product.id);
      productQuantities.remove(product.id);
    });
  }

  void _processPayment() async {
    final dbService = DatabaseService();
    await dbService.insert('sales', {
      'productIds': cartItems.map((p) => p.id).join(','),
      'totalAmount': totalAmount,
      'date': DateTime.now().toIso8601String(),
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Payment Processed'),
          content: Text(
            'Payment of \$${totalAmount.toStringAsFixed(2)} completed using ${selectedPaymentMethod.name}.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  cartItems.clear();
                  totalAmount = 0.0;
                  productQuantities.clear();
                });
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
