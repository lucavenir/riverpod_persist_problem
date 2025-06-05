import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_persist_problem/observer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('combining values work with widgets', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    expect(find.text('is combined? false'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('is combined? true'), findsOneWidget);
    expect(find.text('second: 42, combined 42'), findsOneWidget);
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: ProviderScope(
        observers: const [MyObserver()],
        overrides: [parameterProvider.overrideWithValue(null)],
        child: const Scaffold(body: Column(children: [Widget1(), Widget2()])),
      ),
    );
  }
}

class Widget1 extends ConsumerWidget {
  const Widget1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCombined = ref.watch(combinedProvider) != null;
    return Text('is combined? $isCombined');
  }
}

class Widget2 extends ConsumerWidget {
  const Widget2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final combined = ref.watch(combinedProvider);
    final second = ref.watch(secondProvider);
    return Text('second: $second, combined $combined');
  }
}

final parameterProvider = Provider.autoDispose<int?>(
  (ref) => null,
  name: "parameterProvider",
);

final futureProvider = FutureProvider.autoDispose<int>(
  (ref) => Future.value(42),
  name: "futureProvider",
);

final secondProvider = Provider.autoDispose<int?>(
  (ref) {
    return ref.watch(futureProvider).value;
  },
  dependencies: [futureProvider],
  name: "secondProvider",
);

final combinedProvider = Provider.autoDispose<int?>(
  (ref) {
    return ref.watch(parameterProvider) ?? ref.watch(secondProvider);
  },
  dependencies: [parameterProvider, secondProvider],
  name: "combinedProvider",
);
