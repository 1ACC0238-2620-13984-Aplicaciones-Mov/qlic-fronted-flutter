import 'package:flutter/material.dart';

const qlicBlue = Color(0xFF0C4AFD);
const qlicTeal = Color(0xFF00BFA5);
const qlicNavy = Color(0xFF05364F);
const qlicSurface = Color(0xFFF5F8FB);

class AppTheme {
  static ThemeData get light => _build(
    ColorScheme.fromSeed(seedColor: qlicBlue).copyWith(
      primary: qlicBlue,
      onPrimary: Colors.white, secondary: qlicTeal,
      surface: Colors.white, onSurface: qlicNavy,
    ),
    qlicSurface,
  );

  static ThemeData get dark => _build(
    ColorScheme.fromSeed(seedColor: qlicBlue, brightness: Brightness.dark),
    null,
  );

  static ThemeData _build(ColorScheme scheme, Color? background) => ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: background,
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
    ),
  );
}