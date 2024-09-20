import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightMode = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff242b2f),
      brightness: Brightness.light,
    ),
  );

  static ThemeData darkMode = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff1b2c3f),
      brightness: Brightness.dark,
    ),
  );
}
