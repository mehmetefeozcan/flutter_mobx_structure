import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';

import 'dart:convert';

/// Uygulamanın yerel depolaması. İki box içerir:
/// - [settings]: şifresiz; tema, dil, cache gibi hassas olmayan veriler.
/// - [secure]: AES şifreli; token gibi hassas veriler.
///
/// Feature'lar Hive'a doğrudan değil bu sınıf üzerinden erişir. Hive box'ları
/// değerleri bellekte tuttuğu için okumalar (`box.get`) senkrondur.
@preResolve
@singleton
class LocalStorage {
  static const settingsBoxName = 'settings';
  static const secureBoxName = 'secure';

  final Box<dynamic> settings;
  final Box<dynamic> secure;

  LocalStorage(this.settings, this.secure);

  @factoryMethod
  static Future<LocalStorage> create() async {
    await Hive.initFlutter();
    final settings = await Hive.openBox<dynamic>(settingsBoxName);
    final key = await readOrCreateKey(const FlutterSecureStorage());
    return LocalStorage(settings, await openSecureBox(key));
  }

  static const _encryptionKeyName = 'hive_encryption_key';

  /// Şifreli box'ın AES anahtarı. Koda veya `.env`'ye gömülmez: ilk açılışta
  /// rastgele üretilir ve platformun güvenli deposunda (Keychain / Keystore)
  /// saklanır.
  @visibleForTesting
  static Future<List<int>> readOrCreateKey(FlutterSecureStorage storage) async {
    final stored = await storage.read(key: _encryptionKeyName);
    if (stored != null) return base64Url.decode(stored);

    final key = Hive.generateSecureKey();
    await storage.write(key: _encryptionKeyName, value: base64Url.encode(key));
    return key;
  }

  /// Şifreli box'ı açar. Anahtar kaybolduysa (ör. yedekten geri yüklenen dosya,
  /// sıfırlanan Keystore) box okunamaz; bu durumda box silinip temiz açılır.
  /// Sonuç: kullanıcı yeniden giriş yapar, uygulama çökmez.
  @visibleForTesting
  static Future<Box<dynamic>> openSecureBox(List<int> key) async {
    final cipher = HiveAesCipher(key);
    try {
      return await Hive.openBox<dynamic>(
        secureBoxName,
        encryptionCipher: cipher,
      );
    } catch (e, st) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: e,
          stack: st,
          library: 'LocalStorage',
          context: ErrorDescription('opening encrypted box; resetting it'),
        ),
      );
      await Hive.deleteBoxFromDisk(secureBoxName);
      return Hive.openBox<dynamic>(secureBoxName, encryptionCipher: cipher);
    }
  }
}
