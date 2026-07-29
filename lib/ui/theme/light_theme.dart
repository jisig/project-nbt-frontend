import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF355d73), // Button color
    secondary: Color(0xFF7a8d99), // "Hello" / Primary text
    tertiary: Color(0xFFa2b1b9), // Subtitles / "By signing up..."
    surface: Color(0xFFf7f5f2), // Subtitles / "By signing up..."
      onSurface: Color(0xFF2b3640), // Labels ("Mobile", "Password")
    inversePrimary: Color(0xFF2b3640),
    onInverseSurface: Color(0xFFffffff),
    error: Color(0xFFC65D5D),
    inverseSurface: Color(0xFF4E937A)
  ),
);