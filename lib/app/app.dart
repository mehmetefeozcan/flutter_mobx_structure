import 'package:flutter_mobx_structure/core/extensions/extensions.dart';
import 'package:flutter_mobx_structure/core/l10n/app_localizations.dart';
import 'package:flutter_mobx_structure/core/theme/app_design_size.dart';
import 'package:flutter_mobx_structure/core/theme/text_theme.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.router});

  final GoRouter router;

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
      builder: (context, child) => MaterialApp.router(
        routerConfig: router,
        // Geçici: tam `AppTheme` (renkler + ThemeStore) bir sonraki adımda bunun yerini alır.
        theme: ThemeData(useMaterial3: true, textTheme: AppTextTheme.build()),
        onGenerateTitle: (context) => context.l10n.appName,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
