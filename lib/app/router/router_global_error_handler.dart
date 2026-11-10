import 'package:flutter_mobx_structure/core/network/interceptors/global_error_handler.dart';
import 'package:flutter_mobx_structure/features/error/error_routes.dart';
import 'package:flutter_mobx_structure/core/enums/app_error_enums.dart';
import 'package:flutter_mobx_structure/app/router/app_router.dart';

import 'package:injectable/injectable.dart';

/// Sayfadan bağımsız ağ hatalarını (oturum düştü, bakım) hata sayfasına yönlendirir.
@LazySingleton(as: GlobalErrorHandler)
class RouterGlobalErrorHandler implements GlobalErrorHandler {
  final AppRouter _appRouter;

  RouterGlobalErrorHandler(this._appRouter);

  @override
  Future<void> handle(AppErrorEnums type) async {
    final router = _appRouter.router;
    final currentPath = router.routerDelegate.currentConfiguration.uri.path;
    if (currentPath.startsWith(ErrorRoutes.path)) return;

    router.go(ErrorRoutes.location(type));
  }
}
