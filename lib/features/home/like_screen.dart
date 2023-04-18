import 'package:ecommerce_app/core/common/big_text.dart';
import 'package:ecommerce_app/core/common/box_item.dart';
import 'package:ecommerce_app/core/common/empty_order.dart';
import 'package:ecommerce_app/core/common/icon_button.dart';
import 'package:ecommerce_app/core/services.dart';
import 'package:ecommerce_app/features/home/controller/home_cubit.dart';
import 'package:ecommerce_app/features/home/controller/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class LikeScreen extends StatelessWidget {
  const LikeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: const BigText(
              text: 'My Favourite',
            ),
            actions: [
              if (state.like.isNotEmpty)
                IconButtonWidget(
                  icon: IconlyLight.delete,
                  function: () => sl<HomeCubit>().deletelike(),
                ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
          body: state.like.isEmpty
              ? const EmptyOrder(
                  title: 'No Favourite Product yet',
                  button: 'Add Product',
                  desc1: 'Browse product and add your favourite',
                  desc2: '',
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: state.likeProductModel.length,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: width / (height / 1)),
                          itemBuilder: (
                            BuildContext context,
                            int index,
                          ) {
                            final likeproductModel =
                                state.likeProductModel[index];
                            return BoxItemWidget(
                              isLike: true,
                              productModel: likeproductModel,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
