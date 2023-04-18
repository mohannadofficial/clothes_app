import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/core/common/big_text.dart';
import 'package:ecommerce_app/core/common/click_button.dart';
import 'package:ecommerce_app/core/common/empty_cart.dart';
import 'package:ecommerce_app/core/common/icon_button.dart';
import 'package:ecommerce_app/core/common/payment_alert.dart';
import 'package:ecommerce_app/core/common/seprater.dart';
import 'package:ecommerce_app/core/common/small_text.dart';
import 'package:ecommerce_app/core/services.dart';
import 'package:ecommerce_app/core/utils/colors.dart';
import 'package:ecommerce_app/features/home/controller/home_cubit.dart';
import 'package:ecommerce_app/features/home/controller/home_state.dart';
import 'package:ecommerce_app/features/payment/controller/payment_cubit.dart';
import 'package:ecommerce_app/features/payment/payment_screen.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:routemaster/routemaster.dart';

class CartOrder extends StatelessWidget {
  final String isHome;
  const CartOrder({super.key, required this.isHome});

  @override
  Widget build(BuildContext context) {
    final cubit = sl<HomeCubit>();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.productCartModel.isNotEmpty) {
          return BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              var subtotal = 0;
              state.productCartModel.forEach(((element) {
                subtotal += element.price;
              }));
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
                  actions: [
                    IconButtonWidget(
                      icon: IconlyLight.delete,
                      function: () => cubit.deleteCart(),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                body: ListView.builder(
                  itemCount: state.productCartModel.length,
                  itemBuilder: (context, index) {
                    var countItem = 1;
                    final productModelCartTemp = state.productCartModel[index];
                    for (var element in state.productsModel) {
                      if (element.productId == productModelCartTemp.productId) {
                        // ~/ mean int value

                        countItem =
                            (productModelCartTemp.price ~/ element.price);
                      }
                    }

                    return checkoutBuilder(
                        width, height, productModelCartTemp, countItem, index);
                  },
                ),
                bottomNavigationBar: Container(
                  height: height / 2.9,
                  padding: const EdgeInsetsDirectional.all(12),
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    color: Color(0xFF323232),
                  ),
                  child: Column(
                    children: [
                      rowBuilderOrder(price: 3.78, text: 'Delivery Fee'),
                      const SizedBox(
                        height: 10,
                      ),
                      rowBuilderOrder(
                          price: subtotal.toDouble(), text: 'Sub Total'),
                      const SizedBox(
                        height: 50,
                      ),
                      const MySeparator(
                        color: AppColors.whiteColor,
                      ),
                      rowBuilderOrder(
                          price: subtotal.toDouble() + 3.78, text: 'Total'),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => PaymentScreen(
                                onFinish: (number) {
                                  if (number != null &&
                                      number['state'] == 'approved') {
                                    sl<PaymentCubit>().paymentSuccess(
                                      number['transactions'][0],
                                    );
                                    showDialog(
                                      builder: (context) {
                                        return AlertDialog(
                                          alignment: Alignment.center,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          content: const PaymentAlert(
                                            text: 'Payment Successfully',
                                          ),
                                        );
                                      },
                                      context: context,
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                          sl<PaymentCubit>().initPayment(context);
                        },
                        child: const ClickButton(
                          text: 'Proceed to Checkout',
                          sizeWidth: double.infinity,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return EmptyCart(
            isHome: isHome,
          );
        }
      },
    );
  }

  Container checkoutBuilder(double width, double height,
      ProductModel productCartModel, int countItem, int index) {
    final cubit = sl<HomeCubit>();
    return Container(
      padding: EdgeInsetsDirectional.only(
          start: width / 35, end: width / 35, top: width / 35),
      height: height / 6,
      child: Card(
        color: AppColors.whiteColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsetsDirectional.only(
                    start: 5,
                    top: 5,
                  ),
                  height: height / 8,
                  width: width / 3.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFFFAFAFA),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        productCartModel.image,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BigText(
                      text: productCartModel.title,
                      size: 16,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SmallText(
                      text:
                          '\$${(productCartModel.price / countItem).toDouble()}',
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: width / 1.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Spacer(),
                          IconButtonWidget(
                            size: 33,
                            sizeIcon: 18,
                            icon: Icons.remove,
                            colorBackground: Colors.grey[300]!,
                            color: Colors.black,
                            radius: 10,
                            function: () {
                              cubit.addToOrder(
                                  index: index,
                                  price: (productCartModel.price ~/ countItem),
                                  countItem: countItem,
                                  isPlus: false);
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          BigText(
                            text: countItem.toString(),
                            size: 18,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          IconButtonWidget(
                            size: 33,
                            sizeIcon: 18,
                            icon: Icons.add,
                            color: AppColors.whiteColor,
                            colorBackground: AppColors.iconColor,
                            radius: 10,
                            function: () {
                              cubit.addToOrder(
                                  index: index,
                                  price: (productCartModel.price ~/ countItem),
                                  countItem: countItem);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget rowBuilderOrder({required String text, required double price}) {
    return Row(
      children: [
        BigText(
          text: text,
          size: 20,
          color: AppColors.backGroundColor,
        ),
        const Spacer(),
        SmallText(
          text: '\$$price',
          color: AppColors.whiteColor,
        ),
      ],
    );
  }
}
