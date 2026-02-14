import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

class AppHttpClient {
  late final Dio _dio;

  static final AppHttpClient _instance = AppHttpClient._internal();
  factory AppHttpClient() {
    return _instance;
  }

  AppHttpClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => handler.next(options),
        onResponse: (response, handler) => handler.next(response),
        onError: (DioException e, handler) => handler.next(e),
      ),
    );
  }

  Dio get client {
    return _dio;
  }
}
