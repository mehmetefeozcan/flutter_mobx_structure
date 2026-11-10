import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

abstract final class AppFonts {
  static final Map<(TextStyle, FontWeight?), TextStyle> _cache = {};

  static TextStyle resolve(TextStyle style, {FontWeight? weight}) {
    return _cache.putIfAbsent((
      style,
      weight,
    ), () => GoogleFonts.geist(textStyle: style, fontWeight: weight));
  }
}
