// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Whether the first-run screen has already been dismissed.
///
/// Null means the question has never been answered on this install, either
/// because it predates the screen or because the install is new. An existing
/// user with a repository is treated as done, because somebody with a library
/// should not be welcomed to the app they have been using for months.
///
/// A debug build answers null as done too. Those get installed over and over
/// during development and a welcome screen on every one of them is noise; the
/// entry in General settings is how to see the screen on purpose. Release
/// builds keep the real first-run behaviour.

@ProviderFor(OnboardingCompletedState)
final onboardingCompletedStateProvider = OnboardingCompletedStateProvider._();

/// Whether the first-run screen has already been dismissed.
///
/// Null means the question has never been answered on this install, either
/// because it predates the screen or because the install is new. An existing
/// user with a repository is treated as done, because somebody with a library
/// should not be welcomed to the app they have been using for months.
///
/// A debug build answers null as done too. Those get installed over and over
/// during development and a welcome screen on every one of them is noise; the
/// entry in General settings is how to see the screen on purpose. Release
/// builds keep the real first-run behaviour.
final class OnboardingCompletedStateProvider
    extends $NotifierProvider<OnboardingCompletedState, bool> {
  /// Whether the first-run screen has already been dismissed.
  ///
  /// Null means the question has never been answered on this install, either
  /// because it predates the screen or because the install is new. An existing
  /// user with a repository is treated as done, because somebody with a library
  /// should not be welcomed to the app they have been using for months.
  ///
  /// A debug build answers null as done too. Those get installed over and over
  /// during development and a welcome screen on every one of them is noise; the
  /// entry in General settings is how to see the screen on purpose. Release
  /// builds keep the real first-run behaviour.
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
    r'1cf7729b66a79b9584ee8266d41f26030fcec9e0';

/// Whether the first-run screen has already been dismissed.
///
/// Null means the question has never been answered on this install, either
/// because it predates the screen or because the install is new. An existing
/// user with a repository is treated as done, because somebody with a library
/// should not be welcomed to the app they have been using for months.
///
/// A debug build answers null as done too. Those get installed over and over
/// during development and a welcome screen on every one of them is noise; the
/// entry in General settings is how to see the screen on purpose. Release
/// builds keep the real first-run behaviour.

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
