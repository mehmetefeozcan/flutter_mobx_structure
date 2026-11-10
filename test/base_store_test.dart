import 'package:flutter_mobx_structure/core/base/base_store.dart';
import 'package:flutter_mobx_structure/core/network/result.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

import 'dart:async';

class _TestStore extends BaseStore {}

/// Token iptal edilene kadar bekleyen sahte istek.
Future<Result<String>> _hangUntilCancelled(CancelToken token) async {
  await token.whenCancel;
  return const Failure(
    ApiException('request_cancelled', type: ApiErrorType.cancelled),
  );
}

T? _data<T>(Result<T> result) => switch (result) {
  Success(:final data) => data,
  Failure() => null,
};

ApiErrorType? _errorType<T>(Result<T> result) => switch (result) {
  Success() => null,
  Failure(:final error) => error.type,
};

void main() {
  test('isLoading eşzamanlı isteklerde sayaçla çalışır', () async {
    final store = _TestStore();
    final first = Completer<Result<int>>();
    final second = Completer<Result<int>>();

    final f1 = store.runResult<int>((_) => first.future);
    final f2 = store.runResult<int>((_) => second.future);
    expect(store.isLoading, isTrue);

    first.complete(const Success(1));
    expect(_data(await f1), 1);
    expect(store.isLoading, isTrue, reason: 'ikinci istek hâlâ sürüyor');

    second.complete(const Success(2));
    expect(_data(await f2), 2);
    expect(store.isLoading, isFalse);
  });

  test('hata lastError a yazılır, global işaretli hata yazılmaz', () async {
    final store = _TestStore();

    final result = await store.runResult<int>(
      (_) async => const Failure(ApiException('x', type: ApiErrorType.server)),
    );
    expect(store.lastError?.type, ApiErrorType.server);
    expect(
      _errorType(result),
      ApiErrorType.server,
      reason: 'sonuç aynen döner',
    );

    store.clearError();
    expect(store.lastError, isNull);

    await store.runResult<int>(
      (_) async => const Failure(
        ApiException(
          'y',
          type: ApiErrorType.unauthorized,
          handledGlobally: true,
        ),
      ),
    );
    expect(store.lastError, isNull);
  });

  test('aynı key ile gelen yeni istek öncekini iptal eder', () async {
    final store = _TestStore();
    CancelToken? firstToken;

    final first = store.runResult<String>((token) {
      firstToken = token;
      return _hangUntilCancelled(token);
    }, key: 'search');

    final second = await store.runResult<String>(
      (_) async => const Success('ok'),
      key: 'search',
    );

    expect(firstToken!.isCancelled, isTrue);
    expect(_errorType(await first), ApiErrorType.cancelled);
    expect(_data(second), 'ok');
    expect(store.lastError, isNull, reason: 'iptal hata sayılmaz');
    expect(store.isLoading, isFalse);
  });

  test('dispose iptal edilebilir istekleri keser, cancelOnDispose false olanı kesmez', () async {
    final store = _TestStore();
    CancelToken? readToken;
    CancelToken? mutationToken;
    final mutation = Completer<Result<String>>();

    final read = store.runResult<String>((token) {
      readToken = token;
      return _hangUntilCancelled(token);
    });
    final write = store.runResult<String>((token) {
      mutationToken = token;
      return mutation.future;
    }, cancelOnDispose: false);

    store.dispose();

    expect(readToken!.isCancelled, isTrue);
    expect(mutationToken!.isCancelled, isFalse);
    expect(_errorType(await read), ApiErrorType.cancelled);

    mutation.complete(const Success('saved'));
    expect(_data(await write), 'saved');
    expect(store.isLoading, isFalse);
  });
}
