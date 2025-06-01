import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class HomeNotifier extends Notifier<int> {
  @override
  int build() {
    print("executing home build");
    return 0;
  }

  void increment() {
    state++;
  }
}

final homeNotifierProvider = NotifierProvider<HomeNotifier, int>(
  HomeNotifier.new,
);

class AnotherNotifier extends Notifier<int> {
  @override
  int build() {
    print("executing another build");
    return 0;
  }

  void clear() {
    ref.invalidate(homeNotifierProvider);
  }
}

final anotherNotifierProvider = NotifierProvider<AnotherNotifier, int>(
  AnotherNotifier.new,
);

class TestWidget extends ConsumerWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                ref.read(homeNotifierProvider);
              },
              child: const Text('Read provider'),
            ),
            ElevatedButton(
              onPressed: () => ref.invalidate(homeNotifierProvider),
              child: Text('Dispose of provider directly'),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(anotherNotifierProvider.notifier).clear();
              },
              child: Text('Dispose of provider indirectly'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  test('invalidating should be consistent', () {
    final container = ProviderContainer.test();

    container.invalidate(homeNotifierProvider);
    container.read(anotherNotifierProvider.notifier).clear();
  });
}
