import 'package:flutter_mobx_structure/core/enums/app_error_enums.dart';

/// Sayfadan bağımsız (oturum düştü, bakım modu) hataların nasıl sunulacağını
/// belirler. `core` router'ı bilmez; uygulama katmanı bu arayüzü uygular
/// (ör. hata sayfasına yönlendirme) ve DI'a kaydeder.
abstract interface class GlobalErrorHandler {
  Future<void> handle(AppErrorEnums type);
}
