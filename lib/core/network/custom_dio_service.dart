import 'package:flutter_mobx_structure/core/network/error/api_exception_mapper.dart';
import 'package:flutter_mobx_structure/core/network/result.dart';

import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

enum HttpMethod { get, post, put, patch, delete }

/// Tüm HTTP çağrılarının geçtiği tek nokta.
///
/// ```dart
/// _api.request(
///   HttpMethod.get,
///   '/users/$id',
///   cancelToken: token,
///   parse: (data) => User.fromJson(data as Map<String, dynamic>),
/// );
/// ```
///
/// - `cancelToken` zorunludur; iptal edilmesi istenmeyen isteklerde bilinçli
///   olarak `null` verilir.
/// - [parse] yanıt gövdesini modele çevirir; parse hatası `ApiErrorType.parsing`
///   olarak döner.
@lazySingleton
class CustomDioService {
  CustomDioService(this._dio);

  final Dio _dio;

  Future<Result<T>> request<T>(
    HttpMethod method,
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
        options: (options ?? Options()).copyWith(
          method: method.name.toUpperCase(),
        ),
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
}
