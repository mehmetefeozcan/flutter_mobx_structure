import 'package:flutter_mobx_structure/app/router/app_router.dart';
import 'package:flutter_mobx_structure/core/network/global_error.dart';
import 'package:flutter_mobx_structure/features/error/error_routes.dart';

import 'package:injectable/injectable.dart';

/// Global ağ hatalarını (oturum düştü, bakım) hata sayfasına yönlendirir.
@LazySingleton(as: GlobalErrorHandler)
class RouterGlobalErrorHandler implements GlobalErrorHandler {
  RouterGlobalErrorHandler(this._appRouter);

  final AppRouter _appRouter;

  @override
  Future<void> handle(GlobalError error) async {
    final router = _appRouter.router;
    final currentPath = router.routerDelegate.currentConfiguration.uri.path;
    // Zaten hata sayfasındaysa (ör. aynı anda gelen ikinci 401) tekrar yönlendirme.
    if (currentPath.startsWith(ErrorRoutes.path)) return;
    router.go(ErrorRoutes.location(error));
  }
}
