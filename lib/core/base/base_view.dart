import 'package:flutter_mobx_structure/core/base/base_store.dart';
import 'package:flutter_mobx_structure/core/network/result.dart';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import 'dart:async';

mixin BaseViewMixin<T extends StatefulWidget> on State<T> {
  final List<ReactionDisposer> _disposers = [];

  /// Sayfada `getter` değil `field` olarak override et:
  /// `@override late final store = getIt<X>();`
  /// Getter + factory DI, her erişimde yeni store üretir.
  BaseStore? get store => null;

  /// Override in page. Senkron kısmında `context`'ten InheritedWidget
  /// (Theme.of, context.l10n vb.) okunamaz.
  Future<void> onInit() async {}

  /// Override in page
  void onDispose() {}

  /// Store'daki `lastError` değiştiğinde çağrılır.
  void onError(ApiException error) {}

  void addReaction(ReactionDisposer disposer) {
    _disposers.add(disposer);
  }

  void addReactions(List<ReactionDisposer> disposers) {
    _disposers.addAll(disposers);
  }

  @override
  void initState() {
    super.initState();

    final s = store;
    if (s != null) {
      addReaction(
        reaction((_) => s.lastError, (e) {
          if (e != null && mounted) onError(e);
        }),
      );
    }

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
    for (final d in _disposers) {
      d();
    }
    store?.dispose();
    onDispose();
    super.dispose();
  }
}
