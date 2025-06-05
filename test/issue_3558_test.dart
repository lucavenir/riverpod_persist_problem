import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_persist_problem/observer.dart';

class MyNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void increment() => state++;
}

final myNotifierProvider = NotifierProvider<MyNotifier, int>(MyNotifier.new);

void main() {
  test('ref.exists should be false on invalidated providers', () async {
    final container = ProviderContainer.test(observers: [const MyObserver()]);

    expect(container.exists(myNotifierProvider), isFalse);
    expect(container.read(myNotifierProvider), equals(0));
    final sub = container.listen(myNotifierProvider, (previous, next) {});
    expect(container.exists(myNotifierProvider), isTrue);
    container.read(myNotifierProvider.notifier).increment();
    container.read(myNotifierProvider.notifier).increment();
    expect(container.read(myNotifierProvider), equals(2));
    sub.close();
    await container.pump();
    expect(container.exists(myNotifierProvider), isFalse);
    expect(container.read(myNotifierProvider), equals(0));
  });
}
