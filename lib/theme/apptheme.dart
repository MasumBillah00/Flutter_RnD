import 'package:flutter/material.dart';

// Define your custom ThemeData
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      primary: Colors.blueGrey.shade100,
      secondary: Colors.amber,
    ),
    useMaterial3: true,

    // Define the default font family
    fontFamily: 'Roboto',

    // Define the default text theme
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade600,
      ),
      titleMedium: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade700,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16.0,
        color: Colors.black87,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14.0,
        color: Colors.black54,
      ),
    ),

    // Define the default button theme
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.deepPurple,
      textTheme: ButtonTextTheme.primary,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blue.shade700),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 13.0, horizontal: 25.0),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        elevation: MaterialStateProperty.all(5.0),
        textStyle: MaterialStateProperty.all(
          const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),

    // Define the default input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      filled: true,
      fillColor: Colors.blue[50],
    ),

    // Define the default app bar theme
    appBarTheme:  AppBarTheme(
      backgroundColor: Colors.blue.shade700,
      foregroundColor: Colors.white,
      elevation: 4.0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
