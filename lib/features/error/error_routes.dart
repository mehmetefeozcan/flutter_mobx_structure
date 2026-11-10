import 'package:flutter_mobx_structure/core/network/global_error.dart';
import 'package:flutter_mobx_structure/features/error/view/error_view.dart';

import 'package:go_router/go_router.dart';

abstract final class ErrorRoutes {
  static const path = '/error';
  static const _param = 'type';

  static String location(GlobalError error) => '$path/${error.name}';

  static final List<RouteBase> routes = [
    GoRoute(
      path: '$path/:$_param',
      // Bilinmeyen tür (ör. elle yazılmış URL) giriş noktasına döner.
      redirect: (context, state) => _parse(state) == null ? '/' : null,
      builder: (context, state) => ErrorView(error: _parse(state)!),
    ),
  ];

  static GlobalError? _parse(GoRouterState state) =>
      GlobalError.values.asNameMap()[state.pathParameters[_param]];
}
