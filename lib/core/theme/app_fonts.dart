import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

abstract final class AppFonts {
  /// `(stil, ağırlık)` -> çözümlenmiş stil. `TextStyle` değer eşitliğine sahip
  /// olduğu için anahtar olabilir; aynı çağrı aynı örneği döndürür ve her
  /// build'de yeniden hesaplanmaz.
  static final Map<(TextStyle, FontWeight?), TextStyle> _cache = {};

  static TextStyle resolve(TextStyle style, {FontWeight? weight}) {
    return _cache.putIfAbsent((
      style,
      weight,
    ), () => GoogleFonts.geist(textStyle: style, fontWeight: weight));
  }
}
