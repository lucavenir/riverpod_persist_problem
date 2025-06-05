import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('stream providers close correctly', () async {
    late bool isStreamClosed;

    final streamProvider = StreamProvider.autoDispose<int>((ref) {
      isStreamClosed = false;
      ref.onDispose(() {
        isStreamClosed = true;
      });
      return Stream<int>.periodic(
        const Duration(milliseconds: 100),
        (count) => count,
      );
    });

    final container = ProviderContainer.test();
    final sub = container.listen(streamProvider, (previous, next) {});
    await container.read(streamProvider.future);
    expect(
      isStreamClosed,
      isFalse,
      reason: 'should not be closed yet since its provider is still active',
    );
    sub.close();
    await container.pump();
    expect(
      isStreamClosed,
      isTrue,
      reason: 'should be closed since its provider disposed',
    );
  });
}
