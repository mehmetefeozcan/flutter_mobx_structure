import 'package:flutter_mobx_structure/core/theme/app_color_tokens.dart';
import 'package:flutter_mobx_structure/core/theme/text_theme.dart';

import 'package:flutter/material.dart';

/// Açık/koyu `ThemeData`. Metin ölçeği `.sp` kullandığı için `ScreenUtilInit`
/// başladıktan sonra (MaterialApp builder'ında) çağrılmalı.
///
/// Material bileşenleri `ColorScheme` üzerinden renklenir; token'lar buraya
/// eşlenir: primary=brand, secondary=secondary, tertiary=accent, error=error.
abstract final class AppTheme {
  static ThemeData light() => _build(AppColorTokens.light, Brightness.light);

  static ThemeData dark() => _build(AppColorTokens.dark, Brightness.dark);

  static ThemeData _build(AppColorTokens tokens, Brightness brightness) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: tokens.brand.main,
      onPrimary: tokens.brand.on,
      primaryContainer: tokens.brand.pale,
      onPrimaryContainer: tokens.contentPrimary,
      secondary: tokens.secondary.main,
      onSecondary: tokens.secondary.on,
      secondaryContainer: tokens.secondary.pale,
      onSecondaryContainer: tokens.contentPrimary,
      tertiary: tokens.accent.main,
      onTertiary: tokens.accent.on,
      tertiaryContainer: tokens.accent.pale,
      onTertiaryContainer: tokens.contentPrimary,
      error: tokens.error.main,
      onError: tokens.error.on,
      errorContainer: tokens.error.pale,
      onErrorContainer: tokens.contentPrimary,
      surface: tokens.surface,
      onSurface: tokens.contentPrimary,
      surfaceContainerHighest: tokens.surfaceRaised,
      onSurfaceVariant: tokens.contentSecondary,
      outline: tokens.borderStrong,
      outlineVariant: tokens.border,
      inverseSurface: tokens.surfaceInverse,
      onInverseSurface: tokens.contentInverse,
      inversePrimary: tokens.brand.pressed,
      scrim: tokens.scrim,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: tokens.background,
      textTheme: AppTextTheme.build(),
      focusColor: tokens.focusRing,
      hoverColor: tokens.hoverOverlay,
      highlightColor: tokens.pressedOverlay,
      disabledColor: tokens.contentDisabled,
      extensions: [tokens],
    );
  }
}
