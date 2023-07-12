import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primaryColor:
          Color.fromARGB(255, 40, 40, 43), // Color.fromARGB(255, 68, 116, 116),
      primaryColorLight: Color.fromARGB(20, 40, 40, 43),
      scaffoldBackgroundColor: Colors.white,
      secondaryHeaderColor: Color.fromARGB(255, 29, 212, 206),
      splashColor: Color.fromARGB(255, 29, 212, 206),
      // Define the default font family.
      fontFamily: GoogleFonts.montserrat().fontFamily,

      // Define the default TextTheme.
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 36.0,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          fontSize: 24.0,
        ),
        bodyLarge: TextStyle(
          fontSize: 16.0,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
        ),
        bodySmall: TextStyle(
          fontSize: 12.0,
        ),
        labelLarge: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        labelMedium: TextStyle(
          fontSize: 14.0,
          color: Color.fromARGB(83, 0, 0, 0),
        ),
      ),
    );
  }
}
