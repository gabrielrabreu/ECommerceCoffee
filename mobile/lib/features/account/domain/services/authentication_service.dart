import 'package:dio/dio.dart';

import 'package:eshopcoffe/shared/exceptions/bad_request_exception.dart';
import 'package:eshopcoffe/shared/models/bad_request_response_model.dart';
import 'package:eshopcoffe/shared/services/app_dio.dart';

class AuthenticationService {
  final Dio _dio = AppDio.getInstance();

  Future<Response> login(String username, String password) async {
    final Map<String, String> body = {
      'login': username,
      'password': password
    };

    try {
      Response response = await _dio.post('/identity/login', data: body);
      return response;
    }
    on DioError catch (error) {
      if (error.response?.statusCode == 400) {
        final BadRequestResponseModel model = BadRequestResponseModel.fromJson(error.response?.data);
        throw BadRequestException(model);
      }

      throw Exception(error.message);
    }
  }
}