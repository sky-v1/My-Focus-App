import 'package:flutter/material.dart';

/// Light Theme (Default Material 3)
final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
  useMaterial3: true,
);

/// Custom Dark Theme (Black Background)
final ThemeData darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: Brightness.dark, // Ensures it's a dark theme
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.black, // Fully black background
);
