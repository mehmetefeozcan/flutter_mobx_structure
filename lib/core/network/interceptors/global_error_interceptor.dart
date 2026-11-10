import 'package:flutter_mobx_structure/core/network/auth/token_provider.dart';
import 'package:flutter_mobx_structure/core/network/global_error.dart';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import 'dart:async';

/// [GlobalError] sayılan yanıtları [GlobalErrorHandler]'a iletir; oturum düştüyse
/// önce [TokenProvider.onSessionExpired] çağrılır.
///
/// Hata yine de isteği yapan servise döner (`ApiException.handledGlobally`),
/// sayfa ayrıca mesaj göstermez. Aynı anda gelen birden çok hata handler'ı
/// birden çok kez çağırabilir; handler zaten hata sayfasındaysa yönlendirmez.
class GlobalErrorInterceptor extends Interceptor {
  GlobalErrorInterceptor(this._tokenProvider, this._handler);

  final TokenProvider _tokenProvider;
  final GlobalErrorHandler _handler;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final error = GlobalError.fromResponse(
      statusCode: err.response?.statusCode,
      hadToken: err.requestOptions.headers['Authorization'] != null,
    );
    if (error != null) unawaited(_handle(error));
    handler.next(err);
  }

  Future<void> _handle(GlobalError error) async {
    try {
      if (error == GlobalError.sessionExpired) {
        await _tokenProvider.onSessionExpired();
      }
      await _handler.handle(error);
    } catch (e, st) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: e,
          stack: st,
          library: 'GlobalErrorInterceptor',
          context: ErrorDescription('handling ${error.name}'),
        ),
      );
    }
  }
}
