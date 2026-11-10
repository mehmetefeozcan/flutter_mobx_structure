import 'package:flutter_mobx_structure/core/network/auth/token_provider.dart';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

/// Oturum varsa her isteğe `Authorization: Bearer` header'ı ekler.
class AuthInterceptor extends Interceptor {
  final TokenProvider _tokenProvider;

  AuthInterceptor(this._tokenProvider);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await _tokenProvider.getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e, st) {
      // Token alınamadıysa istek token'sız gider; sunucu 401 dönerse sayfa
      // bunu oturum düşmesi değil, normal hata olarak ele alır.
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: e,
          stack: st,
          library: 'AuthInterceptor',
          context: ErrorDescription('getting token'),
        ),
      );
    }
    handler.next(options);
  }
}
