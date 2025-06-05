import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MyNotifier extends AutoDisposeFamilyAsyncNotifier<int, int> {
  @override
  Future<int> build(int chatId) {
    return Future.delayed(const Duration(seconds: 3), () => 42);
  }
}

final myNotifierProvider = AsyncNotifierProvider.family
    .autoDispose<MyNotifier, int, int>(
      MyNotifier.new,
      name: "myNotifierProvider",
    );

class PeerNotifier extends AutoDisposeAsyncNotifier<int> {
  @override
  Future<int> build() => Future.value(0);
  void invalidatePeer() => ref.invalidate(myNotifierProvider(0));
}

final peerNotifierProvider =
    AsyncNotifierProvider.autoDispose<PeerNotifier, int>(
      PeerNotifier.new,
      name: "peerNotifierProvider",
    );

class MyObserver extends ProviderObserver {
  const MyObserver();
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    print("provider $provider added with value: $value");
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    print("provider $provider failed with error: $error");
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    print("provider $provider disposed");
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print("provider $provider updated from $previousValue to $newValue");
  }
}

void main() {
  test("invalidating shouldn't trigger a first build", () async {
    final container = ProviderContainer(observers: [const MyObserver()]);
    addTearDown(container.dispose);

    expect(container.exists(myNotifierProvider(0)), isFalse);
    container.read(peerNotifierProvider.notifier).invalidatePeer();
    expect(container.exists(myNotifierProvider(0)), isFalse);
  });
}
