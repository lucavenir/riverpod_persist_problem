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
    var reader = container.listen(testNotifierProvider, (_, __) {});
    // fails - it computes to AsyncData<int>(value: 42)
    await expectLater(
      container.read(testNotifierProvider.future),
      throwsA(isA<SomeException>()),
    );

    var state = reader.read();
    // fails - it computes to AsyncData<int>(value: 42)
    expect(state, isA<AsyncError<int>>());
    // fails - it claims there's no error
    expect(state.error, isA<SomeException>());
    expect(state.value, equals(42));
    expect(state.isFromCache, isTrue);
    reader.close();

    await container.pump();

    reader = container.listen(testNotifierProvider, (_, __) {});
    // here, since the persisted value has (for some reason) been destroyed
    // no error is thrown
    await expectLater(
      container.read(testNotifierProvider.future),
      throwsA(isA<SomeException>()),
    );

    state = reader.read();
    expect(state, isA<AsyncError<int>>());
    expect(state.error, isA<SomeException>());
    // fails - there's no value
    expect(state.value, equals(42));
    // fails - there's no cached value
    expect(state.isFromCache, isTrue);
  });
}
