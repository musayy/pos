import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supermarket_pos/state_management/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('Settings',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildSettingCard(
                context,
                icon: Icons.dark_mode,
                title: 'Dark Theme',
                trailing: Switch(
                  value: themeProvider.isDarkTheme,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                ),
              ),
              _buildSettingCard(
                context,
                icon: Icons.currency_exchange,
                title: 'Currency Settings',
                subtitle: themeProvider.currentCurrency,
                onTap: () => _showCurrencyDialog(context, themeProvider),
              ),
              _buildSettingCard(
                context,
                icon: Icons.language,
                title: 'Language',
                subtitle: themeProvider.currentLanguage,
                onTap: () => _showLanguageDialog(context, themeProvider),
              ),
              _buildSettingCard(
                context,
                icon: Icons.print,
                title: 'Connect Hardware',
                subtitle: 'Printer, Barcode Scanner, etc.',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Hardware Settings'),
                      content: Text('Hardware configuration coming soon!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: themeProvider.isDarkTheme ? Colors.grey[900] : Colors.white,
      child: ListTile(
        leading: Icon(icon,
            color: themeProvider.isDarkTheme
                ? Colors.white
                : Colors.deepPurpleAccent),
        title: Text(
          title,
          style: TextStyle(
            color: themeProvider.isDarkTheme ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  color: themeProvider.isDarkTheme
                      ? Colors.white70
                      : Colors.black54,
                ),
              )
            : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  void _showCurrencyDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Currency'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: themeProvider.supportedCurrencies.map((currency) {
              return RadioListTile<String>(
                title: Text(currency),
                value: currency,
                groupValue: themeProvider.currentCurrency,
                onChanged: (value) {
                  if (value != null) {
                    themeProvider.changeCurrency(value);
                    Navigator.of(context).pop();
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: themeProvider.supportedLanguages.map((language) {
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: themeProvider.currentLanguage,
                onChanged: (value) {
                  if (value != null) {
                    themeProvider.changeLanguage(value);
                    Navigator.of(context).pop();
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
