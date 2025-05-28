import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/experimental/json_persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_sqflite/riverpod_sqflite.dart';

part 'main.g.dart';

void main() {
  runApp(
    ProviderScope(retry: (retryCount, error) => null, child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod persistence',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
      ),
      home: const HomePage(title: 'Home page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Lets see what you got'),
            ElevatedButton(onPressed: _pushPage, child: Text("Let's go!")),
          ],
        ),
      ),
    );
  }

  void _pushPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChildPage()),
    );
  }
}

@riverpod
@JsonPersist()
class SomeStateController extends _$SomeStateController {
  @override
  FutureOr<int> build() async {
    final storage = await ref.watch(storageProvider.future);
    await persist(storage: storage);
    await Future.delayed(const Duration(seconds: 1));
    // return 42; // Uncomment this line to return a value
    throw "LOL"; // Uncomment this line to simulate an error
  }
}

class ChildPage extends ConsumerWidget {
  const ChildPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(someStateControllerProvider);
    print(
      "state: ${state.value}, hasError: ${state.hasError}, isLoading: ${state.isLoading}, hasValue: ${state.hasValue}",
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Child page')),
      body: Center(
        child: switch (state) {
          AsyncValue(:final value?) => Text('Value: $value'),
          AsyncLoading() => const CircularProgressIndicator(),
          AsyncError() => const Text('Error occurred'),
        },
      ),
    );
  }
}

@riverpod
FutureOr<JsonSqFliteStorage> storage(Ref ref) async {
  final dir = await path_provider.getApplicationDocumentsDirectory();
  final dbPath = path.join(dir.path, 'db.db');
  final storage = await JsonSqFliteStorage.open(dbPath);
  ref
    ..onDispose(storage.close)
    ..keepAlive();

  return storage;
}
