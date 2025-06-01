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

    throw FormatException("only works with storage");
  }
}

final testNotifierProvider =
    AsyncNotifierProvider.autoDispose<TestNotifier, int>(TestNotifier.new);

void main() {
  test('If an AsyncNotifier throws, decoded value is preserved', () async {
    storage.write('key', 42, const StorageOptions());

    final container = ProviderContainer.test();
    var reader = container.listen(testNotifierProvider, (_, __) {});

    var state = reader.read();
    // expect(state, isA<AsyncLoading<int>>());  // why does this fail?
    expect(state, isA<AsyncData<int>>());
    expect(state.error, isNull);
    expect(state.value, 42);
    expect(state.isFromCache, true);
    await container.pump();
    state = reader.read();
    expect(state, isA<AsyncError<int>>());
    expect(state.error, isFormatException);
    expect(state.value, 42);
    // expect(state.isFromCache, true); // why does this fail?
    reader.close();
    await container.pump();

    reader = container.listen(testNotifierProvider, (_, __) {});
    state = reader.read();
    expect(state, isA<AsyncLoading<int>>());
    expect(state.error, isNull);
    expect(state.value, isNull);
    expect(state.isFromCache, false);
    await container.pump();
    state = reader.read();
    expect(state.isFromCache, true); // fails
    expect(state.value, 42); // fails
    expect(state, isA<AsyncData<int>>()); // fails
  });
}
