@Timeout(Duration(seconds: 3))
library;

import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:riverpod_sqflite/riverpod_sqflite.dart';
import 'dart:convert' as convert;

class TestNotifier extends FamilyAsyncNotifier<List<int>, int>
    with Persistable<List<int>, String, String> {
  static const delay = Duration(milliseconds: 1);
  // try the following, and the test passes:
  // static const delay = Duration(microseconds: 1);
  static const pageSize = 10;

  @override
  FutureOr<List<int>> build(int page) async {
    final storage = await ref.watch(storageProvider.future);

    await persist(
      key: 'test-$page',
      storage: storage,
      encode: (state) => convert.jsonEncode(state),
      decode: (encoded) {
        final decoded = convert.jsonDecode(encoded) as List<Object?>;
        return decoded.cast<int>();
      },
    );

    if (page == 0) {
      final items = await Future.delayed(delay, () => mock(0));
      return items;
    }

    final lastPage = await ref.watch(testNotifierProvider(page - 1).future);
    if (lastPage.isEmpty) return [];

    final items = await Future.delayed(delay, () => mock(lastPage.last));
    return items;
  }

  List<int> mock(int i) {
    return List.generate(pageSize, (index) => i + index);
  }
}

final testNotifierProvider = AsyncNotifierProvider.autoDispose
    .family<TestNotifier, List<int>, int>(TestNotifier.new);

final storageProvider = FutureProvider<Storage<String, String>>((ref) async {
  final dir = await path_provider.getApplicationDocumentsDirectory();
  final dbPath = path.join(dir.path, 'db.db');
  final storage = await JsonSqFliteStorage.open(dbPath);
  ref
    ..onDispose(storage.close)
    ..keepAlive();

  return storage;
});

void main() {
  test("self-reading persistable provider should eventually compute", () async {
    const options = StorageOptions();
    final firstPageKey = 'test-0';
    final firstPageValue = '[0,1,2,3,4,5,6,7,8,9]';
    final storage = Storage<String, String>.inMemory();
    storage.write(firstPageKey, firstPageValue, options);
    final container = ProviderContainer.test(
      overrides: [storageProvider.overrideWith((ref) => storage)],
    );

    container.listen(testNotifierProvider(1000), (previous, next) {});

    // wait for the first page to read the persisted value
    await container.read(testNotifierProvider(0).future);
    // wait for the 100th page to compute
    await container.read(testNotifierProvider(1000).future);
    // the first page gets value from the network, others must recompute
    await container.pump();

    expectLater(container.read(testNotifierProvider(1000).future), completes);
  });
}
