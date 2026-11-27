import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mobilization_app/index.dart';

class CorpSquare extends StatefulWidget {
  // final String icon;
  final String label;
  final double? circleSize;
  final Color? circleColor;
  // final Color? iconColor;
  // final double? iconSize;
  final Color? labelColor;
  final Function? onTap;
  final bool isSelected;

  const CorpSquare({
    // required this.icon,
    required this.label,
    this.circleSize = 34.0,
    this.circleColor, // Default color
    // this.iconColor = Colors.white,   // Default color
    // this.iconSize,
    this.labelColor,  // Default color
    this.onTap,
    this.isSelected = false,
    super.key});

  @override
  State<CorpSquare> createState() => _CorpSquareState();
}

class _CorpSquareState extends State<CorpSquare> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        widget.onTap != null ? widget.onTap!() : "";
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: widget.isSelected ? BrandColors.lightPrimaryColor : Colors.transparent,
            border: Border.all(color: widget.isSelected ? BrandColors.primaryColorDisabled : Colors.blueGrey),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Center(
            // child: Iconify(
            //   widget.icon,
            //   color: widget.iconColor ?? BrandColors.black,
            //   size: widget.iconSize ?? 16.0,
            // ),
            child: CustomText(
              text: widget.label,
              fontSize: BrandValues.defaultSmallFontSize,
              textColor: widget.labelColor ?? BrandColors.black,
            ),
          ),
        ),
      ),
    );
  }
}
