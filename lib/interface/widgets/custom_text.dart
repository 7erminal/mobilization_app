import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  FontWeight? fontWeight;
  TextAlign? textAlign;

  CustomText({
    required this.text,
    required this.fontSize,
    required this.textColor,
    this.fontWeight,
    this.textAlign,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.abel(
        fontSize: fontSize,
        color: textColor,
        fontWeight: fontWeight ?? FontWeight.normal,
        letterSpacing: -0.8
      ),
      textAlign: textAlign,
    );
  }
}
