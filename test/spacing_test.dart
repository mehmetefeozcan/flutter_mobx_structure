import 'package:flutter_mobx_structure/core/theme/app_spacing.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('boşluk ölçeği 4px tabanlı ve artan sırada', () {
    const values = <double>[
      AppSpacing.s4,
      AppSpacing.s8,
      AppSpacing.s12,
      AppSpacing.s16,
      AppSpacing.s20,
      AppSpacing.s24,
      AppSpacing.s32,
      AppSpacing.s40,
      AppSpacing.s48,
      AppSpacing.s56,
      AppSpacing.s64,
      AppSpacing.s72,
      AppSpacing.s80,
      AppSpacing.s88,
      AppSpacing.s100,
      AppSpacing.s112,
    ];

    for (var i = 1; i < values.length; i++) {
      expect(values[i], greaterThan(values[i - 1]));
    }
    for (final v in values) {
      expect(v % 4, 0, reason: '$v 4 ün katı olmalı');
    }
  });
}
