import 'dart:math';

import 'package:flutter/material.dart' show ThemeMode;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/engine/engine_models.dart';
import '../core/utils/clock.dart';
import '../data/db/app_database.dart';
import '../data/models/domain.dart';
import '../data/repositories/content_repository.dart';
import '../data/repositories/learning_repository.dart';
import '../data/repositories/praise_repository.dart';
import '../data/repositories/profile_repository.dart';
import '../data/repositories/reports_repository.dart';
import '../data/repositories/settings_repository.dart';
import '../features/engine/learning_engine.dart';

part 'providers.g.dart';

// ---- infrastructure (kept alive for the app's lifetime) ----

@Riverpod(keepAlive: true)
Clock clock(Ref ref) => const SystemClock();

@Riverpod(keepAlive: true)
Random random(Ref ref) => Random();

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

// ---- repositories ----

@Riverpod(keepAlive: true)
ContentRepository contentRepository(Ref ref) =>
    DriftContentRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) =>
    DriftProfileRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
LearningRepository learningRepository(Ref ref) =>
    DriftLearningRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
ReportsRepository reportsRepository(Ref ref) =>
    DriftReportsRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) =>
    DriftSettingsRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
PraiseRepository praiseRepository(Ref ref) =>
    DriftPraiseRepository(ref.watch(appDatabaseProvider));

/// All encouragement clips (system + user). The parent list watches it; the
/// session filters it to enabled clips for playback.
@riverpod
Stream<List<Praise>> praises(Ref ref) =>
    ref.watch(praiseRepositoryProvider).watchPraises();

@Riverpod(keepAlive: true)
LearningEngine learningEngine(Ref ref) => LearningEngine(
      clock: ref.watch(clockProvider),
      random: ref.watch(randomProvider),
    );

// ---- app bootstrap (splash gates on this) ----

@Riverpod(keepAlive: true)
Future<void> appBootstrap(Ref ref) =>
    ref.watch(contentRepositoryProvider).ensureSeeded();

// ---- profiles + selection ----

@riverpod
Stream<List<ChildProfile>> profiles(Ref ref) =>
    ref.watch(profileRepositoryProvider).watchProfiles();

// keepAlive: session selection must survive route transitions. If auto-dispose,
// selecting a profile then navigating would reset it to null before the target
// screen reads it (the target would bounce back to the profile screen).
@Riverpod(keepAlive: true)
class CurrentProfileId extends _$CurrentProfileId {
  @override
  String? build() => null;

  void select(String? id) => state = id;
}

/// The category the child tapped on the home screen (null = all groups). The
/// session is scoped to it.
@Riverpod(keepAlive: true)
class SelectedCategory extends _$SelectedCategory {
  @override
  String? build() => null;

  void select(String? id) => state = id;
}

/// Whether the next session browses images (learn) or tests (quiz). Chosen on
/// the home screen so the child is never surprised by a quiz while browsing.
@Riverpod(keepAlive: true)
class SessionModeController extends _$SessionModeController {
  @override
  SessionMode build() => SessionMode.learn;

  void set(SessionMode mode) => state = mode;
}

@riverpod
Future<ChildProfile?> currentProfile(Ref ref) async {
  final id = ref.watch(currentProfileIdProvider);
  if (id == null) return null;
  return ref.watch(profileRepositoryProvider).getProfile(id);
}

// ---- parent gate (session-scoped unlock) ----

// keepAlive: the unlock must persist from the PIN gate to the dashboard, or the
// go_router redirect would bounce back to the gate mid-navigation.
@Riverpod(keepAlive: true)
class ParentUnlocked extends _$ParentUnlocked {
  @override
  bool build() => false;

  void unlock() => state = true;
  void lock() => state = false;
}

// ---- audio mute ----

@riverpod
class Muted extends _$Muted {
  @override
  Future<bool> build() => ref.watch(settingsRepositoryProvider).isMuted();

  Future<void> toggle() async {
    final next = !(state.value ?? false);
    await ref.read(settingsRepositoryProvider).setMuted(next);
    state = AsyncData(next);
  }
}

// ---- theme override (parent settings) ----

@riverpod
class AppThemeMode extends _$AppThemeMode {
  @override
  Future<ThemeMode> build() async {
    final v = await ref.watch(settingsRepositoryProvider).getThemeMode();
    return switch (v) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> set(ThemeMode mode) async {
    await ref.read(settingsRepositoryProvider).setThemeMode(mode.name);
    state = AsyncData(mode);
  }
}
