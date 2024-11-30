import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supermarket_pos/models/user.dart';
import 'package:supermarket_pos/models/role_permissions.dart';

class UserProvider with ChangeNotifier {
  User? _currentUser;
  List<User> _users = [];

  Map<UserRole, RolePermissions> _rolePermissions = {
    UserRole.cashier: RolePermissions(canAccessSales: true),
    UserRole.manager: RolePermissions(
      canAccessSales: true,
      canAccessProductManagement: true,
      canAccessPromotionManagement: true,
      canAccessCustomerManagement: true,
      canAccessReports: true,
    ),
    UserRole.admin: RolePermissions(
      canAccessSales: true,
      canAccessProductManagement: true,
      canAccessPromotionManagement: true,
      canAccessCustomerManagement: true,
      canAccessReports: true,
      canAccessSettings: true,
    ),
  };

  User? get currentUser => _currentUser;
  List<User> get users => _users;
  Map<UserRole, RolePermissions> get rolePermissions => _rolePermissions;

  UserProvider() {
    _users = [
      User(
          id: 1, username: 'admin', password: 'admin123', role: UserRole.admin),
      User(
          id: 2,
          username: 'manager',
          password: 'manager123',
          role: UserRole.manager),
      User(
          id: 3,
          username: 'cashier',
          password: 'cashier123',
          role: UserRole.cashier),
    ];
    _loadUserFromPreferences();
    _loadRolePermissionsFromPreferences();
  }

  // Method to update role permissions
  void updateRolePermissions(UserRole role, RolePermissions permissions) {
    _rolePermissions[role] = permissions;
    _saveRolePermissionsToPreferences();
    print('Updated permissions for role: ${role.name}');
    print('Permissions: ${_rolePermissions[role]}');
    notifyListeners();
  }

  Future<void> _loadUserFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('username');
      final password = prefs.getString('password');

      if (username != null && password != null) {
        final matchingUsers = _users
            .where((u) => u.username == username && u.password == password)
            .toList();
        if (matchingUsers.isNotEmpty) {
          _currentUser = matchingUsers.first;
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error loading user from preferences: $e');
    }
  }

  Future<void> _saveRolePermissionsToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final rolePermissionsMap = _rolePermissions.map((key, value) => MapEntry(
          key.toString(),
          {
            'canAccessSales': value.canAccessSales,
            'canAccessProductManagement': value.canAccessProductManagement,
            'canAccessPromotionManagement': value.canAccessPromotionManagement,
            'canAccessCustomerManagement': value.canAccessCustomerManagement,
            'canAccessReports': value.canAccessReports,
            'canAccessSettings': value.canAccessSettings,
          },
        ));
    await prefs.setString('rolePermissions', jsonEncode(rolePermissionsMap));
  }

  Future<void> _loadRolePermissionsFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final rolePermissionsString = prefs.getString('rolePermissions');
    if (rolePermissionsString != null) {
      final decodedMap =
          jsonDecode(rolePermissionsString) as Map<String, dynamic>;
      _rolePermissions = decodedMap.map((key, value) => MapEntry(
            _stringToUserRole(key),
            RolePermissions(
              canAccessSales: value['canAccessSales'] ?? false,
              canAccessProductManagement:
                  value['canAccessProductManagement'] ?? false,
              canAccessPromotionManagement:
                  value['canAccessPromotionManagement'] ?? false,
              canAccessCustomerManagement:
                  value['canAccessCustomerManagement'] ?? false,
              canAccessReports: value['canAccessReports'] ?? false,
              canAccessSettings: value['canAccessSettings'] ?? false,
            ),
          ));
      notifyListeners();
    }
  }

  UserRole _stringToUserRole(String roleString) {
    return UserRole.values.firstWhere((role) => role.toString() == roleString,
        orElse: () => UserRole.cashier);
  }

  Future<bool> login(String username, String password) async {
    final matchingUsers = _users
        .where((u) => u.username == username && u.password == password)
        .toList();

    if (matchingUsers.isNotEmpty) {
      _currentUser = matchingUsers.first;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _currentUser!.username);
      await prefs.setString('password', _currentUser!.password);
      notifyListeners();
      return true;
    }
    return false;
  }

  void updateUserRole(User user, UserRole newRole) {
    final index = _users.indexWhere((u) => u.id == user.id);
    if (index != -1) {
      _users[index] = User(
        id: user.id,
        username: user.username,
        password: user.password,
        role: newRole,
      );
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    notifyListeners();
  }
}
