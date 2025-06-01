import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class HomeNotifier extends Notifier<int> {
  @override
  int build() => 0;
}

final homeNotifierProvider = NotifierProvider.autoDispose<HomeNotifier, int>(
  HomeNotifier.new,
);

class AnotherNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void clear() {
    ref.invalidate(homeNotifierProvider);
  }
}

final anotherNotifierProvider =
    NotifierProvider.autoDispose<AnotherNotifier, int>(AnotherNotifier.new);

void main() {
  test('invalidating should be consistent', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(anotherNotifierProvider.notifier).clear();
    expect(container.exists(homeNotifierProvider), isFalse);
  });
}
