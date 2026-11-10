import 'package:flutter_mobx_structure/core/network/auth/stored_token_provider.dart';
import 'package:flutter_mobx_structure/core/storage/local_storage.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dart:io';

void main() {
  late Directory dir;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('hive_test_');
    Hive.init(dir.path);
  });

  tearDown(() async {
    await Hive.close();
    dir.deleteSync(recursive: true);
  });

  test('anahtar ilk çağrıda üretilir, sonra aynı anahtar döner', () async {
    FlutterSecureStorage.setMockInitialValues({});
    const secureStorage = FlutterSecureStorage();

    final first = await LocalStorage.readOrCreateKey(secureStorage);
    final second = await LocalStorage.readOrCreateKey(secureStorage);

    expect(first, hasLength(32));
    expect(second, first);
  });

  test(
    'StoredTokenProvider token yazar, okur ve oturum düşünce siler',
    () async {
      final storage = LocalStorage(
        await Hive.openBox<dynamic>(LocalStorage.settingsBoxName),
        await LocalStorage.openSecureBox(Hive.generateSecureKey()),
      );
      final provider = StoredTokenProvider(storage);

      expect(await provider.getToken(), isNull);
      expect(provider.hasSession, isFalse);

      await provider.saveToken('abc');
      expect(await provider.getToken(), 'abc');
      expect(provider.hasSession, isTrue);

      await provider.onSessionExpired();
      expect(await provider.getToken(), isNull);
    },
  );

  test('şifreli box diskte düz metin içermez', () async {
    final box = await LocalStorage.openSecureBox(Hive.generateSecureKey());
    await box.put('auth_token', 'super-secret-token-value');
    await box.close();

    final bytes = File('${dir.path}/${LocalStorage.secureBoxName}.hive')
        .readAsBytesSync();
    expect(
      String.fromCharCodes(bytes),
      isNot(contains('super-secret-token-value')),
    );
  });

  test('anahtar kaybolursa şifreli box sıfırlanır, uygulama çökmez', () async {
    final oldKey = Hive.generateSecureKey();
    final box = await LocalStorage.openSecureBox(oldKey);
    await box.put('auth_token', 'old');
    await box.close();

    final recovered = await LocalStorage.openSecureBox(
      Hive.generateSecureKey(),
    );

    expect(recovered.isOpen, isTrue);
    expect(recovered.get('auth_token'), isNull);
  });

  test('settings box şifresiz ve bağımsız çalışır', () async {
    final settings = await Hive.openBox<dynamic>(LocalStorage.settingsBoxName);
    await settings.put('theme', 'dark');

    expect(settings.get('theme'), 'dark');
  });
}
