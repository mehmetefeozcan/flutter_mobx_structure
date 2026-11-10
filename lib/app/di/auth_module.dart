import 'package:flutter_mobx_structure/core/network/auth/stored_token_provider.dart';
import 'package:flutter_mobx_structure/core/network/auth/token_provider.dart';

import 'package:injectable/injectable.dart';

/// Ağ katmanının kullanacağı [TokenProvider]'ın seçildiği TEK nokta.
///
/// Varsayılan: token'ı uygulama saklar ([StoredTokenProvider], şifreli Hive).
///
/// Token'ı Firebase yönetiyorsa bu metot kendi uygulamanı döndürsün
/// (`firebase_auth` bağımlılığı hedef projede eklenir, şablonda yoktur):
///
/// ```dart
/// class FirebaseTokenProvider implements TokenProvider {
///   @override
///   Future<String?> getToken() async =>
///       FirebaseAuth.instance.currentUser?.getIdToken(); // süresi dolunca kendisi yeniler
///
///   @override
///   Future<void> onSessionExpired() => FirebaseAuth.instance.signOut();
/// }
/// ```
///
/// ve `tokenProvider(...)` içinde `return FirebaseTokenProvider();` yazılır.
@module
abstract class AuthModule {
  @lazySingleton
  TokenProvider tokenProvider(StoredTokenProvider stored) => stored;
}
