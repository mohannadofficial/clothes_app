import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String productId;
  final String categoryId;
  final String title;
  final String description;
  final int price;
  final int status;
  final String image;
  final String createdAt;
  final String updatedAt;

  const ProductModel({
    required this.productId,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.price,
    required this.status,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  ProductModel copyWith({
    final String? productId,
    final String? categoryId,
    final String? title,
    final String? description,
    final int? price,
    final int? status,
    final String? image,
    final String? createdAt,
    final String? updatedAt,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      status: status ?? this.status,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'],
      categoryId: json['category_id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      status: json['status'],
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'price': price,
      'status': status,
      'image': image,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  List<Object?> get props => [
        productId,
        categoryId,
        title,
        description,
        price,
        status,
        image,
        createdAt,
        updatedAt,
      ];
}
