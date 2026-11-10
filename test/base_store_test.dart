import 'package:flutter_mobx_structure/core/base/base_store.dart';
import 'package:flutter_mobx_structure/core/network/result.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';

import 'dart:async';

class _TestStore extends BaseStore {}

/// Token iptal edilene kadar bekleyen sahte istek.
Future<Result<String, ApiException>> _hangUntilCancelled(CancelToken token) async {
  await token.whenCancel;
  return const Failure(
    ApiException('request_cancelled', type: ApiErrorType.cancelled),
  );
}

void main() {
  test('isLoading eşzamanlı isteklerde sayaçla çalışır', () async {
    final store = _TestStore();
    final first = Completer<Result<int, ApiException>>();
    final second = Completer<Result<int, ApiException>>();

    final f1 = store.runResult<int>((_) => first.future);
    final f2 = store.runResult<int>((_) => second.future);
    expect(store.isLoading, isTrue);

    first.complete(const Success(1));
    expect(await f1, 1);
    expect(store.isLoading, isTrue, reason: 'ikinci istek hâlâ sürüyor');

    second.complete(const Success(2));
    expect(await f2, 2);
    expect(store.isLoading, isFalse);
  });

  test('hata lastError a yazılır, global işaretli hata yazılmaz', () async {
    final store = _TestStore();

    await store.runResult<int>(
      (_) async => const Failure(ApiException('x', type: ApiErrorType.server)),
    );
    expect(store.lastError?.type, ApiErrorType.server);

    store.clearError();
    expect(store.lastError, isNull);

    await store.runResult<int>(
      (_) async => const Failure(
        ApiException('y', type: ApiErrorType.unauthorized, handledGlobally: true),
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
    expect(await first, isNull);
    expect(second, 'ok');
    expect(store.lastError, isNull, reason: 'iptal hata sayılmaz');
    expect(store.isLoading, isFalse);
  });

  test('dispose iptal edilebilir istekleri keser, cancelOnDispose false olanı kesmez', () async {
    final store = _TestStore();
    CancelToken? readToken;
    CancelToken? mutationToken;
    final mutation = Completer<Result<String, ApiException>>();

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
    expect(await read, isNull);

    mutation.complete(const Success('saved'));
    expect(await write, 'saved');
    expect(store.isLoading, isFalse);
  });
}
