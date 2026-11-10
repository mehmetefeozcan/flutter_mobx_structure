import 'package:flutter_mobx_structure/app/app.dart';
import 'package:flutter_mobx_structure/app/router/app_router.dart';
import 'package:flutter_mobx_structure/core/network/global_error.dart';
import 'package:flutter_mobx_structure/core/state/language_store.dart';
import 'package:flutter_mobx_structure/core/state/theme_store.dart';
import 'package:flutter_mobx_structure/core/storage/local_storage.dart';
import 'package:flutter_mobx_structure/features/error/error_routes.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/widgets.dart' show Size;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart' show ThemeMode, Theme, Brightness;

import 'helpers/test_local_storage.dart';

void main() {
  late LocalStorage storage;
  late Future<void> Function() dispose;

  setUpAll(() async {
    final opened = await openTestStorage();
    storage = opened.storage;
    dispose = opened.dispose;
  });

  setUp(() => storage.settings.clear());

  tearDownAll(() => dispose());

  MyApp buildApp(AppRouter appRouter, {ThemeStore? themeStore}) => MyApp(
    router: appRouter.router,
    themeStore: themeStore ?? ThemeStore(storage),
    languageStore: LanguageStore(storage),
  );

  testWidgets('açılışta splash gösterilir', (tester) async {
    final appRouter = AppRouter();
    await tester.pumpWidget(buildApp(appRouter));
    await tester.pumpAndSettle();

    expect(find.text('My App'), findsOneWidget);
  });

  testWidgets(
    'MyApp ScreenUtilInit i bağlar: ekran tasarım boyutunun 2 katıysa ölçek 2',
    (tester) async {
      tester.view.physicalSize = const Size(750, 1624);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(buildApp(AppRouter()));
      await tester.pumpAndSettle();

      expect(ScreenUtil().scaleWidth, closeTo(2, 1e-9));
      expect(find.text('My App'), findsOneWidget);
    },
  );

  testWidgets('tema seçimi değişince uygulama yeniden kurulur', (tester) async {
    final themeStore = ThemeStore(storage);
    await tester.pumpWidget(buildApp(AppRouter(), themeStore: themeStore));
    await tester.pumpAndSettle();

    Brightness current() =>
        Theme.of(tester.element(find.text('My App'))).brightness;

    await tester.runAsync(() => themeStore.setThemeMode(ThemeMode.dark));
    await tester.pumpAndSettle();
    expect(current(), Brightness.dark);

    await tester.runAsync(() => themeStore.setThemeMode(ThemeMode.light));
    await tester.pumpAndSettle();
    expect(current(), Brightness.light);
  });

  testWidgets('global hata sayfası her durumda giriş noktasına çıkış verir', (
    tester,
  ) async {
    final appRouter = AppRouter();
    await tester.pumpWidget(buildApp(appRouter));
    await tester.pumpAndSettle();

    appRouter.router.go(ErrorRoutes.location(GlobalError.maintenance));
    await tester.pumpAndSettle();
    expect(find.text('Try again'), findsOneWidget);

    appRouter.router.go(ErrorRoutes.location(GlobalError.sessionExpired));
    await tester.pumpAndSettle();
    expect(
      find.text('Your session has expired. Please sign in again.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('My App'), findsOneWidget);
  });

  testWidgets('bilinmeyen hata türü giriş noktasına yönlenir', (tester) async {
    final appRouter = AppRouter();
    await tester.pumpWidget(buildApp(appRouter));
    await tester.pumpAndSettle();

    appRouter.router.go('${ErrorRoutes.path}/nope');
    await tester.pumpAndSettle();

    expect(find.text('My App'), findsOneWidget);
  });

  test('GlobalError: hangi yanıtlar global ele alınır', () {
    expect(
      GlobalError.fromResponse(statusCode: 401, hadToken: true),
      GlobalError.sessionExpired,
    );
    expect(GlobalError.fromResponse(statusCode: 401, hadToken: false), isNull);
    expect(
      GlobalError.fromResponse(statusCode: 503, hadToken: false),
      GlobalError.maintenance,
    );
    expect(GlobalError.fromResponse(statusCode: 404, hadToken: true), isNull);
  });
}
