import 'package:ecommerce_app/core/enum.dart';
import 'package:ecommerce_app/models/category_model.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final int selectIndex;
  final List<CategoriesModel> categoriesModel;
  final List<ProductModel> productsModel;
  final ProductModel? productsModelScreen;
  final SubmissionStatus submissionStatus;
  final String errorMessage;
  final int numCartItem;
  final List<String> like;
  final List<ProductModel> likeProductModel;
  final List<ProductModel> productCartModel;
  final List<String> filterCategoryModel;
  final List<String> selectFilterCategoryModel;

  const HomeState(
      {this.selectIndex = 0,
      this.categoriesModel = const [],
      this.productsModel = const [],
      this.submissionStatus = SubmissionStatus.idle,
      this.errorMessage = '',
      this.productsModelScreen,
      this.numCartItem = 1,
      this.like = const [],
      this.likeProductModel = const [],
      this.productCartModel = const [],
      this.filterCategoryModel = const [],
      this.selectFilterCategoryModel = const []});

  HomeState copyWith({
    final int? selectIndex,
    final List<CategoriesModel>? categoriesModel,
    final List<ProductModel>? productsModel,
    final SubmissionStatus? submissionStatus,
    final String? errorMessage,
    final ProductModel? productsModelScreen,
    final int? numCartItem,
    final List<String>? like,
    final List<ProductModel>? likeProductModel,
    final List<ProductModel>? productCartModel,
    final List<String>? filterCategoryModel,
    final List<String>? selectFilterCategoryModel,
  }) {
    return HomeState(
      selectIndex: selectIndex ?? this.selectIndex,
      categoriesModel: categoriesModel ?? this.categoriesModel,
      errorMessage: errorMessage ?? this.errorMessage,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      productsModel: productsModel ?? this.productsModel,
      productsModelScreen: productsModelScreen ?? this.productsModelScreen,
      numCartItem: numCartItem ?? this.numCartItem,
      like: like ?? this.like,
      likeProductModel: likeProductModel ?? this.likeProductModel,
      productCartModel: productCartModel ?? this.productCartModel,
      filterCategoryModel: filterCategoryModel ?? this.filterCategoryModel,
      selectFilterCategoryModel:
          selectFilterCategoryModel ?? this.selectFilterCategoryModel,
    );
  }

  @override
  List<Object?> get props => [
        selectIndex,
        categoriesModel,
        submissionStatus,
        errorMessage,
        productsModel,
        productsModelScreen,
        numCartItem,
        like,
        likeProductModel,
        productCartModel,
        filterCategoryModel,
        selectFilterCategoryModel,
      ];
}
