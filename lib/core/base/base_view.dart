import 'package:flutter_mobx_structure/core/base/base_store.dart';
import 'package:flutter_mobx_structure/core/network/result.dart';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import 'dart:async';

/// Store'u olan sayfaların ortak yaşam döngüsü: store bir kez oluşturulur, hata
/// [onError]'a iletilir, sayfa kapanınca reaction'lar ve store temizlenir.
///
/// ```dart
/// class _HomeViewState extends State<HomeView>
///     with BaseViewMixin<HomeView, HomeStore> {
///   @override
///   HomeStore createStore() => getIt<HomeStore>();
///
///   @override
///   Future<void> onInit() => store.load();
/// }
/// ```
///
/// Store'u olmayan sayfa bu mixin'i kullanmaz.
mixin BaseViewMixin<T extends StatefulWidget, S extends BaseStore> on State<T> {
  /// Sayfanın store'u; ilk erişimde [createStore] ile bir kez oluşturulur.
  late final S store = createStore();

  final List<ReactionDisposer> _disposers = [];

  S createStore();

  /// Sayfa açılınca bir kez çalışır. Senkron kısmında `context`'ten
  /// InheritedWidget (Theme.of, context.l10n vb.) okunamaz.
  Future<void> onInit() async {}

  void onDispose() {}

  /// Store'un `lastError`'ı değiştiğinde çağrılır (snackbar, dialog vb.).
  void onError(ApiException error) {}

  /// Sayfa kapanınca otomatik temizlenecek reaction ekler.
  void addReaction(ReactionDisposer disposer) => _disposers.add(disposer);

  @override
  void initState() {
    super.initState();
    addReaction(
      reaction((_) => store.lastError, (error) {
        if (error != null && mounted) onError(error);
      }),
    );
    unawaited(_runInit());
  }

  Future<void> _runInit() async {
    try {
      await onInit();
    } catch (e, st) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: e,
          stack: st,
          library: 'BaseViewMixin',
          context: ErrorDescription('onInit'),
        ),
      );
    }
  }

  @override
  void dispose() {
    for (final dispose in _disposers) {
      dispose();
    }
    store.dispose();
    onDispose();
    super.dispose();
  }
}
