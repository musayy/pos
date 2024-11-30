import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket_pos/screens/home_screen.dart';
import 'package:supermarket_pos/screens/login_screen.dart';
import 'package:supermarket_pos/screens/product_management_screen.dart';
import 'package:supermarket_pos/screens/promotion_management_screen.dart';
import 'package:supermarket_pos/screens/reports_screen.dart';
import 'package:supermarket_pos/screens/sales_screen.dart';
import 'package:supermarket_pos/screens/settings_screen.dart';
import 'package:supermarket_pos/state_management/user_provider.dart';
import 'package:supermarket_pos/models/user.dart';

class NavigationSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    return Container(
      width: 200,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'POS Navigation',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: Colors.white),
                ),
                SizedBox(height: 8.0),
                if (currentUser != null)
                  Text(
                    'User: ${currentUser.username} (${currentUser.role.name.toUpperCase()})',
                    style: TextStyle(color: Colors.white70),
                  )
                else
                  Text(
                    'Not Logged In',
                    style: TextStyle(color: Colors.white70),
                  ),
              ],
            ),
          ),
          _buildNavItem(
            context: context,
            icon: Icons.home,
            title: 'Home',
            navigateTo: HomeScreen(),
            allowedRoles: UserRole.values,
          ),
          _buildNavItem(
            context: context,
            icon: Icons.point_of_sale,
            title: 'Sales',
            navigateTo: SalesScreen(),
            allowedRoles: [UserRole.cashier, UserRole.manager, UserRole.admin],
          ),
          _buildNavItem(
            context: context,
            icon: Icons.inventory,
            title: 'Product Management',
            navigateTo: ProductManagementScreen(),
            allowedRoles: [UserRole.manager, UserRole.admin],
          ),
          _buildNavItem(
            context: context,
            icon: Icons.local_offer,
            title: 'Promotion Management',
            navigateTo: PromotionManagementScreen(),
            allowedRoles: [UserRole.manager, UserRole.admin],
          ),
          _buildNavItem(
            context: context,
            icon: Icons.report,
            title: 'Reports',
            navigateTo: ReportsScreen(),
            allowedRoles: [UserRole.manager, UserRole.admin],
          ),
          _buildNavItem(
            context: context,
            icon: Icons.settings,
            title: 'Settings',
            navigateTo: SettingsScreen(),
            allowedRoles: [UserRole.admin],
          ),
          _buildNavItem(
            context: context,
            icon: Icons.logout,
            title: currentUser != null ? 'Logout' : 'Login',
            navigateTo: currentUser != null ? null : LoginScreen(),
            allowedRoles: UserRole.values,
            onTapOverride: () {
              if (currentUser != null) {
                userProvider.logout();
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    Widget? navigateTo,
    required List<UserRole> allowedRoles,
    VoidCallback? onTapOverride,
  }) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    if (!allowedRoles.contains(currentUser?.role ?? UserRole.cashier)) {
      return SizedBox();
    }

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTapOverride ??
          () {
            if (navigateTo != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => navigateTo),
              );
            }
          },
    );
  }
}
