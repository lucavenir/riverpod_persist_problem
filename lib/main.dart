import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        home: Consumer(
          builder: (context, ref, _) {
            print("rebuilt");
            ref.listen(streamProvider, (_, next) {});
            return const SomeScreen();
          },
        ),
      ),
    );
  }
}

class SomeScreen extends ConsumerWidget {
  const SomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(futureProvider).value;
    return Text("$value");
  }
}

final streamProvider = StreamProvider.autoDispose((ref) {
  print("started");
  ref.onCancel(() => print("cancelled"));
  ref.onDispose(() => print("disposed"));
  return createStream();
});

final futureProvider = FutureProvider.autoDispose((ref) async {
  final world = await ref.watch(streamProvider.future);
  return "Hello $world";
});

Stream<String> createStream() async* {
  int count = 0;
  while (true) {
    yield "World ${count++}";
    await Future.delayed(const Duration(seconds: 1));
  }
}
