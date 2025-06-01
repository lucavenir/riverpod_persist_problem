import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

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
  runApp(ProviderScope(observers: const [MyObserver()], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TestWidget(),
    );
  }
}

class HomeNotifier extends Notifier<int> {
  late KeepAliveLink _link;

  @override
  int build() {
    _link = ref.keepAlive();
    ref.onDispose(() {
      _link.close();
    });

    return 0;
  }

  void increment() {
    state++;
  }
}

final homeNotifierProvider = NotifierProvider.autoDispose<HomeNotifier, int>(
  HomeNotifier.new,
);

class AnotherNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void clear() {
    ref.invalidate(homeNotifierProvider);
  }
}

final anotherNotifierProvider =
    NotifierProvider.autoDispose<AnotherNotifier, int>(AnotherNotifier.new);

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
