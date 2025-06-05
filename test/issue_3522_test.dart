import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_persist_problem/observer.dart';

void main() {
  test('test name', () async {
    const delay = Duration(milliseconds: 50);
    var baseListeners = 0;
    final baseProvider = FutureProvider.autoDispose<int>((ref) {
      ref.onAddListener(() {
        baseListeners++;
      });
      ref.onRemoveListener(() {
        baseListeners--;
      });
      return Future.value(1);
    }, name: "base");
    var plusOneListeners = 0;
    final plusOneProvider = FutureProvider.autoDispose<int>((ref) async {
      ref.onAddListener(() {
        plusOneListeners++;
      });
      ref.onRemoveListener(() {
        plusOneListeners--;
      });
      await Future.delayed(delay);
      final two = await ref.watch(baseProvider.future);
      return two + 1;
    }, name: "plusOne");
    final container = ProviderContainer(observers: [const MyObserver()]);
    final sub = container.listen(plusOneProvider, (previous, next) {});

    await Future.delayed(delay * 0.90);
    sub.close();
    await Future.delayed(delay * 0.10);

    expect(baseListeners, isZero);
    expect(plusOneListeners, isZero);
  });
}
