import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/core/common/big_text.dart';
import 'package:ecommerce_app/core/common/empty_order.dart';
import 'package:ecommerce_app/core/common/small_text.dart';
import 'package:ecommerce_app/core/utils/colors.dart';
import 'package:ecommerce_app/features/payment/controller/payment_cubit.dart';
import 'package:ecommerce_app/features/payment/controller/payment_states.dart';
import 'package:ecommerce_app/models/payment_model.dart';
import 'package:ecommerce_app/models/payment_product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.3,
            title: const BigText(text: 'Orders'),
            actions: const [
              Icon(
                IconlyLight.document,
                color: AppColors.smallTextColor,
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          body: state.paymentModelList.isEmpty
              ? const EmptyOrder()
              : ListView.builder(
                  itemCount: state.paymentModelList.length,
                  itemBuilder: (context, index) {
                    final paymentData = state.paymentModelList[index];
                    return Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        orderBuilder(state, context, index, paymentData),
                        if (index == state.paymentModelList.length - 1)
                          const SizedBox(
                            height: 20,
                          ),
                      ],
                    );
                  },
                ),
        );
      },
    );
  }

  Widget orderBuilder(PaymentStates state, BuildContext context, int index,
      PaymentModel paymentModel) {
    return Container(
      padding: const EdgeInsetsDirectional.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 1,
            color: AppColors.smallTextColor.withOpacity(0.1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SmallText(
                text: 'Inovice: ${paymentModel.id}',
              ),
              const Spacer(),
              const BigText(
                text: 'Paid',
                color: AppColors.iconColor,
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: paymentModel.product.length,
            itemBuilder: (context, index) {
              final productData = paymentModel.product[index];
              return Column(
                children: [
                  productBuilder(context, productData),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const BigText(
                text: 'Total Amount: ',
                size: 18,
              ),
              BigText(
                text: paymentModel.totalamount,
                size: 18,
                color: AppColors.iconColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget productBuilder(
      BuildContext context, PaymentProductModel paymentProductModel) {
    return SizedBox(
      height: MediaQuery.of(context).size.width / 4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: paymentProductModel.image,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.width / 4,
              width: MediaQuery.of(context).size.width / 4,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: BigText(
                    text: paymentProductModel.name,
                    size: 16,
                  ),
                ),
                BigText(
                  text: DateFormat.yMMMMd().format(DateTime.now()),
                  size: 16,
                ),
              ],
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BigText(
                  text: '\$${paymentProductModel.price}',
                  color: AppColors.iconColor,
                  size: 16,
                ),
                SmallText(
                  text: '${paymentProductModel.quantity}X',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
