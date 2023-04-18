import 'package:equatable/equatable.dart';

class PaymentProductModel extends Equatable {
  final String name;
  final String price;
  final int quantity;
  final String image;

  const PaymentProductModel({
    required this.image,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory PaymentProductModel.fromJson(Map<String, dynamic> json) {
    return PaymentProductModel(
      image: json['image_url'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }

  @override
  List<Object?> get props => [
        price,
        image,
        quantity,
        name,
      ];
}
