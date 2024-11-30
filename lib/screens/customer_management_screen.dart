import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket_pos/models/customer.dart';
import 'package:supermarket_pos/state_management/customer_provider.dart';
import 'package:supermarket_pos/state_management/theme_provider.dart';

class CustomerManagementScreen extends StatefulWidget {
  @override
  _CustomerManagementScreenState createState() =>
      _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController loyaltyPointsController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool _showForm = false;
  late AnimationController _animationController;
  late Animation<double> _formOpacity;
  String _searchQuery = '';

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
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    loyaltyPointsController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<CustomerProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final customers = _searchQuery.isEmpty
        ? customerProvider.customers
        : customerProvider.customers.where((customer) {
            return customer.name
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Customer Management',
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search,
                      color: themeProvider.isDarkTheme
                          ? Colors.white70
                          : Colors.black54),
                  hintText: 'Search customers...',
                  filled: true,
                  fillColor: themeProvider.isDarkTheme
                      ? Colors.grey[800]
                      : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _showForm
                  ? _buildCustomerForm(themeProvider, customerProvider)
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
              child: Text(
                'Customer List',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      themeProvider.isDarkTheme ? Colors.white : Colors.black,
                ),
              ),
            ),
            Expanded(
              child: _buildCustomerList(
                  themeProvider, customers, customerProvider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerForm(
      ThemeProvider themeProvider, CustomerProvider customerProvider) {
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
              'Add New Customer',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            _buildTextField(nameController, 'Name', themeProvider),
            SizedBox(height: 8.0),
            _buildTextField(phoneController, 'Phone', themeProvider,
                keyboardType: TextInputType.phone),
            SizedBox(height: 8.0),
            _buildTextField(emailController, 'Email', themeProvider,
                keyboardType: TextInputType.emailAddress),
            SizedBox(height: 8.0),
            _buildTextField(
                loyaltyPointsController, 'Loyalty Points', themeProvider,
                keyboardType: TextInputType.number),
            SizedBox(height: 12.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _addCustomer(customerProvider);
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
                child: Text('Add Customer'),
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

  Widget _buildCustomerList(ThemeProvider themeProvider,
      List<Customer> customers, CustomerProvider customerProvider) {
    return customers.isEmpty
        ? Center(
            child: Text(
              'No customers available',
              style: TextStyle(
                color:
                    themeProvider.isDarkTheme ? Colors.white70 : Colors.black54,
                fontSize: 16,
              ),
            ),
          )
        : Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
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
                      customer.name,
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
                          'Phone: ${customer.phone}',
                          style: TextStyle(
                              color: themeProvider.isDarkTheme
                                  ? Colors.white70
                                  : Colors.grey[600]),
                        ),
                        Text(
                          'Email: ${customer.email}',
                          style: TextStyle(
                              color: themeProvider.isDarkTheme
                                  ? Colors.white70
                                  : Colors.grey[600]),
                        ),
                        Text(
                          'Loyalty Points: ${customer.loyaltyPoints}',
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
                        _confirmDeleteCustomer(
                            context, customerProvider, customer);
                      },
                    ),
                  ),
                );
              },
            ),
          );
  }

  void _confirmDeleteCustomer(BuildContext context,
      CustomerProvider customerProvider, Customer customer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${customer.name}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                customerProvider.deleteCustomer(customer.id);
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }

  void _addCustomer(CustomerProvider customerProvider) {
    final newCustomer = Customer(
      id: DateTime.now().millisecondsSinceEpoch,
      name: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
      loyaltyPoints: int.tryParse(loyaltyPointsController.text) ?? 0,
    );

    if (newCustomer.name.isNotEmpty && newCustomer.phone.isNotEmpty) {
      customerProvider.addCustomer(newCustomer);
      _clearFormFields();
    } else {
      _showErrorDialog('Please enter valid customer details.');
    }
  }

  void _clearFormFields() {
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    loyaltyPointsController.clear();
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
