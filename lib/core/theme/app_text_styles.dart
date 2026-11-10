import 'package:flutter_mobx_structure/core/theme/app_fonts.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

abstract final class AppTextStyles {
  /// Büyük vurgu metinleri (ör. avatar baş harfi). Varsayılan: bold.
  static TextStyle get display40 => AppFonts.resolve(
    TextStyle(fontSize: 40.sp, height: 42 / 40, fontWeight: FontWeight.w700),
  );

  // Başlıklar. Varsayılan: semiBold.
  static TextStyle get title30 => AppFonts.resolve(
    TextStyle(fontSize: 30.sp, height: 36 / 30, fontWeight: FontWeight.w600),
  );
  static TextStyle get title28 =>
      AppFonts.resolve(TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600));
  static TextStyle get title24 =>
      AppFonts.resolve(TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600));
  static TextStyle get title20 =>
      AppFonts.resolve(TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600));
  static TextStyle get title17 =>
      AppFonts.resolve(TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600));

  // Ana metin, buton yazıları, liste satırları. Varsayılan: regular.
  static TextStyle get body16 => AppFonts.resolve(
    TextStyle(fontSize: 16.sp, height: 22 / 16, fontWeight: FontWeight.w400),
  );
  static TextStyle get body15 =>
      AppFonts.resolve(TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400));
  static TextStyle get body14 =>
      AppFonts.resolve(TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400));

  // Meta bilgi, tarih, alt metin, chip yazıları. Varsayılan: regular.
  static TextStyle get caption13 =>
      AppFonts.resolve(TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400));
  static TextStyle get caption12 =>
      AppFonts.resolve(TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400));

  /// Bölüm etiketleri. `TextStyle`'da büyük harf özelliği yoktur: metni
  /// `Text(label.toUpperCase(), style: AppTextStyles.overline12)` şeklinde ver.
  /// Harf aralığı %6 (12 * 0.06) ve boyutla birlikte ölçeklenir. Varsayılan: semiBold.
  static TextStyle get overline12 => AppFonts.resolve(
    TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.72.sp,
    ),
  );

  // Tab bar, rozet, küçük etiketler. Varsayılan: regular.
  static TextStyle get label11 =>
      AppFonts.resolve(TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w400));

  // Bildirim rozetindeki sayı gibi en küçük metinler. Varsayılan: regular.
  static TextStyle get micro10 =>
      AppFonts.resolve(TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400));
}
