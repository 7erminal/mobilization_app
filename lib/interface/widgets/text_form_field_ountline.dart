import 'package:flutter/material.dart';
import 'package:mobilization_app/core/index.dart';

Widget buildOutlineTextField({
  required TextEditingController controller,
  required String labelText,
  required IconData prefixIcon,
  TextInputType keyboardType = TextInputType.text,
  String? Function(String?)? validator,
  FocusNode? focusNode,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: BoxBorder.all(
        color: BrandColors.grey,
        width: 0.5
      )
    ),
    child: TextFormField(
      focusNode: focusNode,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon, color: Color(0xFF1F7A55)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: validator,
    ),
  );
}
