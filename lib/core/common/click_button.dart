import 'package:ecommerce_app/core/utils/colors.dart';
import 'package:flutter/material.dart';

class ClickButton extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final double radius;
  final String text;
  final double fontSize;
  final double sizeWidth;
  final double sizeHeight;
  const ClickButton(
      {super.key,
      required this.text,
      this.backgroundColor = AppColors.iconColor,
      this.textColor = AppColors.whiteColor,
      this.radius = 20,
      this.fontSize = 18,
      this.sizeWidth = 50,
      this.sizeHeight = 50});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sizeHeight,
      width: sizeWidth,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
