/// Sayfadan bağımsız, tam ekran ele alınan ağ hataları. Geri kalan her hata
/// isteği yapan sayfaya `Failure` olarak döner.
enum GlobalError {
  /// Token'lı istekte 401: sunucu oturumu geçersiz saydı.
  sessionExpired,

  /// 503: servis bakımda.
  maintenance;

  /// Yanıtın global hata olup olmadığına karar verir; `null` → sayfa ele alır.
  /// Token'sız istekteki 401 (ör. hatalı giriş) oturum düşmesi değildir.
  static GlobalError? fromResponse({int? statusCode, required bool hadToken}) {
    return switch (statusCode) {
      401 when hadToken => sessionExpired,
      503 => maintenance,
      _ => null,
    };
  }
}

/// Global hataların nasıl sunulacağını belirler. `core` router'ı bilmez;
/// uygulama katmanı bu arayüzü uygular (ör. hata sayfasına yönlendirme).
abstract interface class GlobalErrorHandler {
  Future<void> handle(GlobalError error);
}
