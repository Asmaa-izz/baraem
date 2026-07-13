import 'package:drift/drift.dart';

import '../../core/utils/ids.dart';
import '../db/app_database.dart';
import '../models/domain.dart';
import '../models/enums.dart';
import '../models/mappers.dart';
import '../seed/content_seeder.dart';

/// Read + author content (categories, items, exemplars). Abstract so a sync
/// backend can replace the Drift implementation later without touching callers.
abstract class ContentRepository {
  Future<void> ensureSeeded();
  Future<List<Category>> getCategories({ContentSource? source});
  Stream<List<Category>> watchCategories();
  Future<List<Item>> getItemsByCategory(String categoryId);
  Future<Item?> getItem(String id);
  Future<List<Exemplar>> getExemplars(String itemId);

  /// Number of items per category id (for progress hints on the home screen).
  Future<Map<String, int>> itemCountByCategory();

  // Parent authoring (PRD §10).
  Future<Category> createUserCategory({required String name, required String icon});
  Future<Item> createUserItem({required String categoryId, required String label});

  /// Set (or clear, when null) the audio clip for any word — system or user.
  /// Played in place of TTS for that item.
  Future<void> updateItemAudio(String itemId, String? audioPath);
  Future<Exemplar> createUserExemplar({
    required String itemId,
    required String imagePath,
    String? audioPath,
  });
}

class DriftContentRepository implements ContentRepository {
  DriftContentRepository(this.db);

  final AppDatabase db;

  @override
  Future<void> ensureSeeded() => ContentSeeder(db).ensureSeeded();

  @override
  Future<List<Category>> getCategories({ContentSource? source}) async {
    final query = db.select(db.categories)
      ..orderBy([(c) => OrderingTerm.asc(c.orderIndex)]);
    if (source != null) query.where((c) => c.source.equalsValue(source));
    final rows = await query.get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Stream<List<Category>> watchCategories() {
    final query = db.select(db.categories)
      ..orderBy([(c) => OrderingTerm.asc(c.orderIndex)]);
    return query.watch().map((rows) => rows.map((r) => r.toDomain()).toList());
  }

  @override
  Future<List<Item>> getItemsByCategory(String categoryId) async {
    final rows = await (db.select(db.items)
          ..where((i) => i.categoryId.equals(categoryId))
          ..orderBy([
            (i) => OrderingTerm.asc(i.orderIndex),
            (i) => OrderingTerm.asc(i.id),
          ]))
        .get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<Item?> getItem(String id) async {
    final row = await (db.select(db.items)..where((i) => i.id.equals(id)))
        .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<List<Exemplar>> getExemplars(String itemId) async {
    final rows = await (db.select(db.exemplars)
          ..where((e) => e.itemId.equals(itemId))
          ..orderBy([(e) => OrderingTerm.asc(e.orderIndex)]))
        .get();
    return rows.map((r) => r.toDomain()).toList();
  }

  @override
  Future<Map<String, int>> itemCountByCategory() async {
    final rows = await db.select(db.items).get();
    final counts = <String, int>{};
    for (final r in rows) {
      counts[r.categoryId] = (counts[r.categoryId] ?? 0) + 1;
    }
    return counts;
  }

  @override
  Future<Category> createUserCategory({
    required String name,
    required String icon,
  }) async {
    final cats = await db.select(db.categories).get();
    final maxOrder =
        cats.isEmpty ? 0 : cats.map((c) => c.orderIndex).reduce((a, b) => a > b ? a : b);
    final id = newId();
    await db.into(db.categories).insert(
          CategoriesCompanion.insert(
            id: id,
            name: name,
            icon: icon,
            orderIndex: maxOrder + 1,
            source: ContentSource.user,
          ),
        );
    return (await getCategoryById(id))!;
  }

  Future<Category?> getCategoryById(String id) async {
    final row = await (db.select(db.categories)..where((c) => c.id.equals(id)))
        .getSingleOrNull();
    return row?.toDomain();
  }

  @override
  Future<Item> createUserItem({
    required String categoryId,
    required String label,
  }) async {
    final id = newId();
    final existing = await getItemsByCategory(categoryId);
    await db.into(db.items).insert(
          ItemsCompanion.insert(
            id: id,
            label: label,
            categoryId: categoryId,
            source: ContentSource.user,
            orderIndex: Value(existing.length),
          ),
        );
    return (await getItem(id))!;
  }

  @override
  Future<void> updateItemAudio(String itemId, String? audioPath) async {
    await (db.update(db.items)..where((i) => i.id.equals(itemId)))
        .write(ItemsCompanion(audioPath: Value(audioPath)));
  }

  @override
  Future<Exemplar> createUserExemplar({
    required String itemId,
    required String imagePath,
    String? audioPath,
  }) async {
    final id = newId();
    final existing = await getExemplars(itemId);
    await db.into(db.exemplars).insert(
          ExemplarsCompanion.insert(
            id: id,
            itemId: itemId,
            imagePath: imagePath,
            audioPath: Value(audioPath),
            orderIndex: Value(existing.length + 1),
            hasImage: const Value(true), // user files exist on disk
            source: ContentSource.user,
          ),
        );
    final row = await (db.select(db.exemplars)..where((e) => e.id.equals(id)))
        .getSingle();
    return row.toDomain();
  }
}
