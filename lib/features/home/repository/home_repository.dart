import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/failure.dart';
import 'package:ecommerce_app/core/network/remote/dio_helper.dart';
import 'package:ecommerce_app/core/typdef.dart';
import 'package:ecommerce_app/models/category_model.dart';
import 'package:ecommerce_app/models/product_model.dart';

class HomeRepository {
  FutureEither<List<CategoriesModel>> getCategories(String token) async {
    try {
      final Response response = await DioHelper.getData(
        endPoint: 'categories',
        query: {
          'page': '1',
        },
        token: token,
      );
      return right(
        List<CategoriesModel>.from(
          response.data['data'].map(
            (e) => CategoriesModel.fromJson(e),
          ),
        ),
      );
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  FutureEither<List<ProductModel>> getProducts(String token) async {
    try {
      final Response response = await DioHelper.getData(
        endPoint: 'products',
        query: {
          'page': '1',
        },
        token: token,
      );

      return right(
        List<ProductModel>.from(
          response.data['data'].map(
            (e) => ProductModel.fromJson(e),
          ),
        ),
      );
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }
}
