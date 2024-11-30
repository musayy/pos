import 'package:flutter/material.dart';

class DarkTheme {
  static ThemeData get themeData => ThemeData(
        primaryColor: Colors.grey[850],
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.tealAccent),
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          color: Colors.grey[900],
          elevation: 4.0,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.teal,
          textTheme: ButtonTextTheme.primary,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
          titleLarge: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 14.0, color: Colors.white70),
        ),
      );
}
