import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light({required bool isArabic}) {
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5));

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: const AppBarTheme(centerTitle: true),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );

    final textTheme = base.textTheme.apply(
      fontFamily: isArabic ? 'Cairo' : null,
      fontFamilyFallback: const ['Cairo'],
    );

    final primaryTextTheme = base.primaryTextTheme.apply(
      fontFamily: isArabic ? 'Cairo' : null,
      fontFamilyFallback: const ['Cairo'],
    );

    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: primaryTextTheme,
    );
  }

  static ThemeData dark({required bool isArabic}) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF4F46E5),
      brightness: Brightness.dark,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: const AppBarTheme(centerTitle: true),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    );

    final textTheme = base.textTheme.apply(
      fontFamily: isArabic ? 'Cairo' : null,
      fontFamilyFallback: const ['Cairo'],
    );

    final primaryTextTheme = base.primaryTextTheme.apply(
      fontFamily: isArabic ? 'Cairo' : null,
      fontFamilyFallback: const ['Cairo'],
    );

    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: primaryTextTheme,
    );
  }
}
