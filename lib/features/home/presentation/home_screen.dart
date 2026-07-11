import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/baraem_tokens.dart';
import '../../../core/theme/context_ext.dart';
import '../../../core/utils/arabic_numbers.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../data/models/domain.dart';
import '../../../data/models/enums.dart';
import '../../engine/engine_models.dart';
import '../../engine/session_controller.dart';

class _CategoryCardData {
  const _CategoryCardData(this.category, this.total, this.mastered);
  final Category category;
  final int total;
  final int mastered;
}

/// S2 — greet the child and pick a group to learn.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final colors = context.colors;
    final profileAsync = ref.watch(currentProfileProvider);

    return profileAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (profile) {
        if (profile == null) {
          // No active profile — bounce home after this frame.
          WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/'));
          return const Scaffold(body: SizedBox.shrink());
        }
        return AppScaffold(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(profile.avatar, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: BaraemSpace.sm),
                  Expanded(
                    child: Text(l.greeting(profile.name),
                        style: context.texts.titleLarge),
                  ),
                  IconButton(
                    tooltip: l.parentArea,
                    onPressed: () => context.go('/parent-gate'),
                    icon: Icon(Icons.lock_outline_rounded, color: colors.ink2),
                  ),
                ],
              ),
              const SizedBox(height: BaraemSpace.md),
              _ModeToggle(
                mode: ref.watch(sessionModeControllerProvider),
                onChanged: (m) =>
                    ref.read(sessionModeControllerProvider.notifier).set(m),
              ),
              const SizedBox(height: BaraemSpace.xs),
              Text(l.chooseModeHint,
                  style: context.texts.bodySmall, textAlign: TextAlign.center),
              const SizedBox(height: BaraemSpace.md),
              Expanded(
                child: FutureBuilder<List<_CategoryCardData>>(
                  future: _load(ref, profile.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final data = snapshot.data!;
                    return GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: BaraemSpace.md,
                      crossAxisSpacing: BaraemSpace.md,
                      childAspectRatio: 0.92,
                      children: [
                        for (final d in data)
                          _CategoryCard(
                            data: d,
                            onTap: () => _start(context, ref, d.category.id),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: BaraemSpace.md),
              AppButton.primary(
                label: l.allGroups,
                onPressed: () => _start(context, ref, null),
                leadingIcon: Icons.play_arrow_rounded,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<List<_CategoryCardData>> _load(WidgetRef ref, String childId) async {
    final content = ref.read(contentRepositoryProvider);
    final cats = await content.getCategories();
    final counts = await content.itemCountByCategory();
    final progress = await ref.read(reportsRepositoryProvider).perItemProgress(childId);
    final masteredByCat = <String, int>{};
    for (final p in progress) {
      if (p.status == ItemStatus.mastered || p.status == ItemStatus.archived) {
        masteredByCat[p.categoryId] = (masteredByCat[p.categoryId] ?? 0) + 1;
      }
    }
    return [
      for (final c in cats)
        _CategoryCardData(c, counts[c.id] ?? 0, masteredByCat[c.id] ?? 0),
    ];
  }

  void _start(BuildContext context, WidgetRef ref, String? categoryId) {
    ref.read(selectedCategoryProvider.notifier).select(categoryId);
    // Start a fresh session each time.
    final id = ref.read(currentProfileIdProvider);
    if (id != null) ref.invalidate(sessionControllerProvider(id));
    context.go('/session');
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.mode, required this.onChanged});

  final SessionMode mode;
  final ValueChanged<SessionMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Center(
      child: SegmentedButton<SessionMode>(
        segments: [
          ButtonSegment(
            value: SessionMode.learn,
            icon: const Icon(Icons.photo_library_outlined),
            label: Text(l.learnTitle),
          ),
          ButtonSegment(
            value: SessionMode.quiz,
            icon: const Icon(Icons.quiz_outlined),
            label: Text(l.quizTitle),
          ),
        ],
        selected: {mode},
        onSelectionChanged: (s) => onChanged(s.first),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.data, required this.onTap});

  final _CategoryCardData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = colors.category(data.category.id);
    return AppCard(
      onTap: onTap,
      startBorderAccent: accent,
      padding: const EdgeInsets.all(BaraemSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: BaraemSize.categoryDot,
                height: BaraemSize.categoryDot,
                decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              ),
              const Spacer(),
              Text(data.category.icon, style: const TextStyle(fontSize: 40)),
            ],
          ),
          const Spacer(),
          Text(data.category.name, style: context.texts.titleMedium),
          const SizedBox(height: 2),
          Text(
            l10nProgress(context, data.mastered, data.total),
            style: TextStyle(
              fontFamily: kBodyFont,
              fontFeatures: const [FontFeature.tabularFigures()],
              color: colors.ink2,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  String l10nProgress(BuildContext context, int done, int total) {
    return '${arabicNumber(done)} / ${arabicNumber(total)}';
  }
}
