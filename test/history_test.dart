import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_persist_problem/history_provider.dart';
import 'package:riverpod_persist_problem/storage_provider.dart';
import 'package:riverpod_sqflite/riverpod_sqflite.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(StorageOptions());
  });
  test("self-reading persistable provider should compute normally", () {
    final mock = StorageMock();
    const mockedData = "[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]";
    when(
      () => mock.read(any()),
    ).thenAnswer((_) async => PersistedData(mockedData));
    when(
      () => mock.write(any(), any(), any()),
    ).thenAnswer((_) async => mockedData);
    final container = ProviderContainer.test(
      overrides: [storageProvider.overrideWith((ref) => mock)],
    );

    final reader = container.listen(
      historyProvider(99, page: 100).future,
      (previous, next) {},
    );

    expectLater(
      reader.read(),
      completion(equals([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15])),
    );
  });
}

class StorageMock<KeyT, EncodedT> extends Mock implements JsonSqFliteStorage {}
