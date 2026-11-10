import 'package:flutter_mobx_structure/core/state/language_store.dart';
import 'package:flutter_mobx_structure/core/state/theme_store.dart';
import 'package:flutter_mobx_structure/core/storage/local_storage.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'helpers/test_local_storage.dart';

void main() {
  late LocalStorage storage;
  late Future<void> Function() dispose;

  setUpAll(() async {
    final opened = await openTestStorage();
    storage = opened.storage;
    dispose = opened.dispose;
  });

  setUp(() => storage.settings.clear());

  tearDownAll(() => dispose());

  group('ThemeStore', () {
    test('kayıt yoksa sistem temasını izler', () {
      expect(ThemeStore(storage).themeMode, ThemeMode.system);
    });

    test('seçim saklanır ve yeni örnek açılışta okur', () async {
      await ThemeStore(storage).setThemeMode(ThemeMode.dark);

      expect(ThemeStore(storage).themeMode, ThemeMode.dark);
    });

    test('bozuk kayıt sistem temasına düşer', () async {
      await storage.settings.put('theme_mode', 'neon');

      expect(ThemeStore(storage).themeMode, ThemeMode.system);
    });

    test('aynı değeri yazmak diske dokunmaz', () async {
      final store = ThemeStore(storage);
      await store.setThemeMode(ThemeMode.system);

      expect(storage.settings.containsKey('theme_mode'), isFalse);
    });
  });

  group('LanguageStore', () {
    test('kayıt yoksa cihaz dilini izler (null)', () {
      expect(LanguageStore(storage).locale, isNull);
    });

    test('desteklenen dil saklanır ve yeni örnek açılışta okur', () async {
      await LanguageStore(storage).setLocale(const Locale('en'));

      expect(LanguageStore(storage).locale, const Locale('en'));
    });

    test('desteklenmeyen dil yok sayılır', () async {
      final store = LanguageStore(storage);
      await store.setLocale(const Locale('xx'));

      expect(store.locale, isNull);
      expect(storage.settings.containsKey('language_code'), isFalse);
    });

    test('null seçimi siler ve sistem diline döner', () async {
      final store = LanguageStore(storage);
      await store.setLocale(const Locale('en'));
      await store.setLocale(null);

      expect(store.locale, isNull);
      expect(storage.settings.containsKey('language_code'), isFalse);
    });

    test('kayıtlı ama artık desteklenmeyen dil sistem diline düşer', () async {
      await storage.settings.put('language_code', 'xx');

      expect(LanguageStore(storage).locale, isNull);
    });
  });
}
