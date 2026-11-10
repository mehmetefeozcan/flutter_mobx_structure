import 'package:flutter_mobx_structure/app/di/injector.config.dart';

import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

/// `@injectable`, `@lazySingleton` vb. ile işaretli tüm sınıfları kaydeder.
/// Üretim: `dart run build_runner build`
@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();
}
