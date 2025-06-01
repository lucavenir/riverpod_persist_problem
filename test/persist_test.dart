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

    final firstTry = Completer<void>();
    addTearDown(() {
      if (!firstTry.isCompleted) firstTry.complete();
    });
    var reader = container.listen(testNotifierProvider, (_, next) {
      if (next case AsyncError(:final error)) firstTry.completeError(error);
    });
    // wait for the first emit, should complete with value
    await container.read(testNotifierProvider.future);
    var state = reader.read();
    expect(state, isA<AsyncData<int>>());
    expect(state.value, equals(42));
    expect(state.isFromCache, isTrue);
    // wait for the last emit, should complete with error
    await expectLater(firstTry.future, throwsA(isA<SomeException>()));
    state = reader.read();
    expect(state, isA<AsyncError<int>>());
    expect(state.error, isA<SomeException>());
    expect(state.value, equals(42));
    expect(state.isFromCache, isTrue); // FAILS
    reader.close();

    await container.pump();
    final secondTry = Completer<void>();
    addTearDown(() {
      if (!secondTry.isCompleted) secondTry.complete();
    });
    reader = container.listen(testNotifierProvider, (_, next) {
      if (next case AsyncError(:final error)) secondTry.completeError(error);
    });
    // wait for the first emit, should complete with value
    await container.read(testNotifierProvider.future); // THROWS
    state = reader.read();
    expect(state, isA<AsyncData<int>>());
    expect(state.value, equals(42));
    expect(state.isFromCache, isTrue);
    // wait for the last emit, should complete with error
    await expectLater(secondTry.future, throwsA(isA<SomeException>()));
    state = reader.read();
    expect(state, isA<AsyncError<int>>());
    expect(state.error, isA<SomeException>());
    expect(state.value, equals(42));
    // expect(state.isFromCache, isTrue);  // FAILS
  });
}
