import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.light,
      primaryColor: Color.fromARGB(
          255, 64, 112, 118), // Color.fromARGB(255, 68, 116, 116),
      scaffoldBackgroundColor: Colors.white,

      // Define the default font family.
      fontFamily: GoogleFonts.montserrat().fontFamily,

      // Define the default TextTheme.
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 38.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontSize: 36.0,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.0,
        ),
        labelLarge: TextStyle(
          fontSize: 16.0,
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
