import 'package:flutter/painting.dart';

abstract final class AppShadows {
  static const List<BoxShadow> xs = [
    BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> s = [
    BoxShadow(color: Color(0x14000000), blurRadius: 4, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> m = [
    BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> l = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 16, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> xl = [
    BoxShadow(color: Color(0x1F000000), blurRadius: 32, offset: Offset(0, 16)),
  ];
}
