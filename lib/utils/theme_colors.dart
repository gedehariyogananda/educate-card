import 'package:flutter/material.dart';

class ThemeColors {
  // Base colors
  static const Color baseColor = Color.fromARGB(255, 255, 124, 167);
  static const Color primaryLight = Color.fromARGB(255, 255, 156, 189);
  static const Color primaryDark = Color.fromARGB(255, 230, 92, 135);

  // Alert dialog colors
  static const Color alertGradientStart = Color.fromARGB(255, 255, 124, 167);
  static const Color alertGradientEnd = Color.fromARGB(255, 255, 156, 189);

  // Success colors
  static const Color successGradientStart = Color.fromARGB(255, 255, 156, 189);
  static const Color successGradientEnd = Color.fromARGB(255, 255, 187, 210);

  // Completion colors
  static const Color completionGradientStart = Color.fromARGB(
    255,
    230,
    92,
    135,
  );
  static const Color completionGradientEnd = Color.fromARGB(255, 255, 124, 167);

  // Text colors
  static const Color textPrimary = Color.fromARGB(255, 102, 51, 153);
  static const Color textSecondary = Color.fromARGB(255, 128, 128, 128);
  static const Color textLight = Color.fromARGB(255, 96, 96, 96);
  static const Color textSuccess = Color.fromARGB(255, 46, 125, 50);

  // Icon colors
  static const Color iconGold = Color.fromARGB(255, 255, 193, 7);
  static const Color iconPrimary = Color.fromARGB(255, 255, 124, 167);
  static const Color iconSuccess = Color.fromARGB(255, 76, 175, 80);

  // Button colors
  static const Color buttonPrimary = Color.fromARGB(255, 255, 124, 167);
  static const Color buttonSecondary = Color.fromARGB(255, 158, 158, 158);

  // Card colors array - based on primary theme but with variations
  static const List<Color> cardColors = [
    Color.fromARGB(255, 255, 124, 167), // primary pink
    Color.fromARGB(255, 255, 156, 189), // light pink
    Color.fromARGB(255, 230, 92, 135), // dark pink
    Color.fromARGB(255, 255, 138, 101), // coral
    Color.fromARGB(255, 255, 183, 77), // peach
    Color.fromARGB(255, 186, 104, 200), // purple
    Color.fromARGB(255, 149, 117, 205), // lavender
    Color.fromARGB(255, 129, 199, 132), // light green
    Color.fromARGB(255, 100, 181, 246), // light blue
    Color.fromARGB(255, 255, 171, 145), // light orange
  ];
}
