import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_persist_problem/storage_provider.dart';

part 'history_provider.g.dart';

@riverpod
class History extends _$History with Persistable<List<int>, String, String> {
  @override
  FutureOr<List<int>> build(int id, {required int page}) async {
    final storage = await ref.watch(storageProvider.future);
    print("executing historyProvider($page)");

    await persist(
      key: 'history-$id-$page',
      storage: storage,
      encode: (state) => jsonEncode(state),
      decode: (encoded) {
        final decoded = jsonDecode(encoded) as List<Object?>;
        return decoded.cast<int>();
      },
    );
    print("stored historyProvider($page)");

    if (page == 0) {
      final items = await ref.watch(cursorProvider(id, cursor: null).future);
      print("done with historyProvider($page) - first page");
      return items;
    }

    final lastPage = await ref.watch(
      historyProvider(id, page: page - 1).future,
    );
    if (lastPage.isEmpty) {
      print("done with historyProvider($page) - the previous page was empty!");
      return [];
    }

    final items = await ref.watch(cursorProvider(id, cursor: page).future);
    print("done with historyProvider($page)");
    return items;
  }
}

@riverpod
FutureOr<List<int>> cursor(Ref ref, int id, {required int? cursor}) async {
  print("executing cursorProvider($id, $cursor)");
  return Future.delayed(
    Duration(milliseconds: 1),
    () => List.generate(15, (index) => math.Random().nextInt(10)),
  );
}
