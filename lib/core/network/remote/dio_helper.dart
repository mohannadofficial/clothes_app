import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: "http://10.0.2.2:8000/api/",
          //baseUrl: "http://mohnd-info.com/api/ecommerce/",
          receiveDataWhenStatusError: true,
          validateStatus: (status) => true,
          connectTimeout: 1000 * 60

          //headers: {},
          ),
    );
  }

  static Future<Response> getData({
    required String endPoint,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    try {
      dio!.options.headers = {
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      return await dio!.get(
        endPoint,
        queryParameters: query,
      );
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<Response> postData({
    required String endPoint,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    try {
      dio!.options.headers = {
        'content-type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      return await dio!.post(
        endPoint,
        queryParameters: query,
        data: data,
      );
    } catch (e) {
      throw e.toString();
    }
  }
}
