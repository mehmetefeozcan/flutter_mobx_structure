import 'package:flutter_mobx_structure/core/storage/encryption_key_store.dart';

import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';

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
  static Future<LocalStorage> create(EncryptionKeyStore keyStore) async {
    await Hive.initFlutter();
    final settings = await Hive.openBox<dynamic>(settingsBoxName);
    final secure = await openSecureBox(await keyStore.getOrCreateKey());
    return LocalStorage(settings, secure);
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
