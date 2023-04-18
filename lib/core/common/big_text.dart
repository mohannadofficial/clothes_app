import 'package:ecommerce_app/core/utils/colors.dart';
import 'package:flutter/material.dart';

class BigText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  const BigText(
      {super.key,
      required this.text,
      this.size = 24,
      this.color = AppColors.bigTextColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: size,
        height: 1.5,
        color: color,
        fontWeight: FontWeight.w700,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
