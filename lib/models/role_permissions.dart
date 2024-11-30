class RolePermissions {
  final bool canAccessSales;
  final bool canAccessProductManagement;
  final bool canAccessPromotionManagement;
  final bool canAccessCustomerManagement;
  final bool canAccessReports;
  final bool canAccessSettings;

  RolePermissions({
    this.canAccessSales = false,
    this.canAccessProductManagement = false,
    this.canAccessPromotionManagement = false,
    this.canAccessCustomerManagement = false,
    this.canAccessReports = false,
    this.canAccessSettings = false,
  });

  RolePermissions copyWith({
    bool? canAccessSales,
    bool? canAccessProductManagement,
    bool? canAccessPromotionManagement,
    bool? canAccessCustomerManagement,
    bool? canAccessReports,
    bool? canAccessSettings,
  }) {
    return RolePermissions(
      canAccessSales: canAccessSales ?? this.canAccessSales,
      canAccessProductManagement:
          canAccessProductManagement ?? this.canAccessProductManagement,
      canAccessPromotionManagement:
          canAccessPromotionManagement ?? this.canAccessPromotionManagement,
      canAccessCustomerManagement:
          canAccessCustomerManagement ?? this.canAccessCustomerManagement,
      canAccessReports: canAccessReports ?? this.canAccessReports,
      canAccessSettings: canAccessSettings ?? this.canAccessSettings,
    );
  }
}
