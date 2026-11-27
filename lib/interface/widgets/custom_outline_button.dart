import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';

class CustomOutlineButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final Color? textColor;
  const CustomOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        onPressed();
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        side: const BorderSide(color: BrandColors.secondaryColor),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: textColor ?? BrandColors.primaryColor),
      ),
    );
  }
}