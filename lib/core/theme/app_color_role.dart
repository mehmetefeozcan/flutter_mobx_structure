import 'package:flutter/material.dart';

/// Bir renk rolünün dört hâli: ana ton, basılı hâl, düşük vurgulu zemin ve
/// ana tonun üstüne konan içerik rengi (metin/ikon).
///
/// Marka, ikincil, vurgu ve durum renkleri (success/warning/error) aynı şekle
/// sahip olduğu için bileşenler hepsini aynı biçimde okur:
/// `context.colors.brand.main`, `context.colors.error.pale`.
@immutable
class AppColorRole {
  const AppColorRole({
    required this.main,
    required this.pressed,
    required this.pale,
    required this.on,
  });

  /// Dolgu ve vurgu rengi (buton arka planı, rozet, ikon).
  final Color main;

  /// Basılı/aktif hâl.
  final Color pressed;

  /// Düşük vurgulu zemin (bilgi şeridi, seçili satır, rozet zemini).
  final Color pale;

  /// [main] üzerindeki metin ve ikon rengi.
  final Color on;

  AppColorRole copyWith({Color? main, Color? pressed, Color? pale, Color? on}) {
    return AppColorRole(
      main: main ?? this.main,
      pressed: pressed ?? this.pressed,
      pale: pale ?? this.pale,
      on: on ?? this.on,
    );
  }

  static AppColorRole lerp(AppColorRole a, AppColorRole b, double t) {
    return AppColorRole(
      main: Color.lerp(a.main, b.main, t)!,
      pressed: Color.lerp(a.pressed, b.pressed, t)!,
      pale: Color.lerp(a.pale, b.pale, t)!,
      on: Color.lerp(a.on, b.on, t)!,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppColorRole &&
      other.main == main &&
      other.pressed == pressed &&
      other.pale == pale &&
      other.on == on;

  @override
  int get hashCode => Object.hash(main, pressed, pale, on);
}
