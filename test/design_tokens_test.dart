import 'package:flutter_mobx_structure/core/theme/app_blur.dart';
import 'package:flutter_mobx_structure/core/theme/app_radius.dart';
import 'package:flutter_mobx_structure/core/theme/app_shadows.dart';
import 'package:flutter_mobx_structure/core/theme/app_stroke.dart';

import 'package:flutter_test/flutter_test.dart';

void _ascending(List<double> values) {
  for (var i = 1; i < values.length; i++) {
    expect(values[i], greaterThan(values[i - 1]));
  }
}

void main() {
  test('radius, stroke ve blur ölçekleri artan sırada', () {
    _ascending([
      AppRadius.none,
      AppRadius.xs,
      AppRadius.s,
      AppRadius.m,
      AppRadius.l,
      AppRadius.xl,
      AppRadius.xxl,
    ]);
    _ascending([
      AppStroke.none,
      AppStroke.thin,
      AppStroke.medium,
      AppStroke.bold,
    ]);
    _ascending([AppBlur.xs, AppBlur.s, AppBlur.m, AppBlur.l, AppBlur.xl]);
  });

  test('gölgeler yükseldikçe yayılma ve kayma artar', () {
    final levels = [
      AppShadows.xs,
      AppShadows.s,
      AppShadows.m,
      AppShadows.l,
      AppShadows.xl,
    ];
    for (var i = 1; i < levels.length; i++) {
      expect(
        levels[i].first.blurRadius,
        greaterThan(levels[i - 1].first.blurRadius),
      );
      expect(
        levels[i].first.offset.dy,
        greaterThan(levels[i - 1].first.offset.dy),
      );
    }
  });
}
