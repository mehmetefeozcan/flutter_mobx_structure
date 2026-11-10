import 'package:flutter_mobx_structure/core/extensions/text_style_weight_extension.dart';
import 'package:flutter_mobx_structure/core/theme/app_text_styles.dart';

import 'package:flutter/material.dart';

abstract final class AppTextTheme {
  static TextTheme build() => TextTheme(
    displayLarge: AppTextStyles.display40,
    displayMedium: AppTextStyles.display40.semiBold,
    displaySmall: AppTextStyles.title30,
    headlineLarge: AppTextStyles.title30,
    headlineMedium: AppTextStyles.title28,
    headlineSmall: AppTextStyles.title24,
    titleLarge: AppTextStyles.title20,
    titleMedium: AppTextStyles.title17,
    titleSmall: AppTextStyles.body14.semiBold,
    bodyLarge: AppTextStyles.body16,
    bodyMedium: AppTextStyles.body14,
    bodySmall: AppTextStyles.caption12,
    labelLarge: AppTextStyles.body15.medium,
    labelMedium: AppTextStyles.caption13.medium,
    labelSmall: AppTextStyles.label11.medium,
  );
}
