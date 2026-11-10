import 'package:flutter_mobx_structure/core/network/error/api_exception_mapper.dart';
import 'package:flutter_mobx_structure/core/network/result.dart';

import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

/// Tüm HTTP çağrılarının geçtiği tek nokta.
///
/// - `cancelToken` zorunlu parametredir; iptal edilmesi istenmeyen isteklerde
///   bilinçli olarak `null` verilir.
/// - [parse], yanıt gövdesini modele çevirir. Parse sırasında oluşan hata
///   `ApiErrorType.parsing` olarak döner.
@lazySingleton
class CustomDioService {
  final Dio _dio;

  CustomDioService(this._dio);

  Future<Result<T, ApiException>> request<T>(
    String method,
    String path, {
    required CancelToken? cancelToken,
    required T Function(Object? data) parse,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.request<Object?>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: method),
        cancelToken: cancelToken,
      );
      return Success(parse(response.data));
    } on DioException catch (e) {
      return Failure(ApiExceptionMapper.fromDio(e));
    } catch (e, st) {
      return Failure(
        ApiException(
          'parse_error',
          type: ApiErrorType.parsing,
          cause: e,
          stackTrace: st,
        ),
      );
    }
  }

  Future<Result<T, ApiException>> get<T>(
    String path, {
    required CancelToken? cancelToken,
    required T Function(Object? data) parse,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => request(
    'GET',
    path,
    cancelToken: cancelToken,
    parse: parse,
    data: data,
    queryParameters: queryParameters,
    options: options,
  );

  Future<Result<T, ApiException>> post<T>(
    String path, {
    required CancelToken? cancelToken,
    required T Function(Object? data) parse,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => request(
    'POST',
    path,
    cancelToken: cancelToken,
    parse: parse,
    data: data ?? {},
    queryParameters: queryParameters,
    options: options,
  );

  Future<Result<T, ApiException>> put<T>(
    String path, {
    required CancelToken? cancelToken,
    required T Function(Object? data) parse,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => request(
    'PUT',
    path,
    cancelToken: cancelToken,
    parse: parse,
    data: data ?? {},
    queryParameters: queryParameters,
    options: options,
  );

  Future<Result<T, ApiException>> patch<T>(
    String path, {
    required CancelToken? cancelToken,
    required T Function(Object? data) parse,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => request(
    'PATCH',
    path,
    cancelToken: cancelToken,
    parse: parse,
    data: data ?? {},
    queryParameters: queryParameters,
    options: options,
  );

  Future<Result<T, ApiException>> delete<T>(
    String path, {
    required CancelToken? cancelToken,
    required T Function(Object? data) parse,
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => request(
    'DELETE',
    path,
    cancelToken: cancelToken,
    parse: parse,
    data: data ?? {},
    queryParameters: queryParameters,
    options: options,
  );
}
