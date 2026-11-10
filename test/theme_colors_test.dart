import 'package:flutter_mobx_structure/core/extensions/extensions.dart';
import 'package:flutter_mobx_structure/core/theme/app_color_role.dart';
import 'package:flutter_mobx_structure/core/theme/app_color_tokens.dart';
import 'package:flutter_mobx_structure/core/theme/app_palette.dart';
import 'package:flutter_mobx_structure/core/theme/app_theme.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

Future<BuildContext> _pump(WidgetTester tester, ThemeMode mode) async {
  late BuildContext captured;
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(800, 600),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: mode,
        home: Builder(
          builder: (context) {
            captured = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
  return captured;
}

void main() {
  testWidgets('açık temada token ve ColorScheme açık değerleri taşır', (
    tester,
  ) async {
    final context = await _pump(tester, ThemeMode.light);

    expect(context.colors, AppColorTokens.light);
    expect(context.colorScheme.brightness, Brightness.light);
    expect(context.colorScheme.primary, AppOrange.shade500);
    expect(context.colors.brand.main, AppOrange.shade500);
    expect(context.theme.scaffoldBackgroundColor, AppGray.shade50);
  });

  testWidgets('koyu temada token ve ColorScheme koyu değerleri taşır', (
    tester,
  ) async {
    final context = await _pump(tester, ThemeMode.dark);

    expect(context.colors, AppColorTokens.dark);
    expect(context.colorScheme.brightness, Brightness.dark);
    expect(context.colors.contentPrimary, AppBaseColors.white);
    expect(context.theme.scaffoldBackgroundColor, const Color(0xFF0B0E0D));
  });

  test('lerp uçlarda tokenları, ortada karışımı verir', () {
    const a = AppColorTokens.light;
    const b = AppColorTokens.dark;

    expect(a.lerp(b, 0).background, a.background);
    expect(a.lerp(b, 1).background, b.background);
    expect(
      a.lerp(b, 0.5).background,
      Color.lerp(a.background, b.background, 0.5),
    );
    expect(a.lerp(null, 0.5), a);
  });

  test('copyWith yalnızca verilen alanı değiştirir', () {
    final changed = AppColorTokens.light.copyWith(focusRing: AppCoral.shade500);

    expect(changed.focusRing, AppCoral.shade500);
    expect(changed.background, AppColorTokens.light.background);
  });

  group('rol renkleri', () {
    final themes = {'light': AppColorTokens.light, 'dark': AppColorTokens.dark};

    double contrast(Color a, Color b) {
      final la = a.computeLuminance();
      final lb = b.computeLuminance();
      final hi = la > lb ? la : lb;
      final lo = la > lb ? lb : la;
      return (hi + 0.05) / (lo + 0.05);
    }

    for (final entry in themes.entries) {
      final roles = {
        'brand': entry.value.brand,
        'secondary': entry.value.secondary,
        'accent': entry.value.accent,
        'success': entry.value.success,
        'warning': entry.value.warning,
        'error': entry.value.error,
      };
      for (final role in roles.entries) {
        test('${entry.key}/${role.key}: on rengi main üstünde AA kontrast', () {
          expect(
            contrast(role.value.main, role.value.on),
            greaterThanOrEqualTo(4.5),
          );
        });
      }

      test('${entry.key}: ana içerik yüzeyde ve arka planda AA kontrast', () {
        final t = entry.value;
        expect(contrast(t.surface, t.contentPrimary), greaterThanOrEqualTo(7));
        expect(
          contrast(t.background, t.contentPrimary),
          greaterThanOrEqualTo(7),
        );
        expect(
          contrast(t.surface, t.contentSecondary),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          contrast(t.surfaceInverse, t.contentInverse),
          greaterThanOrEqualTo(7),
        );
      });
    }

    test('rol lerp ve eşitlik', () {
      final a = AppColorTokens.light.brand;
      final b = AppColorTokens.dark.brand;

      expect(AppColorRole.lerp(a, b, 0), a);
      expect(AppColorRole.lerp(a, b, 1), b);
      expect(a.copyWith(), a);
      expect(a.hashCode, a.copyWith().hashCode);
    });

    testWidgets('ColorScheme rolleri token rollerine eşlenir', (tester) async {
      final context = await _pump(tester, ThemeMode.light);

      expect(context.colorScheme.secondary, context.colors.secondary.main);
      expect(context.colorScheme.tertiary, context.colors.accent.main);
      expect(context.colorScheme.error, context.colors.error.main);
      expect(context.colorScheme.primaryContainer, context.colors.brand.pale);
    });
  });
}
