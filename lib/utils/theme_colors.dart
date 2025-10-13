import 'package:flutter/material.dart';

class ThemeColors {
  // Base colors
  static const Color baseColor = Color.fromARGB(255, 63, 81, 181); // Indigo
  static const Color primaryLight = Color.fromARGB(
    255,
    92,
    107,
    192,
  ); // Light Indigo
  static const Color primaryDark = Color.fromARGB(
    255,
    48,
    63,
    159,
  ); // Dark Indigo

  // Alert dialog colors
  static const Color alertGradientStart = Color.fromARGB(255, 63, 81, 181);
  static const Color alertGradientEnd = Color.fromARGB(255, 92, 107, 192);

  // Success colors
  static const Color successGradientStart = Color.fromARGB(255, 92, 107, 192);
  static const Color successGradientEnd = Color.fromARGB(255, 121, 134, 203);

  // Completion colors
  static const Color completionGradientStart = Color.fromARGB(255, 48, 63, 159);
  static const Color completionGradientEnd = Color.fromARGB(255, 63, 81, 181);

  // Text colors
  static const Color textPrimary = Color.fromARGB(
    255,
    26,
    35,
    126,
  ); // Deep Indigo for text
  static const Color textSecondary = Color.fromARGB(255, 128, 128, 128);
  static const Color textLight = Color.fromARGB(255, 96, 96, 96);
  static const Color textSuccess = Color.fromARGB(255, 46, 125, 50);

  // Icon colors
  static const Color iconGold = Color.fromARGB(255, 255, 193, 7);
  static const Color iconPrimary = Color.fromARGB(255, 63, 81, 181); // Indigo
  static const Color iconSuccess = Color.fromARGB(255, 76, 175, 80);

  // Button colors
  static const Color buttonPrimary = Color.fromARGB(255, 63, 81, 181); // Indigo
  static const Color buttonSecondary = Color.fromARGB(255, 158, 158, 158);

  // Card colors array - based on primary theme but with variations
  static const List<Color> cardColors = [
    Color.fromARGB(255, 63, 81, 181), // primary indigo
    Color.fromARGB(255, 92, 107, 192), // light indigo
    Color.fromARGB(255, 48, 63, 159), // dark indigo
    Color.fromARGB(255, 83, 109, 254), // bright blue
    Color.fromARGB(255, 41, 98, 255), // royal blue
    Color.fromARGB(255, 94, 53, 177), // deep purple
    Color.fromARGB(255, 103, 58, 183), // violet
    Color.fromARGB(255, 129, 199, 132), // light green
    Color.fromARGB(255, 100, 181, 246), // light blue
    Color.fromARGB(255, 33, 150, 243), // sky blue
  ];
}
