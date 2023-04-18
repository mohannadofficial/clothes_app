import 'package:ecommerce_app/core/common/big_text.dart';
import 'package:ecommerce_app/core/common/small_text.dart';
import 'package:ecommerce_app/core/utils/colors.dart';
import 'package:ecommerce_app/features/auth/controller/auth_cubit.dart';
import 'package:ecommerce_app/features/auth/controller/auth_state.dart';
import 'package:ecommerce_app/features/home/controller/home_cubit.dart';
import 'package:ecommerce_app/features/home/controller/home_state.dart';
import 'package:ecommerce_app/features/home/search/search_delegete.dart';
import 'package:ecommerce_app/models/category_model.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:routemaster/routemaster.dart';

import '../../core/common/box_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectIndexCat = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SmallText(
                          text: 'Welcome',
                        ),
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return BigText(
                              text: state.userModel!.name,
                            );
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                    BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                      return CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(60, 230, 226, 226),
                        child: IconButton(
                          onPressed: () {
                            if (state.productCartModel.isNotEmpty) {
                              Routemaster.of(context).push('/product/order/t');
                            }
                          },
                          icon: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              if (state.productCartModel.isNotEmpty)
                                const CircleAvatar(
                                  backgroundColor: AppColors.iconColor,
                                  radius: 4,
                                ),
                              const Icon(
                                IconlyLight.bag,
                                color: AppColors.smallTextColor,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showSearch(
                            context: context,
                            delegate: SearchProduct(),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.searchGroundColor,
                          ),
                          child: Row(
                            children: const [
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                IconlyLight.search,
                                color: AppColors.coverTap,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                'Search Clothes or ect...',
                                style: TextStyle(
                                  color: AppColors.coverTap,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.iconColor,
                      ),
                      child: IconButton(
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: SearchProduct(),
                          );
                        },
                        icon: const Icon(
                          IconlyLight.filter,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const BigText(
                  text: 'Clothes Categories',
                  size: 16,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 11.5,
                  child: BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      return ListView.builder(
                          itemCount: state.categoriesModel.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final category = state.categoriesModel[index];
                            return Row(
                              children: [
                                cartCategoriesBuilder(
                                    index: index, category: category),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            );
                          });
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const BigText(
                  text: 'Popular',
                  size: 16,
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    final List<ProductModel> listModelProduct = [];
                    for (var element in state.productsModel) {
                      if (element.categoryId ==
                          state.categoriesModel[selectIndexCat].categoryId) {
                        listModelProduct.add(element);
                      }
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: listModelProduct.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 10,
                          childAspectRatio: width / (height)),
                      itemBuilder: (
                        BuildContext context,
                        int index,
                      ) {
                        final productModel = listModelProduct[index];
                        return BoxItemWidget(
                          isLike: state.like.contains(productModel.productId),
                          productModel: productModel,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget cartCategoriesBuilder({
    required int index,
    required CategoriesModel category,
  }) {
    return Container(
      padding: const EdgeInsetsDirectional.all(5),
      height: MediaQuery.of(context).size.height / 11.5,
      width: MediaQuery.of(context).size.height / 4.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: selectIndexCat == index
            ? AppColors.iconColor
            : AppColors.whiteColor,
      ),
      child: ListTile(
        leading: Icon(
          Icons.shopping_bag_outlined,
          color: selectIndexCat == index
              ? AppColors.whiteColor
              : AppColors.iconColor,
        ),
        title: Text(
          category.title,
          style: TextStyle(
            color: selectIndexCat == index
                ? AppColors.whiteColor
                : AppColors.iconColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: () {
          setState(() {
            selectIndexCat = index;
          });
        },
      ),
    );
  }
}
