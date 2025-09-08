import 'package:flutter/material.dart';

class CustomTextStyles {
  // Heading style
  static TextStyle heading({Color color = Colors.black, double fontSize = 24}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
      fontFamily: "Helvetica",
    );
  }

  // Subheading style
  static TextStyle subheading({
    Color color = Colors.black,
    double fontSize = 17,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: color,
      fontFamily: "Helvetica",
    );
  }

  // Normal text style
  static TextStyle normal({Color color = Colors.black, double fontSize = 14}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      color: color,
      fontFamily: "Helvetica",
    );
  }

  static TextStyle hint({
    Color color = const Color(0xFF828282),
    double fontSize = 12,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      color: color,
      fontFamily: "Helvetica",
    );
  }
}
