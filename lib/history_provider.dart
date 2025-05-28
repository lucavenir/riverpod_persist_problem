import 'dart:convert' as convert;
import 'dart:math' as math;

import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_persist_problem/storage_provider.dart';

part 'history_provider.g.dart';

@riverpod
class History extends _$History with Persistable<List<int>, String, String> {
  static const delay = Duration(milliseconds: 1);
  static const pageSize = 10;

  @override
  FutureOr<List<int>> build(int id, {required int page}) async {
    print('built: $id, page: $page');
    final storage = await ref.watch(storageProvider.future);

    await persist(
      key: 'history-$id-$page',
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

    final lastPage = await ref.watch(
      historyProvider(id, page: page - 1).future,
    );
    if (lastPage.isEmpty) return [];

    final items = await Future.delayed(delay, () => mock(lastPage.last));
    return items;
  }

  List<int> mock(int i) {
    return List.generate(
      pageSize,
      (index) => math.Random().nextInt(i + 10 * index),
    );
  }
}
