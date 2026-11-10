import 'package:flutter_mobx_structure/features/error/error_routes.dart';
import 'package:flutter_mobx_structure/features/splash/splash_routes.dart';

import 'package:injectable/injectable.dart';
import 'package:go_router/go_router.dart';

/// Feature'ların kendi tanımladığı rotaları birleştirir.
@lazySingleton
class AppRouter {
  late final GoRouter router = GoRouter(
    initialLocation: SplashRoutes.path,
    routes: [...SplashRoutes.routes, ...ErrorRoutes.routes],
  );
}
