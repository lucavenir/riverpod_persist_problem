import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_persist_problem/observer.dart';

final streamController = StreamController<int>.broadcast();

final streamNP = NotifierProvider.autoDispose<StreamN, int>(
  StreamN.new,
  name: "streamNP",
);

class StreamN extends Notifier<int> {
  @override
  int build() {
    final listener = streamController.stream.listen((event) {
      print("event received: $event");

      if (event != stateOrNull) {
        state = event;
      }
    });
    ref.onDispose(listener.cancel);

    return stateOrNull ?? 0;
  }
}

final firstP = Provider<int>((ref) {
  return ref.watch(streamNP);
}, name: "firstP");

final secondP = FutureProvider<int>((ref) async {
  final _ = ref.watch(firstP);
  return 1;
}, name: "secondP");

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) => WidgetsApp(
    color: const Color(0xFFFFFFFF),
    builder: (context, child) {
      return Column(
        children: [
          TextButton(
            onPressed: () {
              setState(() {
                _isVisible = !_isVisible;
              });
            },
            child: const Text('Toggle Visibility'),
          ),
          if (_isVisible)
            Consumer(
              builder: (context, ref, child) {
                final value = ref.watch(firstP);
                final _ = ref.watch(secondP).value;

                return Column(children: [Text('$value')]);
              },
            ),
        ],
      );
    },
  );
}

void main(List<String> args) async {
  Timer.periodic(const Duration(seconds: 1), (timer) {
    streamController.add(timer.tick);
  });

  runApp(const ProviderScope(observers: [MyObserver()], child: App()));
}
