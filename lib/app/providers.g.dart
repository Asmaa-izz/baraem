// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(clock)
final clockProvider = ClockProvider._();

final class ClockProvider extends $FunctionalProvider<Clock, Clock, Clock>
    with $Provider<Clock> {
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<Clock> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Clock create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Clock value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Clock>(value),
    );
  }
}

String _$clockHash() => r'55214d6539f7396a3ae1aa23b06eea79fdac0ebe';

@ProviderFor(random)
final randomProvider = RandomProvider._();

final class RandomProvider extends $FunctionalProvider<Random, Random, Random>
    with $Provider<Random> {
  RandomProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'randomProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$randomHash();

  @$internal
  @override
  $ProviderElement<Random> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Random create(Ref ref) {
    return random(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Random value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Random>(value),
    );
  }
}

String _$randomHash() => r'83ff04d9c2bda3b7d29c4393f76230f33f8c6839';

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'59cce38d45eeaba199eddd097d8e149d66f9f3e1';

@ProviderFor(contentRepository)
final contentRepositoryProvider = ContentRepositoryProvider._();

final class ContentRepositoryProvider
    extends
        $FunctionalProvider<
          ContentRepository,
          ContentRepository,
          ContentRepository
        >
    with $Provider<ContentRepository> {
  ContentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contentRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contentRepositoryHash();

  @$internal
  @override
  $ProviderElement<ContentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ContentRepository create(Ref ref) {
    return contentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContentRepository>(value),
    );
  }
}

String _$contentRepositoryHash() => r'2b994f4db7e792a8d1ec6dbdfd9f3729c4a1bc05';

@ProviderFor(profileRepository)
final profileRepositoryProvider = ProfileRepositoryProvider._();

final class ProfileRepositoryProvider
    extends
        $FunctionalProvider<
          ProfileRepository,
          ProfileRepository,
          ProfileRepository
        >
    with $Provider<ProfileRepository> {
  ProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileRepository create(Ref ref) {
    return profileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRepository>(value),
    );
  }
}

String _$profileRepositoryHash() => r'9f979afb3a9ca342b2a8f56235f5efc5fab09483';

@ProviderFor(learningRepository)
final learningRepositoryProvider = LearningRepositoryProvider._();

final class LearningRepositoryProvider
    extends
        $FunctionalProvider<
          LearningRepository,
          LearningRepository,
          LearningRepository
        >
    with $Provider<LearningRepository> {
  LearningRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learningRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learningRepositoryHash();

  @$internal
  @override
  $ProviderElement<LearningRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LearningRepository create(Ref ref) {
    return learningRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearningRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearningRepository>(value),
    );
  }
}

String _$learningRepositoryHash() =>
    r'6cd2573869314271db9fc4f0c1b2705efd3e29be';

@ProviderFor(reportsRepository)
final reportsRepositoryProvider = ReportsRepositoryProvider._();

final class ReportsRepositoryProvider
    extends
        $FunctionalProvider<
          ReportsRepository,
          ReportsRepository,
          ReportsRepository
        >
    with $Provider<ReportsRepository> {
  ReportsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportsRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReportsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReportsRepository create(Ref ref) {
    return reportsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportsRepository>(value),
    );
  }
}

String _$reportsRepositoryHash() => r'2be85c1f56974a48d658575c710b229b2dc598dc';

@ProviderFor(settingsRepository)
final settingsRepositoryProvider = SettingsRepositoryProvider._();

final class SettingsRepositoryProvider
    extends
        $FunctionalProvider<
          SettingsRepository,
          SettingsRepository,
          SettingsRepository
        >
    with $Provider<SettingsRepository> {
  SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRepository>(value),
    );
  }
}

String _$settingsRepositoryHash() =>
    r'0eda22c9c7a5e68c8661bf58b528d73264ef9a19';

@ProviderFor(praiseRepository)
final praiseRepositoryProvider = PraiseRepositoryProvider._();

final class PraiseRepositoryProvider
    extends
        $FunctionalProvider<
          PraiseRepository,
          PraiseRepository,
          PraiseRepository
        >
    with $Provider<PraiseRepository> {
  PraiseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'praiseRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$praiseRepositoryHash();

  @$internal
  @override
  $ProviderElement<PraiseRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PraiseRepository create(Ref ref) {
    return praiseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PraiseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PraiseRepository>(value),
    );
  }
}

String _$praiseRepositoryHash() => r'a557891b0e407714e1b9b6cf60d0edd6e33b9482';

/// All encouragement clips (system + user). The parent list watches it; the
/// session filters it to enabled clips for playback.

@ProviderFor(praises)
final praisesProvider = PraisesProvider._();

/// All encouragement clips (system + user). The parent list watches it; the
/// session filters it to enabled clips for playback.

final class PraisesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Praise>>,
          List<Praise>,
          Stream<List<Praise>>
        >
    with $FutureModifier<List<Praise>>, $StreamProvider<List<Praise>> {
  /// All encouragement clips (system + user). The parent list watches it; the
  /// session filters it to enabled clips for playback.
  PraisesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'praisesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$praisesHash();

  @$internal
  @override
  $StreamProviderElement<List<Praise>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Praise>> create(Ref ref) {
    return praises(ref);
  }
}

String _$praisesHash() => r'd4dd91d3cccd7954253cc378e8f79cdb8c35f178';

@ProviderFor(learningEngine)
final learningEngineProvider = LearningEngineProvider._();

final class LearningEngineProvider
    extends $FunctionalProvider<LearningEngine, LearningEngine, LearningEngine>
    with $Provider<LearningEngine> {
  LearningEngineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'learningEngineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$learningEngineHash();

  @$internal
  @override
  $ProviderElement<LearningEngine> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LearningEngine create(Ref ref) {
    return learningEngine(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LearningEngine value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LearningEngine>(value),
    );
  }
}

String _$learningEngineHash() => r'91046c5263a1d7f40d56ddd5437ab8e6ae03dbad';

@ProviderFor(appBootstrap)
final appBootstrapProvider = AppBootstrapProvider._();

final class AppBootstrapProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  AppBootstrapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appBootstrapProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appBootstrapHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return appBootstrap(ref);
  }
}

String _$appBootstrapHash() => r'f4a1774f236cc443bfaa79a35c392d5493ba29fa';

@ProviderFor(profiles)
final profilesProvider = ProfilesProvider._();

final class ProfilesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChildProfile>>,
          List<ChildProfile>,
          Stream<List<ChildProfile>>
        >
    with
        $FutureModifier<List<ChildProfile>>,
        $StreamProvider<List<ChildProfile>> {
  ProfilesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profilesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profilesHash();

  @$internal
  @override
  $StreamProviderElement<List<ChildProfile>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ChildProfile>> create(Ref ref) {
    return profiles(ref);
  }
}

String _$profilesHash() => r'df858266b49f7c461580f2e3e626ee20d0bdac10';

@ProviderFor(CurrentProfileId)
final currentProfileIdProvider = CurrentProfileIdProvider._();

final class CurrentProfileIdProvider
    extends $NotifierProvider<CurrentProfileId, String?> {
  CurrentProfileIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentProfileIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentProfileIdHash();

  @$internal
  @override
  CurrentProfileId create() => CurrentProfileId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$currentProfileIdHash() => r'47b36af672faf5af4cb8150685aee0526e9a37ea';

abstract class _$CurrentProfileId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// The category the child tapped on the home screen (null = all groups). The
/// session is scoped to it.

@ProviderFor(SelectedCategory)
final selectedCategoryProvider = SelectedCategoryProvider._();

/// The category the child tapped on the home screen (null = all groups). The
/// session is scoped to it.
final class SelectedCategoryProvider
    extends $NotifierProvider<SelectedCategory, String?> {
  /// The category the child tapped on the home screen (null = all groups). The
  /// session is scoped to it.
  SelectedCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCategoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCategoryHash();

  @$internal
  @override
  SelectedCategory create() => SelectedCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedCategoryHash() => r'8aff637bb1b8f9ac78fceed352a5d3937dad93fb';

/// The category the child tapped on the home screen (null = all groups). The
/// session is scoped to it.

abstract class _$SelectedCategory extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Whether the next session browses images (learn) or tests (quiz). Chosen on
/// the home screen so the child is never surprised by a quiz while browsing.

@ProviderFor(SessionModeController)
final sessionModeControllerProvider = SessionModeControllerProvider._();

/// Whether the next session browses images (learn) or tests (quiz). Chosen on
/// the home screen so the child is never surprised by a quiz while browsing.
final class SessionModeControllerProvider
    extends $NotifierProvider<SessionModeController, SessionMode> {
  /// Whether the next session browses images (learn) or tests (quiz). Chosen on
  /// the home screen so the child is never surprised by a quiz while browsing.
  SessionModeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionModeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionModeControllerHash();

  @$internal
  @override
  SessionModeController create() => SessionModeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionMode>(value),
    );
  }
}

String _$sessionModeControllerHash() =>
    r'07741e6fd457e510414f0e80b4c5c1f1dcd35a09';

/// Whether the next session browses images (learn) or tests (quiz). Chosen on
/// the home screen so the child is never surprised by a quiz while browsing.

abstract class _$SessionModeController extends $Notifier<SessionMode> {
  SessionMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SessionMode, SessionMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SessionMode, SessionMode>,
              SessionMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(currentProfile)
final currentProfileProvider = CurrentProfileProvider._();

final class CurrentProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<ChildProfile?>,
          ChildProfile?,
          FutureOr<ChildProfile?>
        >
    with $FutureModifier<ChildProfile?>, $FutureProvider<ChildProfile?> {
  CurrentProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentProfileHash();

  @$internal
  @override
  $FutureProviderElement<ChildProfile?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ChildProfile?> create(Ref ref) {
    return currentProfile(ref);
  }
}

String _$currentProfileHash() => r'dad5e8eb8bfa2756f6a7711d99423d1e7a45b9c0';

@ProviderFor(ParentUnlocked)
final parentUnlockedProvider = ParentUnlockedProvider._();

final class ParentUnlockedProvider
    extends $NotifierProvider<ParentUnlocked, bool> {
  ParentUnlockedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'parentUnlockedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$parentUnlockedHash();

  @$internal
  @override
  ParentUnlocked create() => ParentUnlocked();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$parentUnlockedHash() => r'120b84fb77facbacbbdbd55224a2965ec9c8c59e';

abstract class _$ParentUnlocked extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(Muted)
final mutedProvider = MutedProvider._();

final class MutedProvider extends $AsyncNotifierProvider<Muted, bool> {
  MutedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mutedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mutedHash();

  @$internal
  @override
  Muted create() => Muted();
}

String _$mutedHash() => r'906dac69d7d455ffcbe0de0404d7f2e3413afdf9';

abstract class _$Muted extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(AppThemeMode)
final appThemeModeProvider = AppThemeModeProvider._();

final class AppThemeModeProvider
    extends $AsyncNotifierProvider<AppThemeMode, ThemeMode> {
  AppThemeModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemeModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appThemeModeHash();

  @$internal
  @override
  AppThemeMode create() => AppThemeMode();
}

String _$appThemeModeHash() => r'dab815812a296d3baf239c2fde15df20e5a74efa';

abstract class _$AppThemeMode extends $AsyncNotifier<ThemeMode> {
  FutureOr<ThemeMode> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ThemeMode>, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ThemeMode>, ThemeMode>,
              AsyncValue<ThemeMode>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
