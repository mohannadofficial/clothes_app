import 'package:ecommerce_app/core/common/big_text.dart';
import 'package:ecommerce_app/core/common/click_button.dart';
import 'package:ecommerce_app/core/common/icon_button.dart';
import 'package:ecommerce_app/core/common/loader.dart';
import 'package:ecommerce_app/core/common/small_text.dart';
import 'package:ecommerce_app/core/services.dart';
import 'package:ecommerce_app/core/utils/colors.dart';
import 'package:ecommerce_app/features/home/controller/home_cubit.dart';
import 'package:ecommerce_app/features/home/controller/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:routemaster/routemaster.dart';

class CartDetails extends StatelessWidget {
  const CartDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.productsModelScreen != null) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: AppColors.backGroundColor,
              elevation: 0,
              centerTitle: true,
              leading: IconButtonWidget(
                icon: IconlyLight.arrowLeft,
                color: AppColors.smallTextColor,
                function: () {
                  Routemaster.of(context).pop();
                },
              ),
              title: const BigText(
                text: 'Detail Product',
                size: 18,
              ),
              actions: [
                Center(
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.whiteColor,
                    ),
                    child: IconButton(
                      icon: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Column(
                            children: [
                              const SizedBox(
                                height: 4,
                              ),
                              if (state.productCartModel.isNotEmpty)
                                const CircleAvatar(
                                  backgroundColor: AppColors.iconColor,
                                  radius: 3,
                                ),
                            ],
                          ),
                          const Icon(
                            IconlyLight.bag,
                            color: AppColors.smallTextColor,
                          ),
                        ],
                      ),
                      onPressed: () => Routemaster.of(context).push(
                        '/product/order/f',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    leading: Container(),
                    automaticallyImplyLeading: true,
                    pinned: true,
                    expandedHeight: 300,
                    floating: true,
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: AppColors.backGroundColor,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.network(
                        state.productsModelScreen!.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsetsDirectional.only(
                        start: 12,
                        end: 12,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          BigText(
                            text: state.productsModelScreen!.title,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButtonWidget(
                                icon: Icons.remove,
                                colorBackground: Colors.grey[300]!,
                                color: Colors.black,
                                radius: 10,
                                size: 35,
                                sizeIcon: 20,
                                function: () {
                                  sl<HomeCubit>().cartItemNumber(
                                    num: sl<HomeCubit>().state.numCartItem,
                                    isPlus: false,
                                  );
                                },
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              BigText(
                                text: sl<HomeCubit>()
                                    .state
                                    .numCartItem
                                    .toString(),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              IconButtonWidget(
                                icon: Icons.add,
                                color: AppColors.whiteColor,
                                colorBackground: AppColors.iconColor,
                                radius: 10,
                                size: 35,
                                sizeIcon: 20,
                                function: () {
                                  sl<HomeCubit>().cartItemNumber(
                                    num: sl<HomeCubit>().state.numCartItem,
                                  );
                                },
                              ),
                            ],
                          ),
                          const BigText(
                            text: 'Description',
                            size: 18,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SmallText(
                            text: state.productsModelScreen!.description,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 100,
              decoration: const BoxDecoration(
                color: Color(
                  0xff323232,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      const SmallText(
                        text: 'Price',
                        color: Color(0xfff4f4f4),
                      ),
                      BigText(
                        text:
                            '\$${(state.productsModelScreen!.price * state.numCartItem).toDouble()}',
                        color: const Color(0xffffffff),
                      )
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      sl<HomeCubit>().addToCart(state.productsModelScreen!
                          .copyWith(
                              price: state.productsModelScreen!.price *
                                  state.numCartItem));
                    },
                    child: const ClickButton(
                      text: 'Order Now',
                      sizeWidth: 50 * 3.5,
                    ),
                  )
                ],
              ),
            ),
          );
        }
        return const Loader();
      },
    );
  }
}
