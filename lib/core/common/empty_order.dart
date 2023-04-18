import 'package:ecommerce_app/core/common/big_text.dart';
import 'package:ecommerce_app/core/common/click_button.dart';

import 'package:ecommerce_app/core/common/small_text.dart';
import 'package:ecommerce_app/core/services.dart';
import 'package:ecommerce_app/core/utils/colors.dart';
import 'package:ecommerce_app/features/home/controller/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class EmptyOrder extends StatelessWidget {
  final String title;
  final String desc1;
  final String desc2;
  final String button;
  const EmptyOrder({
    super.key,
    this.button = 'Start Shopping',
    this.title = 'No Order Yet',
    this.desc1 = 'Browse product and start order.',
    this.desc2 = 'Delivery fee is free for your first order!',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            IconlyLight.document,
            color: AppColors.smallTextColor,
            size: 50,
          ),
          BigText(
            text: title,
            color: Colors.black,
            size: 18,
          ),
          const SizedBox(
            height: 5,
          ),
          SmallText(
            text: desc1,
            size: 14,
          ),
          SmallText(
            text: desc2,
            size: 14,
          ),
          const SizedBox(
            height: 20,
          ),
          if (desc2.isNotEmpty)
            GestureDetector(
              onTap: () {
                sl<HomeCubit>().changeIndex(0);
              },
              child: ClickButton(
                radius: 10,
                sizeWidth: MediaQuery.of(context).size.width * 0.60,
                text: button,
              ),
            )
        ],
      ),
    );
  }
}
