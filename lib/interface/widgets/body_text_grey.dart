import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';

class BodyTextGrey extends StatelessWidget {
  final String text;
  FontWeight? fontWeight;
  BodyTextGrey({
    required this.text,
    this.fontWeight = BrandValues.bodyTextFontWeightLight,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return CustomText(text: text, fontSize: BrandValues.defaultFontSize, textColor: BrandColors.grey, fontWeight: fontWeight);
  }
}
