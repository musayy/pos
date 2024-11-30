import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket_pos/models/user.dart';
import 'package:supermarket_pos/models/role_permissions.dart';
import 'package:supermarket_pos/state_management/user_provider.dart';
import 'package:supermarket_pos/state_management/theme_provider.dart';

class RoleManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentUser = userProvider.currentUser;

    if (currentUser?.role != UserRole.admin) {
      return Scaffold(
        appBar: AppBar(title: Text('Role Management')),
        body: Center(
          child: Text('Access Denied: Only Admins can manage roles',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Role Management',
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
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: UserRole.values.map((role) {
            if (role == UserRole.admin) return SizedBox.shrink();

            final permissions =
                userProvider.rolePermissions[role] ?? RolePermissions();

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color:
                  themeProvider.isDarkTheme ? Colors.grey[900] : Colors.white,
              child: ExpansionTile(
                iconColor:
                    themeProvider.isDarkTheme ? Colors.white70 : Colors.black87,
                collapsedIconColor:
                    themeProvider.isDarkTheme ? Colors.white70 : Colors.black87,
                title: Text(
                  'Role: ${role.name.toUpperCase()}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        themeProvider.isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
                children: [
                  _buildPermissionToggle(
                    context: context,
                    userProvider: userProvider,
                    role: role,
                    permissionName: 'Can Access Sales',
                    currentValue: permissions.canAccessSales,
                    icon: Icons.point_of_sale,
                    onChanged: (value) {
                      userProvider.updateRolePermissions(
                        role,
                        permissions.copyWith(canAccessSales: value),
                      );
                    },
                  ),
                  _buildPermissionToggle(
                    context: context,
                    userProvider: userProvider,
                    role: role,
                    permissionName: 'Can Access Product Management',
                    currentValue: permissions.canAccessProductManagement,
                    icon: Icons.inventory,
                    onChanged: (value) {
                      userProvider.updateRolePermissions(
                        role,
                        permissions.copyWith(canAccessProductManagement: value),
                      );
                    },
                  ),
                  _buildPermissionToggle(
                    context: context,
                    userProvider: userProvider,
                    role: role,
                    permissionName: 'Can Access Promotion Management',
                    currentValue: permissions.canAccessPromotionManagement,
                    icon: Icons.local_offer,
                    onChanged: (value) {
                      userProvider.updateRolePermissions(
                        role,
                        permissions.copyWith(
                            canAccessPromotionManagement: value),
                      );
                    },
                  ),
                  _buildPermissionToggle(
                    context: context,
                    userProvider: userProvider,
                    role: role,
                    permissionName: 'Can Access Customer Management',
                    currentValue: permissions.canAccessCustomerManagement,
                    icon: Icons.people,
                    onChanged: (value) {
                      userProvider.updateRolePermissions(
                        role,
                        permissions.copyWith(
                            canAccessCustomerManagement: value),
                      );
                    },
                  ),
                  _buildPermissionToggle(
                    context: context,
                    userProvider: userProvider,
                    role: role,
                    permissionName: 'Can Access Reports',
                    currentValue: permissions.canAccessReports,
                    icon: Icons.report,
                    onChanged: (value) {
                      userProvider.updateRolePermissions(
                        role,
                        permissions.copyWith(canAccessReports: value),
                      );
                    },
                  ),
                  _buildPermissionToggle(
                    context: context,
                    userProvider: userProvider,
                    role: role,
                    permissionName: 'Can Access Settings',
                    currentValue: permissions.canAccessSettings,
                    icon: Icons.settings,
                    onChanged: (value) {
                      userProvider.updateRolePermissions(
                        role,
                        permissions.copyWith(canAccessSettings: value),
                      );
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPermissionToggle({
    required BuildContext context,
    required UserProvider userProvider,
    required UserRole role,
    required String permissionName,
    required bool currentValue,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SwitchListTile(
      title: Row(
        children: [
          Icon(icon,
              color: themeProvider.isDarkTheme
                  ? Colors.white70
                  : Colors.deepPurpleAccent),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              permissionName,
              style: TextStyle(
                color:
                    themeProvider.isDarkTheme ? Colors.white70 : Colors.black,
              ),
            ),
          ),
        ],
      ),
      value: currentValue,
      onChanged: onChanged,
      activeColor: Colors.deepPurpleAccent,
    );
  }
}
