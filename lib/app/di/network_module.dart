import 'package:flutter_mobx_structure/core/network/interceptors/global_error_interceptor.dart';
import 'package:flutter_mobx_structure/core/network/global_error.dart';
import 'package:flutter_mobx_structure/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_mobx_structure/core/network/auth/token_provider.dart';
import 'package:flutter_mobx_structure/app/env/env.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

/// Dio, `Env` (app katmanı) ve `GlobalErrorHandler` (router'a bağlı) gerektirdiği
/// için `core` yerine `app/di` altında yaşar.
@module
abstract class NetworkModule {
  @lazySingleton
  Dio dio(TokenProvider tokenProvider, GlobalErrorHandler errorHandler) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: 'application/json',
      ),
    );

    // Sıra önemli: GlobalErrorInterceptor, AuthInterceptor'ın eklediği
    // Authorization header'ına bakarak 401'in oturum düşmesi olup olmadığına karar verir.
    dio.interceptors.addAll([
      AuthInterceptor(tokenProvider),
      GlobalErrorInterceptor(tokenProvider, errorHandler),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
    ]);

    return dio;
  }
}
