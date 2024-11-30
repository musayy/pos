import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent),
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      color: Colors.blue,
      elevation: 4.0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.blue,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 14.0),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: Colors.grey[900],
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: Colors.tealAccent),
    appBarTheme: AppBarTheme(
      color: Colors.grey[850],
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
