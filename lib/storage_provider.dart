import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_sqflite/riverpod_sqflite.dart';

part 'storage_provider.g.dart';

@riverpod
FutureOr<JsonSqFliteStorage> storage(Ref ref) async {
  final dir = await path_provider.getApplicationDocumentsDirectory();
  final dbPath = path.join(dir.path, 'db.db');
  final storage = await JsonSqFliteStorage.open(dbPath);
  ref
    ..onDispose(storage.close)
    ..keepAlive();

  return storage;
}
