// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:flutter_mobx_structure/app/di/network_module.dart' as _i645;
import 'package:flutter_mobx_structure/app/router/app_router.dart' as _i146;
import 'package:flutter_mobx_structure/app/router/router_global_error_handler.dart'
    as _i639;
import 'package:flutter_mobx_structure/core/network/custom_dio_service.dart'
    as _i259;
import 'package:flutter_mobx_structure/core/network/interceptors/global_error_handler.dart'
    as _i570;
import 'package:flutter_mobx_structure/core/storage/auth_storage.dart'
    as _i1017;
import 'package:flutter_mobx_structure/core/storage/storage_module.dart'
    as _i568;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final storageModule = _$StorageModule();
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i146.AppRouter>(() => _i146.AppRouter());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => storageModule.secureStorage,
    );
    await gh.singletonAsync<_i1017.AuthStorage>(
      () => _i1017.AuthStorage.create(gh<_i558.FlutterSecureStorage>()),
      preResolve: true,
    );
    gh.lazySingleton<_i570.GlobalErrorHandler>(
      () => _i639.RouterGlobalErrorHandler(gh<_i146.AppRouter>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.dio(
        gh<_i1017.AuthStorage>(),
        gh<_i570.GlobalErrorHandler>(),
      ),
    );
    gh.lazySingleton<_i259.CustomDioService>(
      () => _i259.CustomDioService(gh<_i361.Dio>()),
    );
    return this;
  }
}

class _$StorageModule extends _i568.StorageModule {}

class _$NetworkModule extends _i645.NetworkModule {}
