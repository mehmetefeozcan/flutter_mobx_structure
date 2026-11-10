enum ApiErrorType {
  network,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  badRequest,
  tooManyRequests,
  server,
  maintenance,
  cancelled,

  /// Yanıt alındı ama beklenen modele çevrilemedi (JSON/model uyumsuzluğu).
  parsing,
  unknown,
}

class ApiException implements Exception {
  /// Sunucu mesajı veya kısa bir anahtar. Kullanıcıya doğrudan gösterilmez;
  /// UI metni `ApiErrorParser` ile l10n'dan üretilir. Log/debug içindir.
  final String message;
  final int? statusCode;
  final ApiErrorType type;
  final Object? responseData;

  /// `GlobalErrorInterceptor` bu hatayı yakalayıp hata ekranına yönlendirdiyse
  /// `true` olur; sayfa ayrıca hata mesajı göstermemelidir.
  final bool handledGlobally;

  /// Hatanın orijinal nedeni (ör. `DioException`, `FormatException`).
  final Object? cause;
  final StackTrace? stackTrace;

  const ApiException(
    this.message, {
    this.statusCode,
    this.type = ApiErrorType.unknown,
    this.responseData,
    this.handledGlobally = false,
    this.cause,
    this.stackTrace,
  });

  ApiException copyWith({bool? handledGlobally}) => ApiException(
    message,
    statusCode: statusCode,
    type: type,
    responseData: responseData,
    handledGlobally: handledGlobally ?? this.handledGlobally,
    cause: cause,
    stackTrace: stackTrace,
  );

  @override
  String toString() => 'ApiException[$type]: $message (status: $statusCode)';
}

sealed class Result<S, E extends Exception> {
  const Result();
}

final class Success<S, E extends Exception> extends Result<S, E> {
  final S data;
  const Success(this.data);
}

final class Failure<S, E extends Exception> extends Result<S, E> {
  final E error;
  const Failure(this.error);
}
