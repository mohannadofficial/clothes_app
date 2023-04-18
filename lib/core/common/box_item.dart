import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/core/common/big_text.dart';
import 'package:ecommerce_app/core/common/small_text.dart';
import 'package:ecommerce_app/core/network/local/cache_helper.dart';
import 'package:ecommerce_app/core/services.dart';
import 'package:ecommerce_app/core/utils/colors.dart';
import 'package:ecommerce_app/features/auth/controller/auth_cubit.dart';
import 'package:ecommerce_app/features/home/controller/home_cubit.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class BoxItemWidget extends StatelessWidget {
  final ProductModel productModel;
  final bool isLike;
  const BoxItemWidget(
      {super.key, required this.productModel, required this.isLike});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 10, top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.whiteColor,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(IconlyLight.buy),
              const Spacer(),
              IconButton(
                icon: Icon(
                  isLike ? Icons.favorite : Icons.favorite_outline,
                ),
                onPressed: () {
                  final user = sl<AuthCubit>().state.userModel;
                  sl<HomeCubit>().likeManage(productModel);
                  CacheHelper.setData(
                      key: '${user!.userId}like',
                      value: sl<HomeCubit>().state.like);
                },
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              sl<HomeCubit>().loadProductCart(
                  productModel: productModel, context: context);
            },
            child: CachedNetworkImage(
              imageUrl: productModel.image,
              fit: BoxFit.cover,
              height: 150,
              width: double.infinity,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 20,
            width: 80,
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 16,
                offset: Offset(1, 0),
              )
            ]),
          ),
          const SizedBox(
            height: 10,
          ),
          BigText(
            text: productModel.title,
            size: 16,
          ),
          const SizedBox(
            height: 10,
          ),
          SmallText(
            text: '\$ ${productModel.price}',
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
