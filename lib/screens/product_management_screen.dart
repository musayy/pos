import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket_pos/models/product.dart';
import 'package:supermarket_pos/state_management/product_provider.dart';
import 'package:supermarket_pos/state_management/theme_provider.dart';

class ProductManagementScreen extends StatefulWidget {
  @override
  _ProductManagementScreenState createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Product Management',
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
        onPressed: _toggleFormVisibility,
        backgroundColor: themeProvider.isDarkTheme
            ? Colors.grey[800]
            : const Color.fromARGB(255, 255, 255, 255),
        child: Icon(_showForm ? Icons.close : Icons.add),
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
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _showForm
                  ? _buildProductForm(themeProvider, productProvider)
                  : SizedBox.shrink(),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
            ),
            Divider(
              color: themeProvider.isDarkTheme ? Colors.white70 : Colors.grey,
              thickness: 1.2,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Product List',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        themeProvider.isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            Expanded(child: _buildProductList(themeProvider, productProvider)),
          ],
        ),
      ),
    );
  }

  Widget _buildProductForm(
      ThemeProvider themeProvider, ProductProvider productProvider) {
    return FadeTransition(
      opacity: _formOpacity,
      child: Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: themeProvider.isDarkTheme ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color:
                  themeProvider.isDarkTheme ? Colors.black38 : Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add New Product',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            _buildTextField(nameController, 'Product Name', themeProvider),
            SizedBox(height: 8.0),
            _buildTextField(priceController,
                'Price (${themeProvider.currencySymbol})', themeProvider,
                keyboardType: TextInputType.number),
            SizedBox(height: 8.0),
            _buildTextField(quantityController, 'Quantity', themeProvider,
                keyboardType: TextInputType.number),
            SizedBox(height: 8.0),
            _buildTextField(
                descriptionController, 'Description', themeProvider),
            SizedBox(height: 8.0),
            _buildTextField(categoryController, 'Category', themeProvider),
            SizedBox(height: 8.0),
            _buildTextField(supplierController, 'Supplier', themeProvider),
            SizedBox(height: 12.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _addProduct(productProvider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeProvider.isDarkTheme
                      ? Colors.grey[800]
                      : Colors.deepPurpleAccent.shade700,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Add Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    ThemeProvider themeProvider, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
          color: themeProvider.isDarkTheme ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: themeProvider.isDarkTheme ? Colors.white70 : Colors.black54),
        filled: true,
        fillColor: themeProvider.isDarkTheme ? Colors.grey[800] : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildProductList(
      ThemeProvider themeProvider, ProductProvider productProvider) {
    return productProvider.products.isEmpty
        ? Center(
            child: Text(
              'No products available',
              style: TextStyle(
                color:
                    themeProvider.isDarkTheme ? Colors.white70 : Colors.black54,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        : Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: ListView.builder(
              itemCount: productProvider.products.length,
              itemBuilder: (context, index) {
                final product = productProvider.products[index];
                return Card(
                  color: themeProvider.isDarkTheme
                      ? Colors.grey[900]
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 6),
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
                          'Price: ${themeProvider.currencySymbol}${product.price.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: themeProvider.isDarkTheme
                                  ? Colors.white70
                                  : Colors.grey[600]),
                        ),
                        Text(
                          'Quantity: ${product.quantity}',
                          style: TextStyle(
                              color: themeProvider.isDarkTheme
                                  ? Colors.white70
                                  : Colors.grey[600]),
                        ),
                        Text(
                          'Category: ${product.category}',
                          style: TextStyle(
                              color: themeProvider.isDarkTheme
                                  ? Colors.white70
                                  : Colors.grey[600]),
                        ),
                        Text(
                          'Supplier: ${product.supplier}',
                          style: TextStyle(
                              color: themeProvider.isDarkTheme
                                  ? Colors.white70
                                  : Colors.grey[600]),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () {
                        _confirmDeleteProduct(
                            context, productProvider, product);
                      },
                    ),
                  ),
                );
              },
            ),
          );
  }

  void _confirmDeleteProduct(
      BuildContext context, ProductProvider productProvider, Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${product.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                productProvider.deleteProduct(product.id);
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }

  void _addProduct(ProductProvider productProvider) {
    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch,
      name: nameController.text,
      price: double.tryParse(priceController.text) ?? 0,
      quantity: int.tryParse(quantityController.text) ?? 0,
      description: descriptionController.text,
      category: categoryController.text.isNotEmpty
          ? categoryController.text
          : 'General',
      supplier: supplierController.text.isNotEmpty
          ? supplierController.text
          : 'Unknown',
    );

    if (newProduct.name.isNotEmpty &&
        newProduct.price > 0 &&
        newProduct.quantity > 0) {
      productProvider.addProduct(newProduct);
      _clearFormFields();
    } else {
      _showErrorDialog('Please enter valid product details.');
    }
  }

  void _clearFormFields() {
    nameController.clear();
    priceController.clear();
    quantityController.clear();
    descriptionController.clear();
    categoryController.clear();
    supplierController.clear();
  }

  void _toggleFormVisibility() {
    setState(() {
      _showForm = !_showForm;
      if (_showForm) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
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
