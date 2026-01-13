import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color ink = Color(0xFF21313C);
  static const Color mist = Color(0xFFF6F2EC);
  static const Color sage = Color(0xFF5A8A78);
  static const Color clay = Color(0xFFD9C3A6);
  static const Color blush = Color(0xFFE9D7C8);
  static const Color night = Color(0xFF1C252B);
  static const Color deep = Color(0xFF10161A);

  static ThemeData build() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: sage,
      surface: mist,
      primary: sage,
      secondary: clay,
      onPrimary: Colors.white,
      onSecondary: ink,
      onSurface: ink,
      onSurfaceVariant: ink.withValues(alpha: 0.7),
    );

    final textTheme = _textTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: mist,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: mist,
        foregroundColor: ink,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: ink),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: Colors.white,
        margin: EdgeInsets.zero,
      ).copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: sage,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          side: BorderSide(color: ink.withValues(alpha: 0.2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ink.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ink.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: sage, width: 1.2),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: sage,
        unselectedItemColor: ink.withValues(alpha: 0.5),
        selectedLabelStyle: textTheme.labelLarge,
        unselectedLabelStyle: textTheme.labelLarge,
        elevation: 0,
      ),
      dividerTheme: DividerThemeData(
        color: ink.withValues(alpha: 0.1),
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData buildDark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: sage,
      brightness: Brightness.dark,
      surface: night,
      primary: sage,
      secondary: clay,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white,
      onSurfaceVariant: Colors.white.withValues(alpha: 0.7),
    );

    final textTheme = _textTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      scaffoldBackgroundColor: deep,
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: deep,
        foregroundColor: Colors.white,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: night,
        margin: EdgeInsets.zero,
      ).copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: sage,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: night,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: sage, width: 1.2),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: night,
        selectedItemColor: sage,
        unselectedItemColor: Colors.white.withValues(alpha: 0.6),
        selectedLabelStyle: textTheme.labelLarge,
        unselectedLabelStyle: textTheme.labelLarge,
        elevation: 0,
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha: 0.1),
        thickness: 1,
        space: 1,
      ),
    );
  }

  static TextTheme _textTheme() {
    final base = GoogleFonts.manropeTextTheme();
    return base.copyWith(
      titleLarge: GoogleFonts.manrope(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      titleMedium: GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
      ),
      bodyLarge: GoogleFonts.manrope(fontSize: 16, height: 1.4),
      bodyMedium: GoogleFonts.manrope(fontSize: 14, height: 1.4),
      labelLarge: GoogleFonts.manrope(fontWeight: FontWeight.w600),
    );
  }
}
