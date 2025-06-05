import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('not working invalidating family', () {
    var mustBeDisposed = false;
    final someProvider = Provider((ref) {
      return 0;
    });
    final familyProvider = Provider.family((ref, int a) {
      final b = ref.watch(someProvider);
      ref.onDispose(() {
        mustBeDisposed = true;
      });
      return a + b;
    }, dependencies: [someProvider]);
    final root = ProviderContainer();
    final container = ProviderContainer(
      parent: root,
      overrides: [someProvider.overrideWith((ref) => 42)],
    );

    container.read(familyProvider(1));
    container.invalidate(familyProvider);

    expect(mustBeDisposed, isTrue, reason: 'familyProvider should be disposed');
  });
}
