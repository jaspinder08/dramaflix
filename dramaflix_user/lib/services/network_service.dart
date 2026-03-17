import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'logger.dart';

/// A singleton service to handle all network requests using Dio.
class NetworkService {
  // Private constructor
  NetworkService._();

  static final Dio _dio = _createDio();

  /// Returns the singleton Dio instance.
  static Dio get instance => _dio;

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
      ),
    );

    // Network logging interceptor enabled only in debug mode
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
          logPrint: (object) => Log.debug(object.toString()),
        ),
      );
    }

    return dio;
  }
}
