import 'package:flutter_mobx_structure/core/network/result.dart';

enum AppErrorEnums {
  notFound,
  wentWrong,
  noConnection,
  sessionExpired,
  forbidden,
  maintenance;

  /// Aynı isteği tekrar atmanın anlamlı olduğu hatalar.
  bool get isRetryable => this == noConnection || this == wentWrong;

  static AppErrorEnums fromApi(ApiErrorType type) => switch (type) {
    ApiErrorType.notFound => notFound,
    ApiErrorType.network || ApiErrorType.timeout => noConnection,
    ApiErrorType.unauthorized => sessionExpired,
    ApiErrorType.forbidden => forbidden,
    ApiErrorType.maintenance => maintenance,
    _ => wentWrong,
  };
}
