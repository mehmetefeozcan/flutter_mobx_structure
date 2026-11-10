import 'package:flutter_mobx_structure/core/theme/app_fonts.dart';

import 'package:flutter/painting.dart';

extension TextStyleWeightExtension on TextStyle {
  TextStyle get regular => AppFonts.resolve(this, weight: FontWeight.w400);
  TextStyle get medium => AppFonts.resolve(this, weight: FontWeight.w500);
  TextStyle get semiBold => AppFonts.resolve(this, weight: FontWeight.w600);
  TextStyle get bold => AppFonts.resolve(this, weight: FontWeight.w700);
}
