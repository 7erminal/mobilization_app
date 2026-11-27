import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';

class BodyHeadingLarge extends StatelessWidget {
  final String text;
  Color? color = BrandColors.black;
  FontWeight? fontWeight = BrandValues.bodyTextFontWeight;
  BodyHeadingLarge({
    required this.text,
    this.color = BrandColors.black,
    this.fontWeight = BrandValues.bodyTextFontWeight,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return CustomText(text: text, fontSize: BrandValues.mediumHeadingFontSize, textColor: color!, fontWeight: fontWeight);
  }
}
