import 'package:flutter/material.dart';

enum AppThemeMode { light, dark, original }

class AppTheme {
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFFFFC107), 
      scaffoldBackgroundColor: const Color(0xFFF9F9F9), 
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF141414), fontWeight: FontWeight.bold), 
        bodyMedium: TextStyle(color: Color(0xFF555555)), // Used for muted/secondary text
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFFFC107),
        surface: Color(0xFFF9F9F9),
        onSurface: Color(0xFF1E1E1E),
        shadow: Color(0xFFF0F0F0), 
      ),
    );
  }

  // Dark Theme 
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFFFFC107), 
      scaffoldBackgroundColor: const Color(0xFF0F0F0F), 
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFE5E5E5)), 
        bodyMedium: TextStyle(color: Color(0xFF9E9E9E)), // Soft gray for dark background
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFFFC107),
        surface: Color(0xFF0F0F0F),
        onSurface: Color(0xFFE5E5E5),
        shadow: Color(0xFF1A1A1A), 
      ),
    );
  }

  // Original Theme 
  static ThemeData get originalTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF00ADB5), 
      scaffoldBackgroundColor: const Color(0xFF112240), 
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFF4F6F9)), 
        bodyMedium: TextStyle(color: Color(0xFF8892B0)), // Steel-toned secondary text
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF00ADB5),
        surface: Color(0xFF112240),
        onSurface: Color(0xFFF4F6F9),
        shadow: Color(0xFF1D3557), 
      ),
    );
  }
}

extension CustomThemeColors on ThemeData {
  Color get primaryColorRef => primaryColor;
  Color get backgroundColorRef => scaffoldBackgroundColor;
  Color get textColorRef => textTheme.bodyLarge?.color ?? Colors.black;
  Color get dimColorRef => colorScheme.shadow; 
  Color get mutedTextColorRef => textTheme.bodyMedium?.color ?? Colors.grey;
}