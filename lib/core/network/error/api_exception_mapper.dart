import 'package:flutter_mobx_structure/core/network/interceptors/global_error_interceptor.dart';
import 'package:flutter_mobx_structure/core/network/result.dart';

import 'package:dio/dio.dart';

import 'dart:convert';

/// `DioException` -> `ApiException` dönüşümünün tek noktası.
abstract final class ApiExceptionMapper {
  static ApiException fromDio(DioException e) {
    if (e.type == DioExceptionType.cancel) {
      return ApiException(
        'request_cancelled',
        type: ApiErrorType.cancelled,
        cause: e,
        stackTrace: e.stackTrace,
      );
    }

    final statusCode = e.response?.statusCode;
    final data = e.response?.data;

    final type = switch (e.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout => ApiErrorType.network,
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout => ApiErrorType.timeout,
      DioExceptionType.badResponse => _typeForStatus(statusCode),
      _ => ApiErrorType.unknown,
    };

    final message = switch (type) {
      ApiErrorType.network => 'network_error',
      ApiErrorType.timeout => 'timeout_error',
      _ => _extractMessage(data) ?? e.message ?? type.name,
    };

    final exception = ApiException(
      message,
      statusCode: statusCode,
      type: type,
      responseData: data,
      cause: e,
      stackTrace: e.stackTrace,
    );

    final handled =
        e.requestOptions.extra[GlobalErrorInterceptor.handledKey] == true;
    return handled ? exception.copyWith(handledGlobally: true) : exception;
  }

  static ApiErrorType _typeForStatus(int? statusCode) => switch (statusCode) {
    400 => ApiErrorType.badRequest,
    401 => ApiErrorType.unauthorized,
    403 => ApiErrorType.forbidden,
    404 => ApiErrorType.notFound,
    429 => ApiErrorType.tooManyRequests,
    503 => ApiErrorType.maintenance,
    int s when s >= 500 => ApiErrorType.server,
    _ => ApiErrorType.unknown,
  };

  static String? _extractMessage(Object? data) {
    try {
      final decoded = data is String ? jsonDecode(data) : data;
      if (decoded is! Map) return null;

      final message = decoded['Message'] ?? decoded['message'];
      final text = message?.toString().trim();
      return (text == null || text.isEmpty) ? null : text;
    } catch (_) {
      return null;
    }
  }
}
