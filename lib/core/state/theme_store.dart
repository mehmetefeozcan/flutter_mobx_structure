import 'package:flutter_mobx_structure/core/storage/local_storage.dart';

import 'package:injectable/injectable.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'theme_store.g.dart';

/// Uygulama geneli tema seçimi (sistem / açık / koyu). Seçim `settings` box'ında
/// saklanır.
///
/// Box zaten açık olduğu için seçim yapıcıda senkron okunur: ayrı bir `load`
/// çağrısı yok, ilk karede yanlış tema yanıp sönmez.
@singleton
class ThemeStore = _ThemeStore with _$ThemeStore;

abstract class _ThemeStore with Store {
  _ThemeStore(this._storage) {
    themeMode = _read();
  }

  final LocalStorage _storage;

  static const _key = 'theme_mode';

  /// Varsayılan `system`: kullanıcı seçmediyse cihaz ayarı izlenir.
  @observable
  ThemeMode themeMode = ThemeMode.system;

  @action
  Future<void> setThemeMode(ThemeMode mode) async {
    if (mode == themeMode) return;
    themeMode = mode;
    await _storage.settings.put(_key, mode.name);
  }

  ThemeMode _read() {
    final saved = _storage.settings.get(_key);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == saved,
      orElse: () => ThemeMode.system,
    );
  }
}
