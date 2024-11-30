import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket_pos/state_management/user_provider.dart';
import 'package:supermarket_pos/state_management/theme_provider.dart';
import 'package:supermarket_pos/models/user.dart';
import 'package:supermarket_pos/models/role_permissions.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = userProvider.currentUser;

    if (user == null) {
      return _buildGuestView(context, themeProvider);
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Home',
            // 'Home - ${user.username} (${user.role.name.toUpperCase()})',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkTheme ? Colors.white : Colors.white,
            ),
          ),
        ),
        backgroundColor: themeProvider.isDarkTheme
            ? Colors.black
            : const Color.fromARGB(255, 120, 37, 237),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: themeProvider.isDarkTheme ? Colors.white : Colors.white,
            ),
            onPressed: () {
              userProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
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
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeMessage(user, themeProvider),
            SizedBox(height: 12),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 12.0,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: _buildNavItems(context).length,
                    itemBuilder: (context, index) {
                      return _buildNavItems(context)[index];
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestView(BuildContext context, ThemeProvider themeProvider) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: themeProvider.isDarkTheme ? Colors.white : Colors.white,
          ),
        ),
        backgroundColor: themeProvider.isDarkTheme
            ? Colors.black
            : Colors.deepPurpleAccent.shade700,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No user logged in',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.isDarkTheme
                    ? Colors.grey[800]
                    : Colors.deepPurpleAccent.shade700,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Login', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage(User user, ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: themeProvider.isDarkTheme
                ? Colors.grey[700]
                : Colors.deepPurpleAccent.shade700,
            child: Text(
              user.username[0].toUpperCase(),
              style: TextStyle(
                color: themeProvider.isDarkTheme ? Colors.white : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 12.0),
          Text(
            'Welcome, ${user.username}!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildNavItems(BuildContext context) {
    return [
      _buildNavItem(
        context: context,
        icon: Icons.point_of_sale,
        title: 'Sales',
        routeName: '/sales',
        allowedRoles: [UserRole.cashier, UserRole.manager, UserRole.admin],
        permissionCheck: (permissions) => permissions.canAccessSales,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.inventory,
        title: 'Product Management',
        routeName: '/products',
        allowedRoles: [UserRole.manager, UserRole.admin],
        permissionCheck: (permissions) =>
            permissions.canAccessProductManagement,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.local_offer,
        title: 'Promotion Management',
        routeName: '/promotions',
        allowedRoles: [UserRole.manager, UserRole.admin],
        permissionCheck: (permissions) =>
            permissions.canAccessPromotionManagement,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.admin_panel_settings,
        title: 'Role Management',
        routeName: '/roleManagement',
        allowedRoles: [UserRole.admin],
        permissionCheck: (permissions) => true,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.people,
        title: 'Customer Management',
        routeName: '/customers',
        allowedRoles: [UserRole.manager, UserRole.admin],
        permissionCheck: (permissions) =>
            permissions.canAccessCustomerManagement,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.report,
        title: 'Reports',
        routeName: '/reports',
        allowedRoles: [UserRole.manager, UserRole.admin],
        permissionCheck: (permissions) => permissions.canAccessReports,
      ),
      _buildNavItem(
        context: context,
        icon: Icons.settings,
        title: 'Settings',
        routeName: '/settings',
        allowedRoles: [UserRole.admin],
        permissionCheck: (permissions) => permissions.canAccessSettings,
      ),
    ];
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String routeName,
    required List<UserRole> allowedRoles,
    required bool Function(RolePermissions) permissionCheck,
  }) {
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final role = userProvider.currentUser?.role;

    if (role == null || !allowedRoles.contains(role)) {
      return SizedBox();
    }

    final rolePermissions =
        userProvider.rolePermissions[role] ?? RolePermissions();
    final hasPermission = permissionCheck(rolePermissions);

    if (!hasPermission) {
      return SizedBox();
    }

    return Tooltip(
      message: 'Navigate to $title',
      child: AnimatedNavItem(
        icon: icon,
        title: title,
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
        isDarkTheme: themeProvider.isDarkTheme,
      ),
    );
  }
}

class AnimatedNavItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDarkTheme;

  const AnimatedNavItem({
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isDarkTheme,
  });

  @override
  _AnimatedNavItemState createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<AnimatedNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.isDarkTheme
                        ? Colors.grey.withOpacity(0.6)
                        : Colors.deepPurpleAccent.shade100.withOpacity(0.6),
                    blurRadius: 8,
                    offset: Offset(2, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: widget.isDarkTheme ? Colors.black38 : Colors.black26,
                    blurRadius: 6,
                    offset: Offset(2, 4),
                  ),
                ],
          gradient: LinearGradient(
            colors: _isHovered
                ? widget.isDarkTheme
                    ? [Colors.grey.shade800, Colors.grey.shade900]
                    : [Colors.deepPurple.shade200, Colors.deepPurple.shade700]
                : widget.isDarkTheme
                    ? [Colors.grey.shade700, Colors.grey.shade800]
                    : [
                        Colors.purpleAccent.shade100,
                        Colors.deepPurple.shade400
                      ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: 28,
              color: widget.isDarkTheme ? Colors.white : Colors.white,
            ),
            SizedBox(height: 6.0),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: widget.isDarkTheme ? Colors.white : Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
