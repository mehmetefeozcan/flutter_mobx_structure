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
  /// Sunucu mesajı veya kısa bir anahtar; log/debug içindir. Kullanıcıya
  /// gösterilecek metin `error.localized(context.l10n)` ile türden üretilir.
  final String message;
  final int? statusCode;
  final ApiErrorType type;
  final Object? responseData;

  /// Hata `GlobalErrorHandler` tarafından tam ekran ele alındıysa `true`;
  /// sayfa ayrıca hata mesajı göstermemelidir.
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

  @override
  String toString() => 'ApiException[$type]: $message (status: $statusCode)';
}

/// Ağ çağrısının sonucu: [Success] veri, [Failure] [ApiException] taşır.
///
/// ```dart
/// switch (await service.request(...)) {
///   case Success(:final data): ...
///   case Failure(:final error): ...
/// }
/// ```
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);

  final ApiException error;
}
