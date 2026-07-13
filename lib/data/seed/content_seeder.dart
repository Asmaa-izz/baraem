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

  static const int seedVersion = 5;
  static const String _seedKey = 'seed_version';

  Future<void> ensureSeeded() async {
    final raw = await bundle.loadString('assets/content/content.json');
    final spec = jsonDecode(raw) as Map<String, dynamic>;

    // Voices shipped with the app (e.g. أنثى «سنا» + ذكر «تيم»). Each becomes a
    // system Sound per item/praise word when its clip actually shipped.
    final voices = (spec['voices'] as List? ?? const []);

    // Regular images occupy 1..styleCount (one per art style). Section images
    // ("الجزء" — cut-open views) are numbered after them; this base must match
    // `len(styles)` in tools/generate_content_images.py so files and exemplars
    // line up.
    final styleCount = (spec['styles'] as List?)?.length ?? 5;

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

          await db.into(db.items).insertOnConflictUpdate(
                ItemsCompanion.insert(
                  id: itemId,
                  label: item['label'] as String,
                  categoryId: catId,
                  speech: Value(item['speech'] as String?),
                  source: ContentSource.system,
                  orderIndex: Value(itemIndex),
                ),
              );

          // One system Sound per shipped voice: `<cat>/<item>/audio/<voice>.mp3`.
          // insertOrIgnore so a parent's soft-delete (enabled=false) survives
          // re-seeding on every launch.
          for (var v = 0; v < voices.length; v++) {
            final voice = voices[v] as Map<String, dynamic>;
            final voiceId = voice['id'] as String;
            final voicePath = 'assets/content/$catId/$itemId/audio/$voiceId.mp3';
            if (!present.contains(voicePath)) continue;
            await db.into(db.sounds).insert(
                  SoundsCompanion.insert(
                    id: 'snd_item_${itemId}_$voiceId',
                    ownerType: SoundOwner.item,
                    ownerId: itemId,
                    label: Value(voice['label'] as String?),
                    audioPath: voicePath,
                    source: ContentSource.system,
                    orderIndex: Value(v),
                  ),
                  mode: InsertMode.insertOrIgnore,
                );
          }

          // `subjects` is the current key; fall back to legacy `exemplars`.
          final subjects =
              (item['subjects'] ?? item['exemplars'] ?? const []) as List;
          // `sections` (optional) = cut-open "الجزء" views, generated after the
          // regular images. Both become exemplars in the same rotation pool.
          final sections = (item['sections'] ?? const []) as List;
          final imageNames = <int>[
            for (var i = 0; i < subjects.length; i++) i + 1,
            for (var i = 0; i < sections.length; i++) styleCount + i + 1,
          ];
          for (final n in imageNames) {
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

      // Encouragement words + one system voice clip each per shipped voice
      // (`praise/<id>_<voice>.mp3`). insertOrIgnore so a parent's soft-delete
      // (enabled=false) survives re-seeding on every launch.
      for (final praise in (spec['praises'] as List? ?? const [])) {
        final id = praise['id'] as String;
        await db.into(db.praises).insert(
              PraisesCompanion.insert(
                id: id,
                label: praise['label'] as String,
                source: ContentSource.system,
              ),
              mode: InsertMode.insertOrIgnore,
            );
        for (var v = 0; v < voices.length; v++) {
          final voice = voices[v] as Map<String, dynamic>;
          final voiceId = voice['id'] as String;
          final voicePath = 'assets/content/praise/${id}_$voiceId.mp3';
          if (!present.contains(voicePath)) continue;
          await db.into(db.sounds).insert(
                SoundsCompanion.insert(
                  id: 'snd_praise_${id}_$voiceId',
                  ownerType: SoundOwner.praise,
                  ownerId: id,
                  label: Value(voice['label'] as String?),
                  audioPath: voicePath,
                  source: ContentSource.system,
                  orderIndex: Value(v),
                ),
                mode: InsertMode.insertOrIgnore,
              );
        }
      }

      await db.setSetting(_seedKey, '$seedVersion');
    });
  }
}
