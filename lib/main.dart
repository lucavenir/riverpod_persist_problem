import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyObserver extends ProviderObserver {
  const MyObserver();

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    print("provider $provider added with value: $value");
  }

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print("provider $provider updated from $previousValue to $newValue");
  }

  @override
  void didDisposeProvider(ProviderBase provider, ProviderContainer container) {
    print("provider $provider disposed");
  }

  @override
  void providerDidFail(
    ProviderBase provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    print("provider $provider failed with error: $error");
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

class HomeNotifier extends AutoDisposeNotifier<int> {
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

class AnotherNotifier extends AutoDisposeNotifier<int> {
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
