import 'package:flutter/material.dart';

class SarkoobTheme {
  static const Color background = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF12121A);
  static const Color surfaceVariant = Color(0xFF1A1A26);
  static const Color primary = Color(0xFFB8860B);
  static const Color primaryLight = Color(0xFFD4A017);
  static const Color accent = Color(0xFF8B0000);
  static const Color accentLight = Color(0xFFCC2222);
  static const Color textPrimary = Color(0xFFEEEEEE);
  static const Color textSecondary = Color(0xFF999999);
  static const Color textMuted = Color(0xFF555555);
  static const Color border = Color(0xFF2A2A3A);
  static const Color cardBg = Color(0xFF161622);

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0A0A0F), Color(0xFF12121A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      fontFamily: 'Vazirmatn',
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: surface,
        error: accentLight,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn'),
        displayMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn'),
        titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn'),
        titleMedium: TextStyle(color: textPrimary, fontFamily: 'Vazirmatn'),
        bodyLarge: TextStyle(color: textPrimary, fontFamily: 'Vazirmatn'),
        bodyMedium: TextStyle(color: textSecondary, fontFamily: 'Vazirmatn'),
        labelLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn'),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: primary, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn',
        ),
        iconTheme: IconThemeData(color: primary),
      ),
      cardTheme: CardTheme(
        color: cardBg,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.black,
          elevation: 8,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn'),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary, fontFamily: 'Vazirmatn'),
        hintStyle: const TextStyle(color: textMuted, fontFamily: 'Vazirmatn'),
      ),
    );
  }
}
