import 'package:dio/dio.dart';
import 'package:flutter_mobx_structure/core/network/result.dart';
import 'package:mobx/mobx.dart';

part 'base_store.g.dart';

abstract class BaseStore = _BaseStore with _$BaseStore;

abstract class _BaseStore with Store {
  @observable
  int _activeRequests = 0;

  /// Tek hata kaynağı. UI `ApiErrorParser` ile l10n metnine çevirir.
  @observable
  ApiException? lastError;

  @computed
  bool get isLoading => _activeRequests > 0;

  @computed
  String? get errorMessage => lastError?.message;

  /// Sayfa kapanınca iptal edilecek istekler.
  final Set<CancelToken> _activeTokens = {};

  /// `key` verilen isteklerin son token'ı; aynı key tekrar gelince öncekini iptal eder.
  final Map<String, CancelToken> _keyedTokens = {};

  @action
  void clearError() => lastError = null;

  /// Bir isteği çalıştırır; yükleme ve hata durumunu yönetir.
  ///
  /// - [request] kendisine verilen token'ı servise iletmelidir
  ///   (`service.getX(cancelToken: token)`), aksi halde iptal edilemez.
  /// - [key]: aynı key ile yeni istek gelirse önceki istek iptal edilir
  ///   (arama, yenileme). İptal edilen istek `null` döner, hata göstermez.
  /// - [cancelOnDispose]: `false` ise sayfa kapanınca iptal edilmez. POST/PUT/DELETE
  ///   gibi mutasyonlarda kullan; iptal, sunucuda işlemin yapılmadığını garanti etmez.
  Future<T?> runResult<T>(
    Future<Result<T, ApiException>> Function(CancelToken token) request, {
    String? key,
    bool cancelOnDispose = true,
    void Function(ApiException error)? onFailure,
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
      return switch (result) {
        Success<T, ApiException>(:final data) => data,
        Failure<T, ApiException>(:final error) => _handleFailure<T>(
          error,
          onFailure,
        ),
      };
    } finally {
      _activeTokens.remove(token);
      if (key != null && identical(_keyedTokens[key], token)) {
        _keyedTokens.remove(key);
      }
      runInAction(() => _activeRequests--);
    }
  }

  T? _handleFailure<T>(
    ApiException error,
    void Function(ApiException)? onFailure,
  ) {
    if (error.type == ApiErrorType.cancelled) return null;
    // Global hata ekranına yönlendirildi, sayfada ayrıca gösterme.
    if (!error.handledGlobally) runInAction(() => lastError = error);
    onFailure?.call(error);
    return null;
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
