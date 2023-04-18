import 'package:ecommerce_app/core/common/big_text.dart';
import 'package:ecommerce_app/core/common/click_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:routemaster/routemaster.dart';

class PaymentAlert extends StatelessWidget {
  final String text;
  const PaymentAlert({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Icon(
            IconlyLight.send,
            size: MediaQuery.of(context).size.width / 6,
          ),
          const SizedBox(
            height: 20,
          ),
          BigText(
            text: text,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              if (text == 'Payment Successfully') {
                Routemaster.of(context).popUntil(
                  (routeData) => routeData.path == '/',
                );
              } else {
                Routemaster.of(context).pop();
              }
            },
            child: ClickButton(
              text: 'Continue',
              sizeWidth: MediaQuery.of(context).size.width / 3,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
