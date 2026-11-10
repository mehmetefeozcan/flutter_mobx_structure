import 'package:flutter_mobx_structure/core/theme/app_color_tokens.dart';

import 'package:flutter/material.dart';

extension ContextThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  /// Anlamsal renk token'ları (açık/koyu temaya göre).
  AppColorTokens get colors => theme.extension<AppColorTokens>()!;
}
