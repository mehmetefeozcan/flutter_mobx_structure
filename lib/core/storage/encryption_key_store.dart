/// Şifreli Hive box'ının AES anahtarını güvenli bir yerde tutar.
///
/// Anahtar uygulama koduna veya `.env`'ye gömülmez; ilk açılışta rastgele üretilir
/// ve platformun güvenli deposunda (Keychain / Keystore) saklanır.
abstract interface class EncryptionKeyStore {
  /// Kayıtlı anahtarı döndürür; yoksa üretip kaydeder (32 byte).
  Future<List<int>> getOrCreateKey();
}
