import 'package:ecommerce_app/models/payment_product_model.dart';
import 'package:equatable/equatable.dart';

class PaymentModel extends Equatable {
  final String id;
  final String totalamount;
  final String subamount;
  final String shippingCost;
  final List<PaymentProductModel> product;

  const PaymentModel({
    required this.id,
    required this.product,
    required this.shippingCost,
    required this.subamount,
    required this.totalamount,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['related_resources'][0]['sale']['id'],
      product: List<PaymentProductModel>.from(
        json['item_list']['items'].map((e) => PaymentProductModel.fromJson(e)),
      ),
      shippingCost: json['related_resources'][0]['sale']['amount']['details']
          ['shipping'],
      subamount: json['related_resources'][0]['sale']['amount']['details']
          ['subtotal'],
      totalamount: json['related_resources'][0]['sale']['amount']['total'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        product,
        shippingCost,
        subamount,
        totalamount,
      ];
}
