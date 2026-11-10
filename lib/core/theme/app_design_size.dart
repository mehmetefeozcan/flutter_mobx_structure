import 'package:flutter/material.dart';

abstract final class AppDesignSize {
  /// Tasarım dosyasındaki (Figma) frame boyutu, dp cinsinden. Kendi tasarımına göre değiştir.
  static const Size size = Size(375, 812);

  /// `false` olursa `.sp` ölçekleme yapmaz (yazı boyutları tasarımdaki gibi sabit kalır,
  /// yalnızca sistemin yazı boyutu ayarı geçerli olur). `.w`, `.h`, `.r` etkilenmez.
  /// Tabletlerde yazıların fazla büyümesini istemiyorsan `false` yap.
  static const bool scaleText = true;
}
