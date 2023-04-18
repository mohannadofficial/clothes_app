import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/constans/constans.dart';
import 'package:ecommerce_app/core/failure.dart';
import 'package:ecommerce_app/core/network/remote/dio_helper.dart';
import 'package:ecommerce_app/core/typdef.dart';
import 'package:ecommerce_app/models/error_model.dart';
import 'package:ecommerce_app/models/user_model.dart';
import 'package:flutter/foundation.dart';

class AuthRepository {
  FutureEither<UserModel> loginSubmit({
    required String userName,
    required String password,
  }) async {
    try {
      Response response = await DioHelper.postData(
        endPoint: 'user/login',
        data: {
          'username': userName,
          'password': password,
        },
      );
      if (response.data['user'] == null) {
        throw AppConstans.errorMessage;
      }
      return right(UserModel.fromJson(response.data));
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  FutureVoid registerSubmit({
    required String fullName,
    required String userName,
    required String password,
  }) async {
    try {
      Response response = await DioHelper.postData(
        endPoint: 'user/register',
        data: {
          'name': fullName,
          'username': userName,
          'password': password,
        },
      );
      if (response.data['errors']['username'] != null) {
        ErrorModel error = ErrorModel.fromJson(response.data);
        throw error.errors.username[0];
      }
      return right(null);
    } catch (e) {
      return left(Failure(error: e.toString()));
    }
  }

  FutureEither<UserModel> getLoginCache(
      {required String token, required String userId}) async {
    try {
      final Response response = await DioHelper.postData(
        endPoint: 'user/read',
        token: token,
        data: {
          'userid': userId,
        },
      );
      return right(
          UserModel.fromJson(response.data[0], isLogin: false, token: token));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return left(Failure(error: e.toString()));
    }
  }
}
