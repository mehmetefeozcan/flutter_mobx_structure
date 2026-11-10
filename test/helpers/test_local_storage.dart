import 'package:flutter_mobx_structure/core/storage/local_storage.dart';

import 'package:hive_ce/hive.dart';

import 'dart:io';

/// Geçici dizinde gerçek Hive box'ları açar. `setUpAll` içinde çağır
/// (`testWidgets` içinde dosya G/Ç sahte zamanda takılır).
Future<({LocalStorage storage, Future<void> Function() dispose})>
openTestStorage() async {
  final dir = Directory.systemTemp.createTempSync('hive_test_');
  Hive.init(dir.path);
  final storage = LocalStorage(
    await Hive.openBox<dynamic>(LocalStorage.settingsBoxName),
    await Hive.openBox<dynamic>(LocalStorage.secureBoxName),
  );
  return (
    storage: storage,
    dispose: () async {
      await Hive.close();
      dir.deleteSync(recursive: true);
    },
  );
}
