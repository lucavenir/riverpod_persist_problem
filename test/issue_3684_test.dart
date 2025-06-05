import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final debouncedProvider = FutureProvider.autoDispose<String>(
  dependencies: [childNotifierProvider],
  (ref) async {
    var disposed = false;

    ref.onDispose(() {
      disposed = true;
    });

    final text = ref.watch(childNotifierProvider);
    if (text.isEmpty) return '';

    await Future.delayed(const Duration(milliseconds: 2000));

    if (disposed) throw DebouncedException();
    return text;
  },
);

class ChildNotifier extends Notifier<String> {
  @override
  String build() {
    return "";
  }

  void set(String text) {
    state = text;
  }
}

final childNotifierProvider =
    NotifierProvider.autoDispose<ChildNotifier, String>(ChildNotifier.new);

class DebouncedException implements Exception {}

void main() {
  test('debouncing works?', () {
    final container = ProviderContainer.test();
    final another = ProviderContainer.test(
      parent: container,
      overrides: [
        childNotifierProvider.overrideWithBuild((ref, notifier) => "hello"),
      ],
    );

    another.listen(debouncedProvider, (previous, next) {});
    expect(another.read(childNotifierProvider), equals("hello"));
    expectLater(
      another.read(debouncedProvider.future),
      completion(equals("hello")),
    );
  });
}
