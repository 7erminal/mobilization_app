import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: BrandColors.primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: CustomText(
        text: text,
        fontSize: 16,
        textColor: BrandColors.white,
      ),
    );
  }
}
