import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

final provider1 = FutureProvider.autoDispose(
  (ref) => ref.watch(numberProvider.future),
  name: "one",
);
final provider2 = FutureProvider.autoDispose(
  (ref) => ref.watch(numberProvider.future),
  name: "two",
);
final numberProvider = StreamProvider.autoDispose<int>(name: "number", (ref) {
  final controller = StreamController<int>();

  int counter = 0;
  final timer = Timer.periodic(Duration(milliseconds: 10), (_) {
    if (!controller.isClosed) controller.sink.add(counter++);
  });

  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });

  return controller.stream;
});

class MyObserver extends ProviderObserver {
  const MyObserver();
  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    print("provider ${context.provider} added with value: $value");
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    print("provider ${context.provider} failed with error: $error");
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    print(
      "provider ${context.provider} updated from $previousValue to $newValue",
    );
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    print("provider ${context.provider} disposed");
  }
}

void main() {
  test("adding and removing a dep shouldn't stop its listeners", () {
    fakeAsync((async) async {
      final container = ProviderContainer.test(observers: const [MyObserver()]);
      Future<void> pushAndPop() async {
        final sub2 = container.listen(provider2, (previous, next) {});
        await Future.microtask(() {});
        sub2.close();
      }

      unawaited(
        Future.delayed(Duration.zero, () async {
          await pushAndPop();
          await Future.delayed(Duration.zero);
          await pushAndPop();
        }),
      );

      container.listen(provider1, (previous, next) {});
      async.elapse(Duration.zero);

      expectLater(container.read(numberProvider.future), completes);
    });
  });
}
