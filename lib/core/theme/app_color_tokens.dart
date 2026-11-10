import 'package:flutter_mobx_structure/core/theme/app_color_role.dart';
import 'package:flutter_mobx_structure/core/theme/app_palette.dart';

import 'package:flutter/material.dart';

/// Anlamsal renk token'ları. Bileşenler palet yerine bunları kullanır; açık/koyu
/// tema yalnızca burada ayrışır. `context.colors` ile okunur.
///
/// Gruplar:
/// - Yüzey: [background], [surface], [surfaceRaised], [surfaceInverse]
/// - Kenarlık: [border], [borderStrong], [focusRing]
/// - İçerik: [contentPrimary] … [contentDisabled], [contentInverse], [contentLink]
/// - Roller ([AppColorRole]): [brand], [secondary], [accent], [success],
///   [warning], [error]
/// - Etkileşim: [hoverOverlay], [pressedOverlay], [disabledBackground]
/// - Katman: [scrim]
///
/// Yüzey/kenarlık/metin değerleri tasarımdaki "Theme Tokens" tablosundan: açık
/// tema paletten, koyu tema tablodaki opaklıkların opak karşılıkları. Hex
/// etiketleri küçük olduğundan renkler swatch piksellerinden alındı (±1-2 sapma).
/// Rol renkleri (secondary, accent, pale, pressed, on) tabloda yok; palet
/// rampalarından seçildi ve `on` renkleri en az 4.5:1 kontrast verecek şekilde
/// belirlendi (testle korunuyor).
@immutable
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  const AppColorTokens({
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.surfaceInverse,
    required this.border,
    required this.borderStrong,
    required this.focusRing,
    required this.contentPrimary,
    required this.contentSecondary,
    required this.contentTertiary,
    required this.contentDisabled,
    required this.contentInverse,
    required this.contentLink,
    required this.brand,
    required this.secondary,
    required this.accent,
    required this.success,
    required this.warning,
    required this.error,
    required this.hoverOverlay,
    required this.pressedOverlay,
    required this.disabledBackground,
    required this.scrim,
  });

  final Color background;
  final Color surface;
  final Color surfaceRaised;

  /// Tersine yüzey: snackbar, tooltip gibi zıt renkli katmanlar.
  final Color surfaceInverse;

  final Color border;
  final Color borderStrong;

  /// Odaklanmış öğenin çerçevesi (klavye/erişilebilirlik).
  final Color focusRing;

  final Color contentPrimary;
  final Color contentSecondary;
  final Color contentTertiary;
  final Color contentDisabled;

  /// [surfaceInverse] üzerindeki içerik.
  final Color contentInverse;

  /// Tıklanabilir metin (link); marka renginden okunabilir bir ton.
  final Color contentLink;

  /// Ana marka rengi: birincil eylemler, seçili durum.
  final AppColorRole brand;

  /// İkincil vurgu (mor rampası).
  final AppColorRole secondary;

  /// Üçüncül/dikkat çekici vurgu (coral rampası).
  final AppColorRole accent;

  final AppColorRole success;
  final AppColorRole warning;
  final AppColorRole error;

  /// Üzerine gelinen öğe için yarı saydam katman (içerik renginde).
  final Color hoverOverlay;

  /// Basılı öğe için yarı saydam katman.
  final Color pressedOverlay;

  /// Devre dışı bileşen zemini.
  final Color disabledBackground;

  final Color scrim;

  /// Açık tema: yüzeyler ve metinler paletteki nötr (gray) rampasından.
  static const AppColorTokens light = AppColorTokens(
    background: AppGray.shade50,
    surface: AppBaseColors.white,
    surfaceRaised: AppGray.shade100,
    surfaceInverse: AppGray.shade900,
    border: AppGray.shade200,
    borderStrong: AppGray.shade300,
    focusRing: AppOrange.shade500,
    contentPrimary: AppGray.shade900,
    contentSecondary: AppGray.shade600,
    contentTertiary: AppGray.shade500,
    contentDisabled: AppGray.shade400,
    contentInverse: AppGray.shade50,
    contentLink: AppOrange.shade700,
    brand: AppColorRole(
      main: AppOrange.shade500,
      pressed: AppOrange.shade600,
      pale: AppOrange.shade100,
      on: AppGray.shade950,
    ),
    secondary: AppColorRole(
      main: AppPurple.shade500,
      pressed: AppPurple.shade600,
      pale: AppPurple.shade100,
      on: AppBaseColors.white,
    ),
    accent: AppColorRole(
      main: AppCoral.shade600,
      pressed: AppCoral.shade700,
      pale: AppCoral.shade100,
      on: AppGray.shade950,
    ),
    success: AppColorRole(
      main: AppSuccess.shade500,
      pressed: AppSuccess.shade600,
      pale: Color(0xFFD9EBE0),
      on: AppGray.shade950,
    ),
    warning: AppColorRole(
      main: AppWarning.shade500,
      pressed: AppWarning.shade600,
      pale: AppWarning.shade100,
      on: AppGray.shade950,
    ),
    error: AppColorRole(
      main: AppError.shade500,
      pressed: AppError.shade600,
      pale: AppError.shade100,
      on: AppGray.shade950,
    ),
    hoverOverlay: Color(0x1418181A), // içerik rengi %8
    pressedOverlay: Color(0x1F18181A), // içerik rengi %12
    disabledBackground: AppGray.shade100,
    scrim: Color(0x66000000), // siyah %40
  );

  /// Koyu tema: yüzey, kenarlık ve metin tonları tasarımda beyazın arka plan
  /// üzerindeki opaklığı (yüzey %8, yükseltilmiş %9, kenarlık %14, güçlü kenarlık
  /// %25, ikincil metin %70, üçüncül %50, devre dışı %35). Yarı saydam yüzeyler
  /// üstteki katmanı gösterdiği için opak karşılıkları kullanıldı.
  static const AppColorTokens dark = AppColorTokens(
    background: Color(0xFF0B0E0D),
    surface: Color(0xFF1E2021),
    surfaceRaised: Color(0xFF212425),
    surfaceInverse: AppGray.shade100,
    border: Color(0xFF2D2F31),
    borderStrong: Color(0xFF484A4B),
    focusRing: AppOrange.shade500,
    contentPrimary: AppBaseColors.white,
    contentSecondary: Color(0xFFB4B6B8),
    contentTertiary: Color(0xFF858789),
    contentDisabled: Color(0xFF616262),
    contentInverse: AppGray.shade900,
    contentLink: AppOrange.shade400,
    brand: AppColorRole(
      main: AppOrange.shade500,
      pressed: AppOrange.shade400,
      pale: AppOrange.shade950,
      on: AppGray.shade950,
    ),
    secondary: AppColorRole(
      main: AppPurple.shade400,
      pressed: AppPurple.shade300,
      pale: AppPurple.shade900,
      on: AppGray.shade950,
    ),
    accent: AppColorRole(
      main: AppCoral.shade400,
      pressed: AppCoral.shade300,
      pale: AppCoral.shade950,
      on: AppGray.shade950,
    ),
    success: AppColorRole(
      main: AppSuccess.shade400,
      pressed: AppSuccess.shade300,
      pale: Color(0xFF13241E),
      on: AppGray.shade950,
    ),
    warning: AppColorRole(
      main: AppWarning.shade400,
      pressed: AppWarning.shade300,
      pale: AppWarning.shade950,
      on: AppGray.shade950,
    ),
    error: AppColorRole(
      main: AppError.shade400,
      pressed: AppError.shade300,
      pale: AppError.shade950,
      on: AppGray.shade950,
    ),
    hoverOverlay: Color(0x14FFFFFF), // beyaz %8
    pressedOverlay: Color(0x1FFFFFFF), // beyaz %12
    disabledBackground: Color(0xFF212425),
    scrim: Color(0x99000000), // siyah %60
  );

  @override
  AppColorTokens copyWith({
    Color? background,
    Color? surface,
    Color? surfaceRaised,
    Color? surfaceInverse,
    Color? border,
    Color? borderStrong,
    Color? focusRing,
    Color? contentPrimary,
    Color? contentSecondary,
    Color? contentTertiary,
    Color? contentDisabled,
    Color? contentInverse,
    Color? contentLink,
    AppColorRole? brand,
    AppColorRole? secondary,
    AppColorRole? accent,
    AppColorRole? success,
    AppColorRole? warning,
    AppColorRole? error,
    Color? hoverOverlay,
    Color? pressedOverlay,
    Color? disabledBackground,
    Color? scrim,
  }) {
    return AppColorTokens(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceInverse: surfaceInverse ?? this.surfaceInverse,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      focusRing: focusRing ?? this.focusRing,
      contentPrimary: contentPrimary ?? this.contentPrimary,
      contentSecondary: contentSecondary ?? this.contentSecondary,
      contentTertiary: contentTertiary ?? this.contentTertiary,
      contentDisabled: contentDisabled ?? this.contentDisabled,
      contentInverse: contentInverse ?? this.contentInverse,
      contentLink: contentLink ?? this.contentLink,
      brand: brand ?? this.brand,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      hoverOverlay: hoverOverlay ?? this.hoverOverlay,
      pressedOverlay: pressedOverlay ?? this.pressedOverlay,
      disabledBackground: disabledBackground ?? this.disabledBackground,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  AppColorTokens lerp(AppColorTokens? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    AppColorRole role(AppColorRole a, AppColorRole b) =>
        AppColorRole.lerp(a, b, t);
    return AppColorTokens(
      background: mix(background, other.background),
      surface: mix(surface, other.surface),
      surfaceRaised: mix(surfaceRaised, other.surfaceRaised),
      surfaceInverse: mix(surfaceInverse, other.surfaceInverse),
      border: mix(border, other.border),
      borderStrong: mix(borderStrong, other.borderStrong),
      focusRing: mix(focusRing, other.focusRing),
      contentPrimary: mix(contentPrimary, other.contentPrimary),
      contentSecondary: mix(contentSecondary, other.contentSecondary),
      contentTertiary: mix(contentTertiary, other.contentTertiary),
      contentDisabled: mix(contentDisabled, other.contentDisabled),
      contentInverse: mix(contentInverse, other.contentInverse),
      contentLink: mix(contentLink, other.contentLink),
      brand: role(brand, other.brand),
      secondary: role(secondary, other.secondary),
      accent: role(accent, other.accent),
      success: role(success, other.success),
      warning: role(warning, other.warning),
      error: role(error, other.error),
      hoverOverlay: mix(hoverOverlay, other.hoverOverlay),
      pressedOverlay: mix(pressedOverlay, other.pressedOverlay),
      disabledBackground: mix(disabledBackground, other.disabledBackground),
      scrim: mix(scrim, other.scrim),
    );
  }
}
