import 'package:flutter_mobx_structure/core/enums/app_error_enums.dart';
import 'package:flutter_mobx_structure/core/network/interceptors/global_error_handler.dart';
import 'package:flutter_mobx_structure/core/storage/auth_storage.dart';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import 'dart:async';

/// Sayfadan bağımsız hataları tek yerde yakalar ve [GlobalErrorHandler]'a iletir:
/// - 401 (token gönderilmişse): oturum temizlenir → `sessionExpired`
/// - 503: `maintenance`
///
/// Hata yine de servise iletilir; `ApiException.handledGlobally` ile işaretlenir ki
/// sayfa ayrıca hata mesajı göstermesin.
class GlobalErrorInterceptor extends Interceptor {
  static const handledKey = 'handledGlobally';

  /// Aynı hata tipi bu süre içinde tekrar gelirse yeniden yönlendirilmez.
  static const _cooldown = Duration(seconds: 2);

  final AuthStorage _authStorage;
  final GlobalErrorHandler _handler;

  GlobalErrorInterceptor(this._authStorage, this._handler);

  AppErrorEnums? _lastType;
  DateTime? _lastHandledAt;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final type = typeFor(
      statusCode: err.response?.statusCode,
      hadToken: err.requestOptions.headers['Authorization'] != null,
    );
    if (type != null) {
      err.requestOptions.extra[handledKey] = true;
      unawaited(_handle(type));
    }
    handler.next(err);
  }

  /// Hangi yanıtın tam ekran hata sayfasına yönlendireceğine karar verir; `null` → sayfa kendisi ele alır.
  @visibleForTesting
  static AppErrorEnums? typeFor({int? statusCode, required bool hadToken}) {
    return switch (statusCode) {
      // Token'sız istekte (ör. giriş) 401 oturum düşmesi değildir.
      401 when hadToken => AppErrorEnums.sessionExpired,
      503 => AppErrorEnums.maintenance,
      _ => null,
    };
  }

  Future<void> _handle(AppErrorEnums type) async {
    final now = DateTime.now();
    final last = _lastHandledAt;
    if (_lastType == type && last != null && now.difference(last) < _cooldown) {
      return;
    }
    _lastType = type;
    _lastHandledAt = now;

    try {
      if (type == AppErrorEnums.sessionExpired) {
        await _authStorage.clearSession();
      }
      await _handler.handle(type);
    } catch (e, st) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: e,
          stack: st,
          library: 'GlobalErrorInterceptor',
          context: ErrorDescription('handling ${type.name}'),
        ),
      );
    }
  }
}
