// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the first-run screen has already been dismissed.
///
/// Null means an install from before the screen existed. Those are treated as
/// done when the user already has a repository, because somebody with a library
/// should not be welcomed to the app they have been using for months.

@ProviderFor(OnboardingCompletedState)
final onboardingCompletedStateProvider = OnboardingCompletedStateProvider._();

/// Whether the first-run screen has already been dismissed.
///
/// Null means an install from before the screen existed. Those are treated as
/// done when the user already has a repository, because somebody with a library
/// should not be welcomed to the app they have been using for months.
final class OnboardingCompletedStateProvider
    extends $NotifierProvider<OnboardingCompletedState, bool> {
  /// Whether the first-run screen has already been dismissed.
  ///
  /// Null means an install from before the screen existed. Those are treated as
  /// done when the user already has a repository, because somebody with a library
  /// should not be welcomed to the app they have been using for months.
  OnboardingCompletedStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingCompletedStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingCompletedStateHash();

  @$internal
  @override
  OnboardingCompletedState create() => OnboardingCompletedState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$onboardingCompletedStateHash() =>
    r'721fdbf7b4074bb4623870fa1ca49ca5f821b605';

/// Whether the first-run screen has already been dismissed.
///
/// Null means an install from before the screen existed. Those are treated as
/// done when the user already has a repository, because somebody with a library
/// should not be welcomed to the app they have been using for months.

abstract class _$OnboardingCompletedState extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
