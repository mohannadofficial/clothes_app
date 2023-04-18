import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/core/common/big_text.dart';
import 'package:ecommerce_app/core/common/click_button.dart';
import 'package:ecommerce_app/core/common/icon_button.dart';
import 'package:ecommerce_app/core/common/search_dialog.dart';
import 'package:ecommerce_app/core/common/small_text.dart';
import 'package:ecommerce_app/core/services.dart';
import 'package:ecommerce_app/core/utils/colors.dart';
import 'package:ecommerce_app/features/home/controller/home_cubit.dart';
import 'package:ecommerce_app/features/home/controller/home_state.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:routemaster/routemaster.dart';

class SearchProduct extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
        color: AppColors.backGroundColor,
        foregroundColor: AppColors.backGroundColor,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButtonWidget(
        icon: IconlyLight.filter,
        function: () {
          showDialog(
            builder: (context) {
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  title: const BigText(
                    text: 'Search Filter',
                  ),
                  content: const SearchDialog());
            },
            context: context,
          );
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButtonWidget(
      icon: IconlyLight.arrowLeft,
      function: () {
        Routemaster.of(context).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (query.isEmpty) {
            return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Container(
                  color: AppColors.whiteColor,
                ));
          }
          final List<ProductModel> productModelTemp = [];
          if (state.filterCategoryModel.isNotEmpty) {
            state.filterCategoryModel.forEach(((element) {
              state.productsModel.forEach(((elementsub) {
                if (elementsub.title
                        .toUpperCase()
                        .contains(query.toUpperCase()) &&
                    elementsub.categoryId == element) {
                  productModelTemp.add(elementsub);
                }
              }));
            }));
          } else {
            state.productsModel.forEach(((element) {
              if (element.title.toUpperCase().contains(query.toUpperCase())) {
                productModelTemp.add(element);
              }
            }));
          }

          return ListView.builder(
            itemCount: productModelTemp.length,
            itemBuilder: (context, index) {
              return checkoutBuilder(
                  width, height, productModelTemp[index], index, context);
            },
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (query.isEmpty) {
            return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Container(
                  color: AppColors.whiteColor,
                ));
          }
          final List<ProductModel> productModelTemp = [];
          if (state.filterCategoryModel.isNotEmpty) {
            state.filterCategoryModel.forEach(((element) {
              state.productsModel.forEach(((elementsub) {
                if (elementsub.title
                        .toUpperCase()
                        .contains(query.toUpperCase()) &&
                    elementsub.categoryId == element) {
                  productModelTemp.add(elementsub);
                }
              }));
            }));
          } else {
            state.productsModel.forEach(((element) {
              if (element.title.toUpperCase().contains(query.toUpperCase())) {
                productModelTemp.add(element);
              }
            }));
          }
          return ListView.builder(
            itemCount: productModelTemp.length,
            itemBuilder: (context, index) {
              return checkoutBuilder(
                  width, height, productModelTemp[index], index, context);
            },
          );
        },
      ),
    );
  }

  Container checkoutBuilder(double width, double height,
      ProductModel productCartModel, int index, BuildContext context) {
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
                      text: productCartModel.price.toString(),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: width / 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => sl<HomeCubit>().loadProductCart(
                                productModel: productCartModel,
                                context: context),
                            child: ClickButton(
                              text: 'Details',
                              sizeWidth: width / 5,
                              sizeHeight: width / 14,
                              radius: 10,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
