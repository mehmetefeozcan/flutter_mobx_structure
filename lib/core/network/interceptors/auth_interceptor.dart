import 'package:flutter_mobx_structure/core/storage/auth_storage.dart';

import 'package:dio/dio.dart';

/// Oturum varsa her isteğe `Authorization: Bearer` header'ı ekler.
class AuthInterceptor extends Interceptor {
  final AuthStorage _authStorage;

  AuthInterceptor(this._authStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _authStorage.token;
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
