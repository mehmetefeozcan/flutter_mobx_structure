import 'package:flutter_mobx_structure/core/network/result.dart';

import 'package:dio/dio.dart';
import 'package:mobx/mobx.dart';

part 'base_store.g.dart';

abstract class BaseStore = _BaseStore with _$BaseStore;

abstract class _BaseStore with Store {
  @observable
  int _activeRequests = 0;

  /// Sayfada gösterilecek son hata (`BaseViewMixin.onError` bunu dinler).
  /// İptal edilen ve global ele alınan hatalar buraya yazılmaz.
  @observable
  ApiException? lastError;

  @computed
  bool get isLoading => _activeRequests > 0;

  /// Sayfa kapanınca iptal edilecek istekler.
  final Set<CancelToken> _activeTokens = {};

  /// `key` verilen isteklerin son token'ı; aynı key tekrar gelince öncekini iptal eder.
  final Map<String, CancelToken> _keyedTokens = {};

  @action
  void clearError() => lastError = null;

  /// Bir isteği çalıştırır; yükleme ve hata durumunu yönetir, sonucu aynen döndürür.
  ///
  /// ```dart
  /// if (await runResult((token) => _service.getItems(cancelToken: token))
  ///     case Success(:final data)) {
  ///   items = data;
  /// }
  /// ```
  ///
  /// - [request] kendisine verilen token'ı servise iletmelidir, aksi halde
  ///   iptal edilemez.
  /// - [key]: aynı key ile yeni istek gelirse önceki iptal edilir (arama,
  ///   yenileme). İptal `Failure(cancelled)` döner, hata olarak gösterilmez.
  /// - [cancelOnDispose]: `false` ise sayfa kapanınca iptal edilmez. POST/PUT/DELETE
  ///   gibi mutasyonlarda kullan; iptal, sunucuda işlemin yapılmadığını garanti etmez.
  Future<Result<T>> runResult<T>(
    Future<Result<T>> Function(CancelToken token) request, {
    String? key,
    bool cancelOnDispose = true,
  }) async {
    final token = CancelToken();
    if (key != null) {
      _keyedTokens.remove(key)?.cancel();
      _keyedTokens[key] = token;
    }
    if (cancelOnDispose) _activeTokens.add(token);

    runInAction(() {
      _activeRequests++;
      lastError = null;
    });

    try {
      final result = await request(token);
      if (result case Failure(:final error)) _recordError(error);
      return result;
    } finally {
      _activeTokens.remove(token);
      if (key != null && identical(_keyedTokens[key], token)) {
        _keyedTokens.remove(key);
      }
      runInAction(() => _activeRequests--);
    }
  }

  void _recordError(ApiException error) {
    if (error.type == ApiErrorType.cancelled || error.handledGlobally) return;
    runInAction(() => lastError = error);
  }

  /// Bekleyen (iptal edilebilir) tüm istekleri keser.
  void cancelRequests() {
    for (final token in _activeTokens.toList()) {
      token.cancel();
    }
    _activeTokens.clear();
    _keyedTokens.clear();
  }

  void dispose() => cancelRequests();
}
