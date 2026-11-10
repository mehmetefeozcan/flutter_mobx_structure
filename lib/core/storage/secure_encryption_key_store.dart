import 'package:flutter_mobx_structure/core/storage/encryption_key_store.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import 'dart:convert';

@LazySingleton(as: EncryptionKeyStore)
class SecureEncryptionKeyStore implements EncryptionKeyStore {
  static const _keyName = 'hive_encryption_key';

  final FlutterSecureStorage _storage;

  SecureEncryptionKeyStore(this._storage);

  @override
  Future<List<int>> getOrCreateKey() async {
    final stored = await _storage.read(key: _keyName);
    if (stored != null) return base64Url.decode(stored);

    final key = Hive.generateSecureKey();
    await _storage.write(key: _keyName, value: base64Url.encode(key));
    return key;
  }
}
