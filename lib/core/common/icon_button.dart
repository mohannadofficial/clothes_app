import 'package:ecommerce_app/core/utils/colors.dart';
import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double radius;
  final Color colorBackground;
  final VoidCallback? function;
  final double size;
  final double? sizeIcon;
  const IconButtonWidget(
      {super.key,
      required this.icon,
      this.color = AppColors.smallTextColor,
      this.colorBackground = AppColors.whiteColor,
      this.radius = 20,
      this.function,
      this.size = 50,
      this.sizeIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: colorBackground,
      ),
      child: IconButton(
        icon: Center(
          child: Icon(
            icon,
            color: color,
            size: sizeIcon,
          ),
        ),
        onPressed: function,
      ),
    );
  }
}
