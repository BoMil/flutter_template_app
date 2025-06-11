import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template_app/config/constants/api_endpoints.dart';
import 'package:flutter_template_app/core/shared/models/requests/login_request.dart';
import 'package:flutter_template_app/core/shared/models/responses/login_response.dart';
import 'package:flutter_template_app/core/utils/api/api_response.dart';
import 'package:flutter_template_app/core/utils/api/app_interceptor.dart';

// Example of how to use the API service
class AuthApiService {
  final Dio dio;

  AuthApiService({Dio? dio}) : dio = dio ?? AppInterceptor().dio;

  Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    // ! Example of how to simulate an API call
    // await Future.delayed(const Duration(milliseconds: 100));
    // dynamic fromJson = {
    //   'data': {
    //     'someProperty': 'someValue',
    //     'dataArray': [
    //       {'someProperty': 'someValue'},
    //     ],
    //   }
    // };
    //       SomeModel responseData = SomeModel.fromJson(fromJson['data']);
    // return ApiResponse.completed(responseData);

    try {
      Response response = await dio.post(
        APIEndpoints.login,
        data: request.toJson(),
      );
      if (response.statusCode == 200) {
        LoginResponse loginResponse = LoginResponse.fromJson(response.data);
        return ApiResponse.completed(loginResponse);
      }
      return ApiResponse.error('');
    } on DioException catch (e) {
      // String error = DioExceptionHandler().handleError(e);
      String error = e.message ?? '';
      return ApiResponse.error(error, statusCode: e.response?.statusCode?.toString() ?? '');
    } catch (e) {
      // Catch errors that are not related to DioException
      debugPrint('login() error: ${e.toString()}');
      return ApiResponse.error(e.toString());
    }
  }
}
