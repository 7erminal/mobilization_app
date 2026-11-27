import 'package:flutter/material.dart';

class BrandColors {
  static get baseColor => const Color(0xffff0009);

  // some custom colors
  static const Color primaryColor = Color(0xFF21A300);
  static const Color primaryColorLight = Color(0xFF6F9963);
  static const Color primaryColorDark = Color(0xFF0E507C);
  static const Color secondaryColor = Color(0xFF6F9963);
  static const Color secondaryColorLight = Color(0xFFA3B5A0);
  static const Color secondaryColorDark = Color(0xFF091B7C);

  static const Color successColor = Color(0xFF118953);
  static const Color pendingColor = Color(0xFFFFC000);
  static const Color failureColor = Color(0xFFFA4100);

  static const Color secondPrimaryColor = Color(0xFFBBC3FB);
  static const Color secondSecondaryColor = Color(0xFFC2C6DA);

  static const Color primaryTextColor = Color(0xFF000000);
  static const Color secondaryTextColor = Color(0xFFFFFFFF);

  static const Color primaryColorDisabled = Color(0xffdd9aff);

  static const Color black = Color(0xff000000);
  static const Color white = Color(0xffFFFFFF);
  static const Color grey = Color(0xff6c6e6e);
  static Color greyOpc = Colors.grey.withOpacity(0.2);
  static const Color lightGrey = Color(0xffE5E9E9);
  static const Color mediumLightGrey = Color(0xffF0F5F5);
  static const Color mediumLightDarkGrey = Color(0xffbfbfbf);

  static const Color warning = Color(0xfff6bd00);
  static const Color warningLight = Color(0xffFCF7E1);

  static const Color danger = Color(0xffec4b4b);
  static const Color dangerLight = Color(0xffFDF1F1);

  static const Color lightPrimaryColor = Color(0xffCEFFC7);
  static const Color extraLightPrimaryColor = Color(0xffe7ffe5);

  static List<Color> primaryGradient = [const Color(0xFFEBF8FF), const Color(0xFFFFDEFC)];
  static List<Color> primaryGradientLight = [const Color(0xFFF7F9FF), const Color(0xFFFFEFFD)];
}