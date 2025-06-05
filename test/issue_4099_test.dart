import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final streamProvider = StreamProvider.autoDispose((ref) {
  ref.onCancel(() {
    fail("onCancel can't trigger without removing a listener");
  });
  return Stream.periodic(const Duration(seconds: 1), (count) => "World $count");
});

final futureProvider = FutureProvider.autoDispose((ref) async {
  final world = await ref.watch(streamProvider.future);
  return "Hello $world";
});

void main() {
  test("listening to a streamProvider can't trigger onCancel", () {
    final container = ProviderContainer.test();

    container.listen(streamProvider, (_, next) {});
    container.listen(futureProvider, (_, next) {});

    expectLater(
      container.read(futureProvider.future),
      completion(equals("Hello World 0")),
    );
  });
}
