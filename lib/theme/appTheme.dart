import 'package:flutter/material.dart';

class AppTheme {
  //Light mode colors
  static const Color lightPrimary = Color.fromARGB(255, 139, 92, 246);
  static const Color lightPrimaryLight = Color.fromARGB(255, 221, 214, 254);
  static const Color lightBackground = Color.fromARGB(255, 255, 255, 255);
  static const Color lightSurface = Color.fromARGB(255, 245, 243, 255);
  static const Color lightOnPrimary = Color.fromARGB(255, 255, 255, 255);
  static const Color lightOnSurface = Color.fromARGB(255, 109, 40, 217);

  //Dark mode colors
  static const Color darkPrimary = Color.fromARGB(255, 236, 72, 153);
  static const Color darkSecondary = Color.fromARGB(255, 139, 92, 246);
  static const Color darkBackground = Color.fromARGB(255, 17, 24, 39);
  static const Color darkSurface = Color.fromARGB(255, 31, 41, 55);
  static const Color darkOnPrimary = Color.fromARGB(255, 255, 255, 255);
  static const Color darkOnSurface = Color.fromARGB(255, 249, 250, 251);

  //Light gradient: soft lavender (left) fading to near-white (right)
  static const LinearGradient lightGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 221, 214, 254),
      Color.fromARGB(255, 245, 243, 255),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  //Dark gradient: pink to purple
  static const LinearGradient darkGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 236, 72, 153),
      Color.fromARGB(255, 139, 92, 246),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: lightPrimary,
      secondary: lightPrimaryLight,
      surface: lightSurface,
      onPrimary: lightOnPrimary,
      onSurface: lightOnSurface,
    ),
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackground,
      foregroundColor: lightOnSurface,
      elevation: 0,
    ),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: darkPrimary,
      secondary: darkSecondary,
      surface: darkSurface,
      onPrimary: darkOnPrimary,
      onSurface: darkOnSurface,
    ),
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: darkOnSurface,
      elevation: 0,
    ),
  );
}
