import 'package:google_fonts/google_fonts.dart';

import 'dart:async';

/// Tüm testlerden önce çalışır. Testlerin ağa çıkıp font indirmeye çalışmasını
/// engeller (testler deterministik kalır). Font bulunamazsa konsola bir uyarı
/// düşer ve Flutter varsayılan fontuna döner; testler başarısız olmaz.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  await testMain();
}
