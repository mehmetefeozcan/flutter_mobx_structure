import 'package:flutter_mobx_structure/core/extensions/extensions.dart';
import 'package:flutter_mobx_structure/core/theme/app_design_size.dart';
import 'package:flutter_mobx_structure/core/theme/app_text_styles.dart';
import 'package:flutter_mobx_structure/core/theme/text_theme.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

/// Stiller `.sp` kullandığı için `ScreenUtilInit` gerekir. Ekranı [size] yapar ve
/// uygulamanın kullandığı ayarlarla başlatır; dönen context tema ve ölçek içindir.
Future<BuildContext> _pumpScaled(
  WidgetTester tester, {
  Size size = const Size(375, 812),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  late BuildContext captured;
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: AppDesignSize.size,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MaterialApp(
        theme: ThemeData(useMaterial3: true, textTheme: AppTextTheme.build()),
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
  testWidgets('her stil Geist fontlu ve renksiz (renk temadan gelir)', (
    tester,
  ) async {
    await _pumpScaled(tester);

    final styles = [
      AppTextStyles.display40,
      AppTextStyles.title30,
      AppTextStyles.title28,
      AppTextStyles.title24,
      AppTextStyles.title20,
      AppTextStyles.title17,
      AppTextStyles.body16,
      AppTextStyles.body15,
      AppTextStyles.body14,
      AppTextStyles.caption13,
      AppTextStyles.caption12,
      AppTextStyles.overline12,
      AppTextStyles.label11,
      AppTextStyles.micro10,
    ];

    for (final style in styles) {
      expect(style.fontFamily, contains('Geist'));
      expect(
        style.fontWeight,
        isNotNull,
        reason: 'ağırlık font dosyasını seçer',
      );
      expect(style.color, isNull);
    }
  });

  group('ekrana göre ölçekleme (.sp)', () {
    testWidgets(
      'ekran tasarımın 2 katıysa boyut ve harf aralığı 2 katına çıkar, '
      'satır yüksekliği çarpanı değişmez',
      (tester) async {
        await _pumpScaled(tester, size: const Size(750, 1624));

        expect(AppTextStyles.body14.fontSize, closeTo(28, 1e-9));
        expect(AppTextStyles.title30.fontSize, closeTo(60, 1e-9));
        expect(AppTextStyles.overline12.letterSpacing, closeTo(1.44, 1e-9));
        expect(AppTextStyles.body16.height, closeTo(22 / 16, 1e-9));
      },
    );

    testWidgets('minTextAdapt: uzun ekranda yazılar yüksekliğe göre şişmez', (
      tester,
    ) async {
      // Genişlik tasarımla aynı, yükseklik 2 kat: ölçek min(1, 2) = 1.
      await _pumpScaled(tester, size: const Size(375, 1624));

      expect(AppTextStyles.body14.fontSize, closeTo(14, 1e-9));
    });

    testWidgets('boyut değişince önbellek eski değeri döndürmez', (
      tester,
    ) async {
      await _pumpScaled(tester);
      final small = AppTextStyles.body14.fontSize;

      await _pumpScaled(tester, size: const Size(750, 1624));
      final large = AppTextStyles.body14.fontSize;

      expect(small, 14);
      expect(large, closeTo(28, 1e-9));
    });

    testWidgets('aynı ölçekte aynı çağrı aynı örneği döndürür (önbellek)', (
      tester,
    ) async {
      await _pumpScaled(tester);

      expect(identical(AppTextStyles.body14, AppTextStyles.body14), isTrue);
      expect(
        identical(AppTextStyles.body14.medium, AppTextStyles.body14.medium),
        isTrue,
      );
    });
  });

  group('TextStyleWeightExtension', () {
    testWidgets('ağırlığı değiştirir, boyutu ve satır yüksekliğini korur', (
      tester,
    ) async {
      await _pumpScaled(tester);
      final medium = AppTextStyles.body16.medium;

      expect(medium.fontWeight, FontWeight.w500);
      expect(AppTextStyles.body16.semiBold.fontWeight, FontWeight.w600);
      expect(AppTextStyles.body16.bold.fontWeight, FontWeight.w700);
      expect(AppTextStyles.title30.regular.fontWeight, FontWeight.w400);
      expect(medium.fontSize, 16);
      expect(medium.height, closeTo(22 / 16, 1e-9));
    });

    testWidgets('font ailesini ağırlığa göre yeniden çözer (copyWith farkı)', (
      tester,
    ) async {
      await _pumpScaled(tester);
      final regular = AppTextStyles.body14;
      final medium = AppTextStyles.body14.medium;
      final naive = AppTextStyles.body14.copyWith(fontWeight: FontWeight.w500);

      expect(medium.fontFamily, isNot(regular.fontFamily));
      expect(
        naive.fontFamily,
        regular.fontFamily,
        reason: 'copyWith aileyi değiştirmez; yanlış font dosyası kalır',
      );
    });
  });

  testWidgets('TextTheme 15 slotun hepsini ölçekten doldurur', (tester) async {
    await _pumpScaled(tester);

    final t = AppTextTheme.build();
    final slots = <String, TextStyle?>{
      'displayLarge': t.displayLarge,
      'displayMedium': t.displayMedium,
      'displaySmall': t.displaySmall,
      'headlineLarge': t.headlineLarge,
      'headlineMedium': t.headlineMedium,
      'headlineSmall': t.headlineSmall,
      'titleLarge': t.titleLarge,
      'titleMedium': t.titleMedium,
      'titleSmall': t.titleSmall,
      'bodyLarge': t.bodyLarge,
      'bodyMedium': t.bodyMedium,
      'bodySmall': t.bodySmall,
      'labelLarge': t.labelLarge,
      'labelMedium': t.labelMedium,
      'labelSmall': t.labelSmall,
    };

    for (final entry in slots.entries) {
      expect(entry.value, isNotNull, reason: entry.key);
      expect(entry.value!.fontFamily, contains('Geist'), reason: entry.key);
    }

    expect(t.bodyLarge!.fontSize, 16);
    expect(t.bodyMedium!.fontSize, 14);
    expect(t.bodySmall!.fontSize, 12);
    expect(t.titleLarge!.fontSize, 20);
    expect(t.labelLarge!.fontSize, 15);
    expect(t.labelLarge!.fontWeight, FontWeight.w500);
    expect(t.titleSmall!.fontWeight, FontWeight.w600);
  });

  testWidgets('context extension ları tema değerlerini döndürür', (
    tester,
  ) async {
    final context = await _pumpScaled(tester);

    expect(context.textTheme.bodyMedium!.fontSize, 14);
    expect(context.textTheme.titleLarge!.fontSize, 20);
    expect(
      context.textTheme.bodyMedium!.color,
      isNotNull,
      reason: 'ThemeData rengi brightness e göre varsayılan tipografiden ekler',
    );
  });

  testWidgets('extensions.dart .w .h .r .sp uzantılarını da sunar', (
    tester,
  ) async {
    await _pumpScaled(tester, size: const Size(750, 1624));

    expect(16.w, closeTo(32, 1e-9));
    expect(16.h, closeTo(32, 1e-9));
    expect(16.sp, closeTo(32, 1e-9));
    expect(EdgeInsets.all(8).r.left, closeTo(16, 1e-9));
  });
}
