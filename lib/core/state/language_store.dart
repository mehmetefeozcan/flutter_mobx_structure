import 'package:flutter_mobx_structure/core/l10n/app_localizations.dart';
import 'package:flutter_mobx_structure/core/storage/local_storage.dart';

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import 'dart:ui';

part 'language_store.g.dart';

/// Uygulama geneli dil seçimi. `null` = cihaz dilini izle (varsayılan);
/// kullanıcı seçerse dil kodu `settings` box'ında saklanır.
///
/// Yalnızca `AppLocalizations.supportedLocales` içindeki diller kabul edilir:
/// kaldırılmış bir dil kayıtlı kalsa bile uygulama sistem diline düşer.
///
/// Tarih/sayı formatı için `Intl.defaultLocale` ya da bir tarih paketinin global
/// yerel ayarı gerekirse `setLocale` içinde ayarlanır; şablonda yok.
@singleton
class LanguageStore = _LanguageStore with _$LanguageStore;

abstract class _LanguageStore with Store {
  _LanguageStore(this._storage) {
    locale = _read();
  }

  final LocalStorage _storage;

  static const _key = 'language_code';

  /// `MaterialApp.locale`'e verilir; `null` sistem dilidir.
  @observable
  Locale? locale;

  /// [newLocale] `null` ise seçim silinir ve cihaz diline dönülür. Desteklenmeyen
  /// bir dil yok sayılır.
  @action
  Future<void> setLocale(Locale? newLocale) async {
    final resolved = newLocale == null
        ? null
        : _supported(newLocale.languageCode);
    if (newLocale != null && resolved == null) return;
    if (resolved == locale) return;

    locale = resolved;
    if (resolved == null) {
      await _storage.settings.delete(_key);
    } else {
      await _storage.settings.put(_key, resolved.languageCode);
    }
  }

  Locale? _read() {
    final saved = _storage.settings.get(_key);
    return saved is String ? _supported(saved) : null;
  }

  Locale? _supported(String languageCode) {
    for (final supported in AppLocalizations.supportedLocales) {
      if (supported.languageCode == languageCode) return supported;
    }
    return null;
  }
}
