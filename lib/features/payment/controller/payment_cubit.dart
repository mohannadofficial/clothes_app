import 'dart:convert';

import 'package:ecommerce_app/core/enum.dart';
import 'package:ecommerce_app/core/network/local/cache_helper.dart';
import 'package:ecommerce_app/core/services.dart';
import 'package:ecommerce_app/features/auth/controller/auth_cubit.dart';
import 'package:ecommerce_app/features/home/controller/home_cubit.dart';
import 'package:ecommerce_app/features/payment/controller/payment_states.dart';
import 'package:ecommerce_app/features/payment/repository/payment_repository.dart';
import 'package:ecommerce_app/models/payment_model.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:ecommerce_app/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentCubit extends Cubit<PaymentStates> {
  final PaymentRepository _paymentRepository;
  PaymentCubit({required PaymentRepository paymentRepository})
      : _paymentRepository = paymentRepository,
        super(const PaymentStates());

  //static PaymentCubit get(context) => BlocProvider.of(context);

  String? accessToken;
  List<ProductModel> productModel = [];
  late UserModel userModel;

  //default currency
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.mohannad.com';
  String cancelURL = 'cancel.mohannad.com';

  void initPayment(BuildContext context) async {
    productModel = [];
    sl<HomeCubit>().state.productCartModel.forEach(((element) {
      productModel.add(element);
    }));

    userModel = sl<AuthCubit>().state.userModel!;
    try {
      if (state.checkoutUrl.isNotEmpty) {
        emit(state.copyWith(
            checkoutUrl: '',
            executeUrl: '',
            submissionStatus: SubmissionStatus.idle));
      }
      accessToken ??= (await _paymentRepository.getAccessToken());

      final transactions = getOrderDetails(
          prdocutModelTemp: productModel, userModelTemp: userModel);
      final res = await _paymentRepository.createPaypalPayment(
          transactions, accessToken);

      if (res != null) {
        String checkoutUrl = res["approvalUrl"]!;
        String executeUrl = res["executeUrl"]!;
        emit(state.copyWith(checkoutUrl: checkoutUrl, executeUrl: executeUrl));
      }
    } catch (e) {
      if (kDebugMode) {
        print('exception: $e');
      }
      final snackBar = SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 10),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            // Close
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  int quantity = 1;
  // * Json Data => Get
  Map<String, dynamic> getOrderDetails({
    required List<ProductModel> prdocutModelTemp,
    required UserModel userModelTemp,
  }) {
    List items = [];
    double totalAmountDouble = 0;
    double subTotalAmountDouble = 0;
    // item Add
    prdocutModelTemp.forEach(((element) {
      for (int i = 0; i < sl<HomeCubit>().state.productsModel.length; i++) {
        if (element.productId ==
            sl<HomeCubit>().state.productsModel[i].productId) {
          quantity =
              element.price ~/ sl<HomeCubit>().state.productsModel[i].price;
          break;
        }
      }
      totalAmountDouble += element.price.toDouble();
      subTotalAmountDouble = totalAmountDouble;
      items.add({
        "name": element.title,
        "quantity": quantity,
        "price": '${element.price / quantity}',
        "currency": defaultCurrency["currency"],
        "image_url": element.image,
      });
    }));

    // checkout invoice details
    String totalAmount = '${totalAmountDouble + 3.78}';
    String subTotalAmount = '$subTotalAmountDouble';
    String shippingCost = '3.78';
    int shippingDiscountCost = 0;
    String userFirstName = '';
    String userLastName = '';
    String addressCity = '';
    String addressStreet = '';
    String addressZipCode = '';
    String addressCountry = '';
    String addressState = '';
    String addressPhoneNumber = '';

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "shipping": shippingCost,
              "shipping_discount": ((-1.0) * shippingDiscountCost).toString()
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            if (isEnableShipping && isEnableAddress)
              "shipping_address": {
                "recipient_name": "$userFirstName $userLastName",
                "line1": addressStreet,
                "line2": "",
                "city": addressCity,
                "country_code": addressCountry,
                "postal_code": addressZipCode,
                "phone": addressPhoneNumber,
                "state": addressState
              },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  void getDataPayment() {
    List<PaymentModel> paymentModelListTemp = [];
    final user = sl<AuthCubit>().state.userModel?.userId;
    if (CacheHelper.getData(key: '${user}payment') != null) {
      for (var element
          in (CacheHelper.getData(key: '${user}payment') as List<dynamic>)) {
        paymentModelListTemp.add(PaymentModel.fromJson(jsonDecode(element)));
      }

      emit(state.copyWith(
        paymentModelList: paymentModelListTemp,
        submissionStatus: SubmissionStatus.loaded,
      ));
    }
  }

  void loadingEmit() {
    emit(state.copyWith(submissionStatus: SubmissionStatus.inProgress));
  }

  void paymentSuccess(Map<String, dynamic> json) {
    sl<HomeCubit>().deleteCart();
    final user = sl<AuthCubit>().state.userModel!.userId;
    if (CacheHelper.getData(key: '${user}payment') != null) {
      List<String> paymentOrder = [];
      paymentOrder.add(jsonEncode(json));
      (CacheHelper.getData(key: '${user}payment') as List<dynamic>)
          .forEach(((element) {
        paymentOrder.add(element);
      }));
      CacheHelper.setData(key: '${user}payment', value: paymentOrder);
    } else {
      CacheHelper.setData(key: '${user}payment', value: [jsonEncode(json)]);
    }
    getDataPayment();
  }
}
