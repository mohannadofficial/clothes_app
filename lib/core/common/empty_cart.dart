import 'package:ecommerce_app/core/common/big_text.dart';
import 'package:ecommerce_app/core/common/empty_order.dart';
import 'package:ecommerce_app/core/common/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:routemaster/routemaster.dart';

class EmptyCart extends StatelessWidget {
  final String isHome;
  const EmptyCart({super.key, required this.isHome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              IconButtonWidget(
                icon: IconlyLight.arrowLeft,
                function: () {
                  if (isHome == 't') {
                    Routemaster.of(context).push('/');
                  } else {
                    Routemaster.of(context).pop();
                  }
                },
              ),
            ],
          ),
          title: const BigText(
            text: 'Checkout',
            size: 20,
            color: Color(0xFF000000),
          ),
        ),
        body: const EmptyOrder());
  }
}
