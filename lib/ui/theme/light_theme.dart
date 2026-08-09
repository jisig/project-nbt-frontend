import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF315A70),
    // Button color
    secondary: Color(0xFFDCE7EC),
    // "Hello" / Primary text
    tertiary: Color(0xFFa2b1b9),
    // Subtitles / "By signing up..."
    surface: Color(0xFFF7F5F0),
    // Subtitles / "By signing up..."
    // onSurface: Color(0xFF71838D),
    // Labels ("Mobile", "Password")
    inversePrimary: Color(0xFF26333B),
    onInverseSurface: Color(0xFFffffff),
    error: Color(0xFFC65D5D),
    inverseSurface: Color(0xFF4E937A),
  ),
);
