// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(History)
const historyProvider = HistoryFamily._();

final class HistoryProvider extends $AsyncNotifierProvider<History, List<int>> {
  const HistoryProvider._({
    required HistoryFamily super.from,
    required (int, {int page}) super.argument,
  }) : super(
         retry: null,
         name: r'historyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$historyHash();

  @override
  String toString() {
    return r'historyProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  History create() => History();

  @$internal
  @override
  $AsyncNotifierProviderElement<History, List<int>> $createElement(
    $ProviderPointer pointer,
  ) => $AsyncNotifierProviderElement(pointer);

  @override
  bool operator ==(Object other) {
    return other is HistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$historyHash() => r'79fef37706374e0931adfd4d5053bceaeb44ae8b';

final class HistoryFamily extends $Family
    with
        $ClassFamilyOverride<
          History,
          AsyncValue<List<int>>,
          List<int>,
          FutureOr<List<int>>,
          (int, {int page})
        > {
  const HistoryFamily._()
    : super(
        retry: null,
        name: r'historyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HistoryProvider call(int id, {required int page}) =>
      HistoryProvider._(argument: (id, page: page), from: this);

  @override
  String toString() => r'historyProvider';
}

abstract class _$History extends $AsyncNotifier<List<int>> {
  late final _$args = ref.$arg as (int, {int page});
  int get id => _$args.$1;
  int get page => _$args.page;

  FutureOr<List<int>> build(int id, {required int page});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args.$1, page: _$args.page);
    final ref = this.ref as $Ref<AsyncValue<List<int>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<int>>>,
              AsyncValue<List<int>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(cursor)
const cursorProvider = CursorFamily._();

final class CursorProvider
    extends $FunctionalProvider<AsyncValue<List<int>>, FutureOr<List<int>>>
    with $FutureModifier<List<int>>, $FutureProvider<List<int>> {
  const CursorProvider._({
    required CursorFamily super.from,
    required (int, {int? cursor}) super.argument,
  }) : super(
         retry: null,
         name: r'cursorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cursorHash();

  @override
  String toString() {
    return r'cursorProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<int>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<int>> create(Ref ref) {
    final argument = this.argument as (int, {int? cursor});
    return cursor(ref, argument.$1, cursor: argument.cursor);
  }

  @override
  bool operator ==(Object other) {
    return other is CursorProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cursorHash() => r'd5affca715eb76c29b97a2f0c98e07e40c34f753';

final class CursorFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<int>>, (int, {int? cursor})> {
  const CursorFamily._()
    : super(
        retry: null,
        name: r'cursorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CursorProvider call(int id, {required int? cursor}) =>
      CursorProvider._(argument: (id, cursor: cursor), from: this);

  @override
  String toString() => r'cursorProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
