import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _currentTheme;
  bool _isDarkTheme;
  String _currentCurrency;
  String _currentLanguage;

  final List<String> supportedCurrencies = ['USD', 'PKR'];
  final List<String> supportedLanguages = ['English', 'Urdu'];

  ThemeProvider()
      : _isDarkTheme = false,
        _currentTheme = ThemeData.light(),
        _currentCurrency = 'USD',
        _currentLanguage = 'English';

  ThemeData get currentTheme => _currentTheme;
  bool get isDarkTheme => _isDarkTheme;
  String get currentCurrency => _currentCurrency;
  String get currentLanguage => _currentLanguage;

  String get currencySymbol {
    switch (_currentCurrency) {
      case 'PKR':
        return '₨';
      case 'USD':
      default:
        return '\$';
    }
  }

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    _currentTheme = _isDarkTheme ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }

  void changeCurrency(String newCurrency) {
    if (supportedCurrencies.contains(newCurrency)) {
      _currentCurrency = newCurrency;
      notifyListeners();
    }
  }

  void changeLanguage(String newLanguage) {
    if (supportedLanguages.contains(newLanguage)) {
      _currentLanguage = newLanguage;
      notifyListeners();
    }
  }
}
