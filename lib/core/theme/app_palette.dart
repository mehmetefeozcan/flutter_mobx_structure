import 'package:flutter/painting.dart';

/// Ham renk paleti (tasarım rampaları). UI kodunda doğrudan değil, anlamsal
/// token'lar (`AppColorTokens`) üzerinden kullan; palet token'ların kaynağıdır.
///
/// Değerler tasarım görselindeki swatch piksellerinden alındı; Figma'daki kesin
/// hex ile karşılaştırıp düzeltilebilir. Eski (legacy) Royal Blue ve Ultramarine
/// rampaları şablona alınmadı.
abstract final class AppBaseColors {
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
}

/// Ana marka rengi. 500 ana tondur.
abstract final class AppOrange {
  static const Color shade50 = Color(0xFFFDF6EB);
  static const Color shade100 = Color(0xFFFDE8CD);
  static const Color shade200 = Color(0xFFFED6A6);
  static const Color shade300 = Color(0xFFFDC47C);
  static const Color shade400 = Color(0xFFFFAA43);
  static const Color shade500 = Color(0xFFFF9B10);
  static const Color shade600 = Color(0xFFDC7B05);
  static const Color shade700 = Color(0xFFAC640B);
  static const Color shade800 = Color(0xFF804D0C);
  static const Color shade900 = Color(0xFF56330B);
  static const Color shade950 = Color(0xFF2A1B07);
}

/// İkincil vurgu. Not: 500 tasarımda rampadan kopuk (krimson), bilerek aynen alındı.
abstract final class AppCoral {
  static const Color shade50 = Color(0xFFFFEFE9);
  static const Color shade100 = Color(0xFFFECEBF);
  static const Color shade200 = Color(0xFFFFB79B);
  static const Color shade300 = Color(0xFFFDA07D);
  static const Color shade400 = Color(0xFFFE8F65);
  static const Color shade500 = Color(0xFFE51448);
  static const Color shade600 = Color(0xFFE8541D);
  static const Color shade700 = Color(0xFF963A17);
  static const Color shade800 = Color(0xFF7C2E12);
  static const Color shade900 = Color(0xFF511E0B);
  static const Color shade950 = Color(0xFF240D02);
}

/// Premium ve yaratıcı vurgu. 500 ana tondur.
abstract final class AppPurple {
  static const Color shade50 = Color(0xFFEFE9FF);
  static const Color shade100 = Color(0xFFD4BEFE);
  static const Color shade200 = Color(0xFFBE9BFF);
  static const Color shade300 = Color(0xFFAA7EFF);
  static const Color shade400 = Color(0xFF9965FF);
  static const Color shade500 = Color(0xFF6022DB);
  static const Color shade600 = Color(0xFF4D13BF);
  static const Color shade700 = Color(0xFF3D1687);
  static const Color shade800 = Color(0xFF36127B);
  static const Color shade900 = Color(0xFF220B50);
  static const Color shade950 = Color(0xFF0E0425);
}

/// Soğuk nötr: kart, arka plan ve kenarlık.
abstract final class AppBlueGray {
  static const Color shade50 = Color(0xFFF9FBFC);
  static const Color shade100 = Color(0xFFF1F5F9);
  static const Color shade200 = Color(0xFFE3E9F0);
  static const Color shade300 = Color(0xFFCCD5E2);
  static const Color shade400 = Color(0xFF94A3B7);
  static const Color shade500 = Color(0xFF64748C);
  static const Color shade600 = Color(0xFF465569);
  static const Color shade700 = Color(0xFF324155);
  static const Color shade800 = Color(0xFF1E293C);
  static const Color shade900 = Color(0xFF0F172B);
  static const Color shade950 = Color(0xFF050A13);
}

/// Nötr: metin hiyerarşisi ve yüzeyler.
abstract final class AppGray {
  static const Color shade50 = Color(0xFFFAFAFA);
  static const Color shade100 = Color(0xFFF5F5F5);
  static const Color shade200 = Color(0xFFE4E4E6);
  static const Color shade300 = Color(0xFFD5D4D9);
  static const Color shade400 = Color(0xFFA0A1AA);
  static const Color shade500 = Color(0xFF71717A);
  static const Color shade600 = Color(0xFF51525B);
  static const Color shade700 = Color(0xFF403F46);
  static const Color shade800 = Color(0xFF28272A);
  static const Color shade900 = Color(0xFF18181A);
  static const Color shade950 = Color(0xFF0A0A0A);
}

/// Olumlu eylem ve tamamlanmış durum.
abstract final class AppSuccess {
  static const Color shade50 = Color(0xFFECF6EE);
  static const Color shade100 = Color(0xFFD2F1DB);
  static const Color shade200 = Color(0xFFA6EDB7);
  static const Color shade300 = Color(0xFF84E19E);
  static const Color shade400 = Color(0xFF6AD286);
  static const Color shade500 = Color(0xFF34A853);
  static const Color shade600 = Color(0xFF229140);
  static const Color shade700 = Color(0xFF317C45);
  static const Color shade800 = Color(0xFF1A5F2C);
  static const Color shade900 = Color(0xFF083214);
  static const Color shade950 = Color(0xFF02210B);
}

/// Dikkat gerektiren durum.
abstract final class AppWarning {
  static const Color shade50 = Color(0xFFFFF7EA);
  static const Color shade100 = Color(0xFFFEE7BC);
  static const Color shade200 = Color(0xFFFEDB9C);
  static const Color shade300 = Color(0xFFFDD07D);
  static const Color shade400 = Color(0xFFFEC864);
  static const Color shade500 = Color(0xFFF1B31F);
  static const Color shade600 = Color(0xFFBE8C12);
  static const Color shade700 = Color(0xFF986A18);
  static const Color shade800 = Color(0xFF7C5812);
  static const Color shade900 = Color(0xFF51380C);
  static const Color shade950 = Color(0xFF251803);
}

/// Hata ve yıkıcı eylem.
abstract final class AppError {
  static const Color shade50 = Color(0xFFFFEBE9);
  static const Color shade100 = Color(0xFFFFC4BF);
  static const Color shade200 = Color(0xFFFFA59B);
  static const Color shade300 = Color(0xFFFD8B7D);
  static const Color shade400 = Color(0xFFFF7466);
  static const Color shade500 = Color(0xFFF2331F);
  static const Color shade600 = Color(0xFFBE2414);
  static const Color shade700 = Color(0xFF972517);
  static const Color shade800 = Color(0xFF7D1C12);
  static const Color shade900 = Color(0xFF51120C);
  static const Color shade950 = Color(0xFF240703);
}
