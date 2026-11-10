// project imports
import 'package:flutter_mobx_structure/app/di/injector.dart';
import 'package:flutter_mobx_structure/app/router/app_router.dart';
import 'package:flutter_mobx_structure/app/app.dart';
// third party imports
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  runApp(MyApp(router: getIt<AppRouter>().router));
}
