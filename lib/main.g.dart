// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(SomeStateController)
@JsonPersist()
const someStateControllerProvider = SomeStateControllerProvider._();

final class SomeStateControllerProvider
    extends $AsyncNotifierProvider<SomeStateController, int> {
  const SomeStateControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'someStateControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$someStateControllerHash();

  @$internal
  @override
  SomeStateController create() => SomeStateController();

  @$internal
  @override
  $AsyncNotifierProviderElement<SomeStateController, int> $createElement(
    $ProviderPointer pointer,
  ) => $AsyncNotifierProviderElement(pointer);
}

String _$someStateControllerHash() =>
    r'7bb6a784fb0c386b2b7476abef2e0968bc795e72';

abstract class _$SomeStateControllerBase extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(storage)
const storageProvider = StorageProvider._();

final class StorageProvider
    extends
        $FunctionalProvider<
          AsyncValue<JsonSqFliteStorage>,
          FutureOr<JsonSqFliteStorage>
        >
    with
        $FutureModifier<JsonSqFliteStorage>,
        $FutureProvider<JsonSqFliteStorage> {
  const StorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageHash();

  @$internal
  @override
  $FutureProviderElement<JsonSqFliteStorage> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<JsonSqFliteStorage> create(Ref ref) {
    return storage(ref);
  }
}

String _$storageHash() => r'83f2b495085755a1c8fccc4a34dd3529482a4b6d';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

// **************************************************************************
// JsonGenerator
// **************************************************************************

abstract class _$SomeStateController extends _$SomeStateControllerBase
    with Persistable<int, String, String> {
  @override
  FutureOr<void> persist({
    String? key,
    required FutureOr<Storage<String, String>> storage,
    String Function(int state)? encode,
    int Function(String encoded)? decode,
    StorageOptions options = const StorageOptions(),
  }) {
    final resolvedKey = "SomeStateController";

    return super.persist(
      key: resolvedKey,
      storage: storage,
      encode: encode ?? (value) => $jsonCodex.encode(state.requireValue),
      decode:
          decode ??
          (encoded) {
            final e = $jsonCodex.decode(encoded);
            return e as int;
          },
      options: options,
    );
  }
}
