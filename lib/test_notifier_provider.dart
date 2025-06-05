import 'dart:convert' as convert;

import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_persist_problem/storage_provider.dart';

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
