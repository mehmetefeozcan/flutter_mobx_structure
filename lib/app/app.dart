import 'package:flutter_mobx_structure/core/extensions/extensions.dart';
import 'package:flutter_mobx_structure/core/l10n/app_localizations.dart';
import 'package:flutter_mobx_structure/core/state/language_store.dart';
import 'package:flutter_mobx_structure/core/state/theme_store.dart';
import 'package:flutter_mobx_structure/core/theme/app_design_size.dart';
import 'package:flutter_mobx_structure/core/theme/app_theme.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.router,
    required this.themeStore,
    required this.languageStore,
  });

  final GoRouter router;
  final ThemeStore themeStore;
  final LanguageStore languageStore;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: AppDesignSize.size,
      // Ölçek, genişlik ve yükseklik oranlarının küçüğü olur: uzun ekranlarda yazılar şişmez.
      minTextAdapt: true,
      splitScreenMode: true,
      ensureScreenSize: true,
      enableScaleText: () => AppDesignSize.scaleText,
      // Tema ölçeğe bağlı olduğu için builder içinde üretilir.
      builder: (context, child) => Observer(
        // Yalnızca tema ve dil seçimi değişince MaterialApp yeniden kurulur.
        builder: (_) => MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeStore.themeMode,
          locale: languageStore.locale,
          onGenerateTitle: (context) => context.l10n.appName,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }
}
