import 'dart:async';

import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final storage = Storage<String, int>.inMemory();

class TestNotifier extends AsyncNotifier<int>
    with Persistable<int, String, int> {
  @override
  FutureOr<int> build() async {
    await persist(
      key: 'key',
      storage: storage,
      encode: (state) => state,
      decode: (encoded) => encoded,
    );

    throw const SomeException();
  }
}

class SomeException implements Exception {
  const SomeException();
}

final testNotifierProvider =
    AsyncNotifierProvider.autoDispose<TestNotifier, int>(TestNotifier.new);

void main() {
  test('If an AsyncNotifier throws, decoded value is preserved', () async {
    storage.write('key', 42, const StorageOptions());

    final container = ProviderContainer.test();

    container.read(testNotifierProvider);
    await container.pump(); // wait for dispose

    await expectLater(
      container.read(testNotifierProvider.future),
      completion(42), // must complete normally
    ); // FAILS
    final read = container.read(testNotifierProvider);
    expect(read.value, equals(42));
    expect(read.isFromCache, isTrue);
    expect(read.error, isNull);
  });
}
