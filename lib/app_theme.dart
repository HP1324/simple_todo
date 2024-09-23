import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightMode = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff49a0b6),
      brightness: Brightness.light,
    ),
  );

  static ThemeData darkMode = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff49a0b6),
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: Color(0xff414141)
  );
}
