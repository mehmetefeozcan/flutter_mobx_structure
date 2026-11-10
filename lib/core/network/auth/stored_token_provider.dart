import 'package:flutter_mobx_structure/core/network/auth/token_provider.dart';
import 'package:flutter_mobx_structure/core/storage/local_storage.dart';

import 'package:injectable/injectable.dart';

/// Token'ı uygulamanın kendisi yönettiği senaryo için [TokenProvider] uygulaması:
/// giriş sonrası token şifreli box'a yazılır ([saveToken]), her istekte okunur,
/// oturum düşünce silinir.
///
/// Token'ı dış bir sistem yönetiyorsa (ör. Firebase) bu sınıf kullanılmaz;
/// bkz. `AuthModule`.
@lazySingleton
class StoredTokenProvider implements TokenProvider {
  static const _tokenKey = 'auth_token';

  final LocalStorage _storage;

  StoredTokenProvider(this._storage);

  bool get hasSession => _storage.secure.get(_tokenKey) != null;

  @override
  Future<String?> getToken() async => _storage.secure.get(_tokenKey) as String?;

  Future<void> saveToken(String token) => _storage.secure.put(_tokenKey, token);

  Future<void> clear() => _storage.secure.delete(_tokenKey);

  @override
  Future<void> onSessionExpired() => clear();
}
