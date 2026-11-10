/// Ağ katmanının oturum bilgisine eriştiği tek arayüz.
///
/// Token'ın nerede yaşadığını (Firebase Auth, kendi backend'in vb.) `core` bilmez;
/// uygulama katmanı bu arayüzü uygular ve DI'a kaydeder.
abstract interface class TokenProvider {
  /// Geçerli oturumun token'ı; oturum yoksa `null`. Her istekte çağrılır,
  /// bu yüzden uygulamalar token yenilemeyi kendi içinde yönetmelidir.
  Future<String?> getToken();

  /// Sunucu oturumu geçersiz saydığında (token'lı istekte 401) çağrılır.
  /// Uygulama burada oturumu kapatmalıdır (ör. `FirebaseAuth.instance.signOut()`).
  Future<void> onSessionExpired();
}
