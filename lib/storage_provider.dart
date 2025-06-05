import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:riverpod_sqflite/riverpod_sqflite.dart';

final storageProvider = FutureProvider<Storage<String, String>>((ref) async {
  final dir = await path_provider.getApplicationDocumentsDirectory();
  final dbPath = path.join(dir.path, 'db.db');
  final storage = await JsonSqFliteStorage.open(dbPath);
  ref
    ..onDispose(storage.close)
    ..keepAlive();

  return storage;
});
