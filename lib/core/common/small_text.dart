import 'package:ecommerce_app/core/utils/colors.dart';
import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  const SmallText(
      {super.key,
      required this.text,
      this.color = AppColors.smallTextColor,
      this.size = 16.0});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Text(
        text,
        style: TextStyle(
          fontSize: size,
          height: 1.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
