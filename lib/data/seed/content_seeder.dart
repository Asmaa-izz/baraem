import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../db/app_database.dart';
import '../models/enums.dart';

/// Loads the bundled system content (`assets/content/content.json`) into the
/// database. Idempotent: deterministic ids + upsert on system rows only, so
/// re-running never duplicates and never touches user content.
class ContentSeeder {
  ContentSeeder(this.db, {AssetBundle? bundle}) : bundle = bundle ?? rootBundle;

  final AppDatabase db;
  final AssetBundle bundle;

  static const int seedVersion = 3;
  static const String _seedKey = 'seed_version';

  /// Default system voice (see `voices` in content.json).
  static const String _defaultVoice = 'sana';

  Future<void> ensureSeeded() async {
    final raw = await bundle.loadString('assets/content/content.json');
    final spec = jsonDecode(raw) as Map<String, dynamic>;

    // Which of the declared assets actually shipped in this build. If the
    // manifest can't be read, degrade gracefully (emoji + TTS fallback).
    Set<String> present;
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(bundle);
      present = manifest.listAssets().toSet();
    } catch (_) {
      present = <String>{};
    }

    await db.transaction(() async {
      for (final cat in (spec['categories'] as List)) {
        final catId = cat['id'] as String;
        await db.into(db.categories).insertOnConflictUpdate(
              CategoriesCompanion.insert(
                id: catId,
                name: cat['name'] as String,
                icon: cat['icon'] as String,
                orderIndex: cat['order'] as int,
                source: ContentSource.system,
              ),
            );

        final items = cat['items'] as List;
        for (var itemIndex = 0; itemIndex < items.length; itemIndex++) {
          final item = items[itemIndex];
          final itemId = item['id'] as String;

          // Per-item audio: bundled `<cat>/<item>/audio/<voice>.mp3` if present.
          final audioPath = 'assets/content/$catId/$itemId/audio/$_defaultVoice.mp3';
          final hasAudio = present.contains(audioPath);

          await db.into(db.items).insertOnConflictUpdate(
                ItemsCompanion.insert(
                  id: itemId,
                  label: item['label'] as String,
                  categoryId: catId,
                  speech: Value(item['speech'] as String?),
                  audioPath: Value(hasAudio ? audioPath : null),
                  source: ContentSource.system,
                  orderIndex: Value(itemIndex),
                ),
              );

          // `subjects` is the current key; fall back to legacy `exemplars`.
          final subjects =
              (item['subjects'] ?? item['exemplars'] ?? const []) as List;
          for (var i = 0; i < subjects.length; i++) {
            final n = i + 1;
            final path = 'assets/content/$catId/$itemId/$n.jpg';
            await db.into(db.exemplars).insertOnConflictUpdate(
                  ExemplarsCompanion.insert(
                    id: '${catId}_${itemId}_$n',
                    itemId: itemId,
                    imagePath: path,
                    orderIndex: Value(n),
                    hasImage: Value(present.contains(path)),
                    source: ContentSource.system,
                  ),
                );
          }
        }
      }

      // Encouragement clips. insertOrIgnore so a parent's soft-delete
      // (enabled=false) survives re-seeding on every launch.
      for (final praise in (spec['praises'] as List? ?? const [])) {
        final id = praise['id'] as String;
        await db.into(db.praises).insert(
              PraisesCompanion.insert(
                id: id,
                label: praise['label'] as String,
                audioPath: 'assets/content/praise/$id.mp3',
                source: ContentSource.system,
              ),
              mode: InsertMode.insertOrIgnore,
            );
      }

      await db.setSetting(_seedKey, '$seedVersion');
    });
  }
}
