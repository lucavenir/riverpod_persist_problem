import 'dart:convert' as convert;

import 'package:riverpod/experimental/persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

typedef Json = Map<String, Object?>;

mixin PersistablePaginatedResponse<T> on Persistable<List<T>, String, String> {
  FutureOr<void> persistPage({
    required String key,
    required Storage<String, String> storage,
    required Json Function(T) encode,
    required T Function(Json) decode,
    StorageOptions options = const StorageOptions(
      cacheTime: StorageCacheTime(Duration(days: 14)),
    ),
  }) async {
    if (!ref.mounted) return;

    await persist(
      key: key,
      storage: storage,
      encode: (state) {
        final list = state.map(encode).toList();
        final encoded = convert.jsonEncode(list);
        return encoded;
      },
      decode: (encoded) {
        final decoded = convert.jsonDecode(encoded) as List<Object?>;
        return decoded //
            .map((e) => e!)
            .map((e) => e as Json)
            .map(decode)
            .toList();
      },
    );
  }
}
