import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

/// Oturum token'ını güvenli depoda saklar. Token bellekte de tutulur; her
/// istekte diskten okunmaz.
@preResolve
@singleton
class AuthStorage {
  static const _tokenKey = 'auth_token';

  final FlutterSecureStorage _storage;
  String? _token;

  AuthStorage._(this._storage, this._token);

  @factoryMethod
  static Future<AuthStorage> create(FlutterSecureStorage storage) async {
    final token = await storage.read(key: _tokenKey);
    return AuthStorage._(storage, token);
  }

  String? get token => _token;
  bool get hasSession => _token != null;

  Future<void> saveSession(String token) async {
    _token = token;
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<void> clearSession() async {
    _token = null;
    await _storage.delete(key: _tokenKey);
  }
}
