import 'package:flutter_mobx_structure/core/theme/app_color_tokens.dart';

import 'package:flutter/material.dart';

/// Renkler için tek yol `context.colors`. `ColorScheme` yalnızca Material
/// bileşenlerinin iç renklendirmesi içindir; gerekirse `context.theme.colorScheme`.
extension ContextThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;

  /// Anlamsal renk token'ları (açık/koyu temaya göre).
  AppColorTokens get colors => theme.extension<AppColorTokens>()!;
}
