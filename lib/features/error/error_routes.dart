import 'package:flutter_mobx_structure/core/enums/app_error_enums.dart';
import 'package:flutter_mobx_structure/features/error/view/error_view.dart';

import 'package:go_router/go_router.dart';

abstract final class ErrorRoutes {
  static const path = '/error';
  static const _typeParam = 'type';

  static String location(AppErrorEnums type) => '$path/${type.name}';

  static final List<RouteBase> routes = [
    GoRoute(
      path: '$path/:$_typeParam',
      builder: (context, state) {
        final type =
            AppErrorEnums.values.asNameMap()[state.pathParameters[_typeParam]] ??
            AppErrorEnums.wentWrong;
        return ErrorView(type: type);
      },
    ),
  ];
}
