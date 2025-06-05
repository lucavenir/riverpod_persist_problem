import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyObserver extends ProviderObserver {
  const MyObserver();
  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    print("provider ${context.provider} added with value: $value");
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    print("provider ${context.provider} failed with error: $error");
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    print(
      "provider ${context.provider} updated from $previousValue to $newValue",
    );
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    print("provider ${context.provider} disposed");
  }
}
