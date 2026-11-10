import 'package:flutter_mobx_structure/features/splash/view/splash_view.dart';

import 'package:go_router/go_router.dart';

abstract final class SplashRoutes {
  static const path = '/';

  static final List<RouteBase> routes = [
    GoRoute(path: path, builder: (context, state) => const SplashView()),
  ];
}
