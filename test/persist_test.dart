import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_persist_problem/main.dart';
import 'package:riverpod_sqflite/riverpod_sqflite.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(StorageOptions());
  });
  test("self-reading persistable provider should compute normally", () async {
    final mockedStorage = StorageMock();
    const mockedValue = SomeStateController.value;
    const mockedData = "$mockedValue";
    when(() => mockedStorage.read(any())).thenAnswer((_) async => null);
    when(
      () => mockedStorage.write(any(), any(), any()),
    ).thenAnswer((_) async => mockedData);
    when(() => mockedStorage.delete(any())).thenAnswer((_) async {});
    when(() => mockedStorage.close()).thenAnswer((_) async {});

    final container = ProviderContainer.test(
      overrides: [storageProvider.overrideWith((ref) => mockedStorage)],
    );

    var reader = container.listen(
      someStateControllerProvider,
      (previous, next) {},
    );

    await container.pump();
    await Future.delayed(const Duration(milliseconds: 50));
    switch (reader.read()) {
      case AsyncValue(:final value?):
        expect(value, equals(mockedValue));
      case final something:
        fail(
          "there should be an error emitted, while still having the cached value got: $something",
        );
    }
    reader.close();
    await container.pump();
    await Future.delayed(const Duration(milliseconds: 50));

    when(
      () => mockedStorage.read(any()),
    ).thenAnswer((_) async => PersistedData(mockedData));

    reader = container.listen(someStateControllerProvider, (previous, next) {});
    await container.pump();
    await Future.delayed(const Duration(milliseconds: 50));
    switch (reader.read()) {
      case AsyncValue(isFromCache: true, hasError: true, :final value?):
        expect(value, equals(mockedValue));
      case final something:
        fail(
          "we'd expect the cached value to be emitted, but `isFromCache` is ${something.isFromCache}; got: $something",
        );
    }
  });
}

class StorageMock<KeyT, EncodedT> extends Mock implements JsonSqFliteStorage {}
