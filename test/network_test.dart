import 'package:flutter_mobx_structure/core/enums/app_error_enums.dart';
import 'package:flutter_mobx_structure/core/network/auth/token_provider.dart';
import 'package:flutter_mobx_structure/core/network/custom_dio_service.dart';
import 'package:flutter_mobx_structure/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_mobx_structure/core/network/interceptors/global_error_handler.dart';
import 'package:flutter_mobx_structure/core/network/interceptors/global_error_interceptor.dart';
import 'package:flutter_mobx_structure/core/network/result.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

import 'dart:typed_data';

class _FakeTokenProvider implements TokenProvider {
  _FakeTokenProvider(this.token);

  final String? token;
  int expiredCount = 0;

  @override
  Future<String?> getToken() async => token;

  @override
  Future<void> onSessionExpired() async => expiredCount++;
}

class _FakeGlobalErrorHandler implements GlobalErrorHandler {
  final handled = <AppErrorEnums>[];

  @override
  Future<void> handle(AppErrorEnums type) async => handled.add(type);
}

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.status);

  final int status;
  RequestOptions? lastRequest;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    return ResponseBody.fromString(
      '{"message":"boom"}',
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

({CustomDioService service, _FakeAdapter adapter}) _build({
  required int status,
  required _FakeTokenProvider tokens,
  required _FakeGlobalErrorHandler handler,
}) {
  final adapter = _FakeAdapter(status);
  final dio = Dio(BaseOptions(baseUrl: 'http://test.local'))
    ..httpClientAdapter = adapter;
  dio.interceptors.addAll([
    AuthInterceptor(tokens),
    GlobalErrorInterceptor(tokens, handler),
  ]);
  return (service: CustomDioService(dio), adapter: adapter);
}

Future<Result<Object?, ApiException>> _get(CustomDioService service) =>
    service.get('/x', cancelToken: null, parse: (data) => data);

void main() {
  test('token varsa Authorization header eklenir, yoksa eklenmez', () async {
    final withToken = _build(
      status: 200,
      tokens: _FakeTokenProvider('abc'),
      handler: _FakeGlobalErrorHandler(),
    );
    await _get(withToken.service);
    expect(
      withToken.adapter.lastRequest!.headers['Authorization'],
      'Bearer abc',
    );

    final withoutToken = _build(
      status: 200,
      tokens: _FakeTokenProvider(null),
      handler: _FakeGlobalErrorHandler(),
    );
    await _get(withoutToken.service);
    expect(withoutToken.adapter.lastRequest!.headers['Authorization'], isNull);
  });

  test(
    'token ile gelen 401: oturum kapatılır, hata global işaretlenir',
    () async {
      final tokens = _FakeTokenProvider('abc');
      final handler = _FakeGlobalErrorHandler();
      final result = await _get(
        _build(status: 401, tokens: tokens, handler: handler).service,
      );
      await Future<void>.delayed(Duration.zero);

      final error = (result as Failure<Object?, ApiException>).error;
      expect(error.type, ApiErrorType.unauthorized);
      expect(error.handledGlobally, isTrue);
      expect(tokens.expiredCount, 1);
      expect(handler.handled, [AppErrorEnums.sessionExpired]);
    },
  );

  test('token olmadan gelen 401 oturum düşmesi sayılmaz', () async {
    final tokens = _FakeTokenProvider(null);
    final handler = _FakeGlobalErrorHandler();
    final result = await _get(
      _build(status: 401, tokens: tokens, handler: handler).service,
    );
    await Future<void>.delayed(Duration.zero);

    final error = (result as Failure<Object?, ApiException>).error;
    expect(error.handledGlobally, isFalse);
    expect(tokens.expiredCount, 0);
    expect(handler.handled, isEmpty);
  });

  test(
    'art arda gelen 503 hataları cooldown ile tek yönlendirme yapar',
    () async {
      final handler = _FakeGlobalErrorHandler();
      final built = _build(
        status: 503,
        tokens: _FakeTokenProvider(null),
        handler: handler,
      );
      await _get(built.service);
      await _get(built.service);
      await Future<void>.delayed(Duration.zero);

      expect(handler.handled, [AppErrorEnums.maintenance]);
    },
  );

  test('sunucu mesajı ve tür eşlemesi', () async {
    final result = await _get(
      _build(
        status: 429,
        tokens: _FakeTokenProvider(null),
        handler: _FakeGlobalErrorHandler(),
      ).service,
    );

    final error = (result as Failure<Object?, ApiException>).error;
    expect(error.type, ApiErrorType.tooManyRequests);
    expect(error.message, 'boom');
    expect(error.statusCode, 429);
  });

  test('parse hatası ApiErrorType.parsing döner', () async {
    final built = _build(
      status: 200,
      tokens: _FakeTokenProvider(null),
      handler: _FakeGlobalErrorHandler(),
    );
    final result = await built.service.get<int>(
      '/x',
      cancelToken: null,
      parse: (data) => (data as Map)['missing'] as int,
    );

    final error = (result as Failure<int, ApiException>).error;
    expect(error.type, ApiErrorType.parsing);
  });

  test('iptal edilen token ApiErrorType.cancelled döner', () async {
    final token = CancelToken()..cancel();
    final built = _build(
      status: 200,
      tokens: _FakeTokenProvider(null),
      handler: _FakeGlobalErrorHandler(),
    );
    final result = await built.service.get<Object?>(
      '/x',
      cancelToken: token,
      parse: (data) => data,
    );

    final error = (result as Failure<Object?, ApiException>).error;
    expect(error.type, ApiErrorType.cancelled);
  });
}
