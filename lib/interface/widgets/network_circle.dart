import 'package:flutter/material.dart';
import 'package:mobilization_app/index.dart';

class NetworkCircle extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final ImageProvider<Object> icon;
  final bool isActive;

  NetworkCircle({
    super.key,
    required this.text,
    required this.onTap,
    required this.icon,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isActive
              ? Border.all(
                  color: Colors.green,
                  width: 3,
                )
              : null,
            ),
        padding: const EdgeInsets.all(3),
        child: ClipOval(
          child: Image(
            image: icon,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
      ),
    );
  }
}