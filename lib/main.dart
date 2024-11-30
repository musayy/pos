import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:supermarket_pos/screens/home_screen.dart';
import 'package:supermarket_pos/screens/login_screen.dart';
import 'package:supermarket_pos/screens/product_management_screen.dart';
import 'package:supermarket_pos/screens/promotion_management_screen.dart';
import 'package:supermarket_pos/screens/reports_screen.dart';
import 'package:supermarket_pos/screens/sales_screen.dart';
import 'package:supermarket_pos/screens/settings_screen.dart';
import 'package:supermarket_pos/screens/customer_management_screen.dart';
import 'package:supermarket_pos/screens/role_management_screen.dart';
import 'package:supermarket_pos/state_management/product_provider.dart';
import 'package:supermarket_pos/state_management/sales_provider.dart';
import 'package:supermarket_pos/state_management/theme_provider.dart';
import 'package:supermarket_pos/state_management/user_provider.dart';
import 'package:supermarket_pos/state_management/customer_provider.dart';

void main() {
  if (isDesktopPlatform()) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(SupermarketPOSApp());
}

bool isDesktopPlatform() {
  return [
    TargetPlatform.windows,
    TargetPlatform.macOS,
    TargetPlatform.linux,
  ].contains(defaultTargetPlatform);
}

class SupermarketPOSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => SalesProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Supermarket POS',
            theme: themeProvider.currentTheme,
            locale: Locale(
              themeProvider.currentLanguage == 'Urdu' ? 'ur' : 'en',
            ),
            supportedLocales: [
              Locale('en', ''),
              Locale('ur', ''),
            ],
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              if (themeProvider.currentLanguage == 'Urdu') {
                return Locale('ur', '');
              }
              return Locale('en', '');
            },
            initialRoute: '/',
            routes: {
              '/': (context) => HomeScreen(),
              '/login': (context) => LoginScreen(),
              '/sales': (context) => SalesScreen(),
              '/products': (context) => ProductManagementScreen(),
              '/promotions': (context) => PromotionManagementScreen(),
              '/reports': (context) => ReportsScreen(),
              '/settings': (context) => SettingsScreen(),
              '/roleManagement': (context) => RoleManagementScreen(),
              '/customers': (context) => CustomerManagementScreen(),
            },
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
