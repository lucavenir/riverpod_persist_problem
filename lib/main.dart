import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final someProvider1 = NotifierProvider.autoDispose<ValueStreamProvider, int>(
  ValueStreamProvider.new,
);

class ValueStreamProvider extends Notifier<int> {
  @override
  int build() => 0;
}

final someProvider2 = Provider.autoDispose<int>(
  (ref) => ref.watch(someProvider1),
);

final someProvider3 = FutureProvider.autoDispose<int>((ref) async {
  final _ = ref.watch(someProvider2);

  return 1;
});

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
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
                  final value = ref.watch(someProvider2);
                  final _ = ref.watch(someProvider3).value;

                  return Column(children: [Text('$value')]);
                },
              ),
          ],
        );
      },
    );
  }
}

void main(List<String> args) {
  runApp(const ProviderScope(child: App()));
}
