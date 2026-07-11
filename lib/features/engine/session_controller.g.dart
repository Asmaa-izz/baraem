// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Drives a session. Two explicit modes chosen on the home screen:
/// - learn: browse the chosen category's images (display only, never quizzes);
/// - quiz: test the chosen category's items (errorless engine, distractors from
///   the same category, mastery/Leitner persisted).

@ProviderFor(SessionController)
final sessionControllerProvider = SessionControllerFamily._();

/// Drives a session. Two explicit modes chosen on the home screen:
/// - learn: browse the chosen category's images (display only, never quizzes);
/// - quiz: test the chosen category's items (errorless engine, distractors from
///   the same category, mastery/Leitner persisted).
final class SessionControllerProvider
    extends $AsyncNotifierProvider<SessionController, SessionState> {
  /// Drives a session. Two explicit modes chosen on the home screen:
  /// - learn: browse the chosen category's images (display only, never quizzes);
  /// - quiz: test the chosen category's items (errorless engine, distractors from
  ///   the same category, mastery/Leitner persisted).
  SessionControllerProvider._({
    required SessionControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'sessionControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sessionControllerHash();

  @override
  String toString() {
    return r'sessionControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SessionController create() => SessionController();

  @override
  bool operator ==(Object other) {
    return other is SessionControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sessionControllerHash() => r'93924a3f5dfd2dcbd5e5a2e059df26b034b132ca';

/// Drives a session. Two explicit modes chosen on the home screen:
/// - learn: browse the chosen category's images (display only, never quizzes);
/// - quiz: test the chosen category's items (errorless engine, distractors from
///   the same category, mastery/Leitner persisted).

final class SessionControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          SessionController,
          AsyncValue<SessionState>,
          SessionState,
          FutureOr<SessionState>,
          String
        > {
  SessionControllerFamily._()
    : super(
        retry: null,
        name: r'sessionControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Drives a session. Two explicit modes chosen on the home screen:
  /// - learn: browse the chosen category's images (display only, never quizzes);
  /// - quiz: test the chosen category's items (errorless engine, distractors from
  ///   the same category, mastery/Leitner persisted).

  SessionControllerProvider call(String profileId) =>
      SessionControllerProvider._(argument: profileId, from: this);

  @override
  String toString() => r'sessionControllerProvider';
}

/// Drives a session. Two explicit modes chosen on the home screen:
/// - learn: browse the chosen category's images (display only, never quizzes);
/// - quiz: test the chosen category's items (errorless engine, distractors from
///   the same category, mastery/Leitner persisted).

abstract class _$SessionController extends $AsyncNotifier<SessionState> {
  late final _$args = ref.$arg as String;
  String get profileId => _$args;

  FutureOr<SessionState> build(String profileId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SessionState>, SessionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SessionState>, SessionState>,
              AsyncValue<SessionState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
