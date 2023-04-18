import 'package:equatable/equatable.dart';

class CategoriesModel extends Equatable {
  final int id;
  final String categoryId;
  final String title;

  const CategoriesModel({
    required this.categoryId,
    required this.id,
    required this.title,
  });

  CategoriesModel copyWith({
    final int? id,
    final String? categoryId,
    final String? title,
  }) {
    return CategoriesModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
    );
  }

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      id: json['id'],
      categoryId: json['category_id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
    };
  }

  @override
  List<Object?> get props => [
        id,
        categoryId,
        title,
      ];
}
