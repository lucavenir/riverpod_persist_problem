import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FetchItemsNotifier extends Notifier<int> {
  @protected
  var internalState = 5;
  @override
  build() {
    ref.onDispose(() => print('onDispose'));
    ref.onCancel(() => print('onCancel'));
    ref.onResume(() => print('onResume'));
    return 5;
  }

  void add() {
    state = state + 1;
    internalState = state;
  }
}

final fetchItemProvider = NotifierProvider<FetchItemsNotifier, int>(
  FetchItemsNotifier.new,
);

void main() {
  runApp(const ProviderScope(child: MaterialApp(home: MyHomePage())));
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.select_all),
        onPressed: () {
          print('does exist: ${ref.exists(fetchItemProvider)}');
          print(
            'internal State: ${ref.read(fetchItemProvider.notifier).internalState}',
          );
        },
      ),
      body: Center(
        child: TextButton(
          onPressed: () {
            print('Navigate To Next Page');
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => MyHomePage2()));
          },
          child: Text('Navigate To Next Page'),
        ),
      ),
    );
  }
}

class MyHomePage2 extends ConsumerStatefulWidget {
  const MyHomePage2({super.key});

  @override
  ConsumerState<MyHomePage2> createState() => _MyHomePage2State();
}

class _MyHomePage2State extends ConsumerState<MyHomePage2> {
  @override
  void deactivate() {
    ref.invalidate(fetchItemProvider);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: Row(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'Exist',
            child: Icon(Icons.select_all),
            onPressed: () {
              print('does exist: ${ref.exists(fetchItemProvider)}');
              print(
                'internal State: ${ref.read(fetchItemProvider.notifier).internalState}',
              );
            },
          ),
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => ref.read(fetchItemProvider.notifier).add(),
          ),
        ],
      ),
      body: Center(child: Text(ref.watch(fetchItemProvider).toString())),
    );
  }
}
