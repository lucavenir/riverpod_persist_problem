import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_persist_problem/persist_page.dart';
import 'package:riverpod_persist_problem/storage_provider.dart';

part 'history_provider.g.dart';

@riverpod
class History extends _$History
    with
        Persistable<List<int>, String, String>,
        PersistablePaginatedResponse<int> {
  @override
  FutureOr<List<int>> build(int id, {required int page}) async {
    print("executing historyProvider, page: $page"); // loop logs in the console
    final storage = await ref.watch(storageProvider.future);

    if (!ref.mounted) return [];
    await persist(
      key: 'history-$id-$page',
      storage: storage,
      encode: (decoded) => jsonEncode(decoded),
      decode: (encoded) {
        final decoded = jsonDecode(encoded) as List<Object?>;
        return decoded //
            .map((e) => e!)
            .map((e) => e as int)
            .toList();
      },
    );

    if (page == 0) {
      if (!ref.mounted) return [];
      final items = await ref.watch(cursorProvider(id, cursor: null).future);
      return items;
    }

    if (!ref.mounted) return [];
    final lastPage = await ref.watch(
      historyProvider(id, page: page - 1).future,
    );
    if (lastPage.isEmpty) return [];

    if (!ref.mounted) return [];
    final items = await ref.watch(
      cursorProvider(id, cursor: lastPage.last).future,
    );
    return items;
  }
}

@riverpod
FutureOr<List<int>> cursor(Ref ref, int id, {required int? cursor}) async {
  return Future.delayed(
    const Duration(seconds: 1),
    () => List.generate(15, (index) => index * Random().nextInt(10 * index)),
  );
}
