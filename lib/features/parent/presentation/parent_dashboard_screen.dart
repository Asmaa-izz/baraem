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
import '../../../data/models/domain.dart';
import '../../../data/models/enums.dart';
import '../../../data/models/reports.dart';
import '../../profiles/presentation/profile_create_sheet.dart';

/// S7 — parent dashboard: reports, content, settings, profiles.
class ParentDashboardScreen extends ConsumerWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: context.colors.ground,
        appBar: AppBar(
          backgroundColor: context.colors.ground,
          title: Text(l.parentArea, style: context.texts.titleLarge),
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () {
              ref.read(parentUnlockedProvider.notifier).lock();
              context.go('/');
            },
          ),
          bottom: TabBar(
            isScrollable: true,
            labelColor: context.colors.sageDeep,
            unselectedLabelColor: context.colors.ink2,
            indicatorColor: context.colors.sage,
            tabs: [
              Tab(text: l.tabReports),
              Tab(text: l.tabContent),
              Tab(text: l.tabSettings),
              Tab(text: l.tabProfiles),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ReportsTab(),
            _ContentTab(),
            _SettingsTab(),
            _ProfilesTab(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Reports

class _ReportsTab extends ConsumerWidget {
  const _ReportsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final profileAsync = ref.watch(currentProfileProvider);
    return profileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (profile) {
        if (profile == null) return _NoChildHint(l);
        return FutureBuilder<(ProgressSummary, List<ItemProgress>)>(
          future: _load(ref, profile.id),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final (summary, items) = snap.data!;
            if (summary.totalItems == 0) return _NoDataHint(l);
            return ListView(
              padding: const EdgeInsets.all(BaraemSpace.lg),
              children: [
                Wrap(
                  spacing: BaraemSpace.sm,
                  runSpacing: BaraemSpace.sm,
                  children: [
                    _StatTile(l.reportNew, summary.newCount, context.colors.sky),
                    _StatTile(l.reportLearning, summary.learning,
                        context.colors.apricot),
                    _StatTile(l.reportMastered, summary.mastered,
                        context.colors.sage),
                    _StatTile(l.reportArchived, summary.archived,
                        context.colors.lavender),
                  ],
                ),
                const SizedBox(height: BaraemSpace.md),
                AppCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l.reportAccuracy, style: context.texts.bodyLarge),
                      Text(
                        '${arabicNumber((summary.accuracy * 100).round())}٪',
                        style: const TextStyle(
                          fontFamily: kBodyFont,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: BaraemSpace.md),
                Text(l.reportPerItem, style: context.texts.titleMedium),
                const SizedBox(height: BaraemSpace.sm),
                for (final ip in items) _ItemProgressRow(ip),
              ],
            );
          },
        );
      },
    );
  }

  Future<(ProgressSummary, List<ItemProgress>)> _load(
    WidgetRef ref,
    String childId,
  ) async {
    final reports = ref.read(reportsRepositoryProvider);
    final summary = await reports.getSummary(childId);
    final items = await reports.perItemProgress(childId);
    return (summary, items);
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile(this.label, this.value, this.color);
  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(BaraemSpace.md),
      decoration: BoxDecoration(
        color: Color.alphaBlend(color.withValues(alpha: 0.16), context.colors.card),
        borderRadius: BorderRadius.circular(BaraemRadii.md),
        border: Border.all(color: context.colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            arabicNumber(value),
            style: const TextStyle(
              fontFamily: kDisplayFont,
              fontWeight: FontWeight.w700,
              fontSize: 30,
            ),
          ),
          Text(label, style: context.texts.bodySmall),
        ],
      ),
    );
  }
}

class _ItemProgressRow extends StatelessWidget {
  const _ItemProgressRow(this.ip);
  final ItemProgress ip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: AppCard(
        padding: const EdgeInsets.symmetric(
            horizontal: BaraemSpace.md, vertical: BaraemSpace.sm),
        child: Row(
          children: [
            Expanded(child: Text(ip.label, style: context.texts.bodyLarge)),
            Text(
              ip.status.label,
              style: TextStyle(
                  fontFamily: kBodyFont, color: colors.ink2, fontSize: 14),
            ),
            const SizedBox(width: BaraemSpace.md),
            Text(
              '${arabicNumber(ip.correct)}/${arabicNumber(ip.total)}',
              style: const TextStyle(
                fontFamily: kBodyFont,
                fontFeatures: [FontFeature.tabularFigures()],
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Content

class _ContentTab extends ConsumerWidget {
  const _ContentTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Stack(
      children: [
        FutureBuilder<List<(Category, List<Item>)>>(
          future: _load(ref),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              padding: const EdgeInsets.fromLTRB(
                  BaraemSpace.md, BaraemSpace.md, BaraemSpace.md, 96),
              children: [
                for (final (cat, items) in snap.data!)
                  Card(
                    color: context.colors.card,
                    child: ExpansionTile(
                      leading: Text(cat.icon, style: const TextStyle(fontSize: 24)),
                      title: Text(cat.name, style: context.texts.titleMedium),
                      children: [
                        for (final item in items)
                          ListTile(
                            title: Text(item.label),
                            trailing: item.source == ContentSource.user
                                ? Icon(Icons.person_outline,
                                    color: context.colors.ink2, size: 18)
                                : null,
                          ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
        Positioned.directional(
          textDirection: Directionality.of(context),
          end: BaraemSpace.lg,
          bottom: BaraemSpace.lg,
          child: FloatingActionButton.extended(
            backgroundColor: context.colors.sageDeep,
            foregroundColor: context.colors.onAccent,
            onPressed: () => context.go('/parent/item/new'),
            icon: const Icon(Icons.add_rounded),
            label: Text(l.addItem),
          ),
        ),
      ],
    );
  }

  Future<List<(Category, List<Item>)>> _load(WidgetRef ref) async {
    final content = ref.read(contentRepositoryProvider);
    final cats = await content.getCategories();
    return [
      for (final c in cats) (c, await content.getItemsByCategory(c.id)),
    ];
  }
}

// ---------------------------------------------------------------- Settings

class _SettingsTab extends ConsumerWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final profileAsync = ref.watch(currentProfileProvider);
    final muted = ref.watch(mutedProvider).value ?? false;
    final themeMode = ref.watch(appThemeModeProvider).value ?? ThemeMode.system;

    return ListView(
      padding: const EdgeInsets.all(BaraemSpace.lg),
      children: [
        profileAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (e, _) => Text('$e'),
          data: (profile) {
            if (profile == null) return _NoChildHint(l);
            return _ProfileSettings(profile: profile);
          },
        ),
        const SizedBox(height: BaraemSpace.lg),
        AppCard(
          child: Column(
            children: [
              SwitchListTile(
                value: muted,
                onChanged: (_) => ref.read(mutedProvider.notifier).toggle(),
                title: Text(l.settingsMute),
                activeThumbColor: context.colors.sage,
                contentPadding: EdgeInsets.zero,
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.settingsTheme),
                trailing: DropdownButton<ThemeMode>(
                  value: themeMode,
                  underline: const SizedBox.shrink(),
                  onChanged: (m) {
                    if (m != null) {
                      ref.read(appThemeModeProvider.notifier).set(m);
                    }
                  },
                  items: [
                    DropdownMenuItem(
                        value: ThemeMode.system, child: Text(l.themeSystem)),
                    DropdownMenuItem(
                        value: ThemeMode.light, child: Text(l.themeLight)),
                    DropdownMenuItem(
                        value: ThemeMode.dark, child: Text(l.themeDark)),
                  ],
                ),
              ),
              const Divider(height: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.celebration_outlined,
                    color: context.colors.honey),
                title: Text(l.praiseSounds),
                subtitle: Text(l.praiseSoundsHint),
                trailing: const Icon(Icons.chevron_left_rounded),
                onTap: () => context.go('/parent/praises'),
              ),
            ],
          ),
        ),
        const SizedBox(height: BaraemSpace.xl),
        AppButton(
          label: l.resetDefaults,
          variant: AppButtonVariant.secondary,
          leadingIcon: Icons.restart_alt_rounded,
          onPressed: () => _confirmReset(context, ref),
        ),
      ],
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l.resetDefaults),
        content: Text(l.resetConfirm),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.cancel)),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l.resetDefaults)),
        ],
      ),
    );
    if (ok != true) return;

    // Re-enable/restore default praises, reset app + current-profile settings.
    await ref.read(praiseRepositoryProvider).resetPraises();
    final settings = ref.read(settingsRepositoryProvider);
    await settings.setMuted(false);
    await settings.setThemeMode('system');

    final id = ref.read(currentProfileIdProvider);
    if (id != null) {
      final profile = await ref.read(profileRepositoryProvider).getProfile(id);
      if (profile != null) {
        await ref.read(profileRepositoryProvider).updateProfile(profile.copyWith(
              choicesCount: 2,
              activeWindowSize: 5,
              masteryThreshold: 3,
              sessionLength: profile.mode == ProfileMode.support ? 8 : 12,
            ));
      }
    }

    ref.invalidate(currentProfileProvider);
    ref.invalidate(mutedProvider);
    ref.invalidate(appThemeModeProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.resetDone)));
    }
  }
}

class _ProfileSettings extends ConsumerWidget {
  const _ProfileSettings({required this.profile});
  final ChildProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    Future<void> save(ChildProfile p) async {
      await ref.read(profileRepositoryProvider).updateProfile(p);
      ref.invalidate(currentProfileProvider);
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(profile.name, style: context.texts.titleMedium),
          const SizedBox(height: BaraemSpace.md),
          Text(l.settingsMode, style: context.texts.bodyMedium),
          const SizedBox(height: BaraemSpace.xs),
          SegmentedButton<ProfileMode>(
            segments: [
              ButtonSegment(value: ProfileMode.normal, label: Text(l.modeNormal)),
              ButtonSegment(value: ProfileMode.support, label: Text(l.modeSupport)),
            ],
            selected: {profile.mode},
            onSelectionChanged: (s) => save(profile.copyWith(mode: s.first)),
          ),
          const SizedBox(height: BaraemSpace.md),
          _Stepper(
            label: l.settingsChoices,
            value: profile.choicesCount,
            min: 2,
            max: 4,
            onChanged: (v) => save(profile.copyWith(choicesCount: v)),
          ),
          _Stepper(
            label: l.settingsSessionLength,
            value: profile.sessionLength,
            min: 4,
            max: 20,
            step: 2,
            onChanged: (v) => save(profile.copyWith(sessionLength: v)),
          ),
          _Stepper(
            label: l.settingsActiveWindow,
            value: profile.activeWindowSize,
            min: 3,
            max: 10,
            onChanged: (v) => save(profile.copyWith(activeWindowSize: v)),
          ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.step = 1,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final int step;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: context.texts.bodyLarge)),
        IconButton(
          onPressed: value > min ? () => onChanged(value - step) : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Text(arabicNumber(value),
            style: const TextStyle(
                fontFamily: kBodyFont, fontWeight: FontWeight.w700, fontSize: 18)),
        IconButton(
          onPressed: value < max ? () => onChanged(value + step) : null,
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------- Profiles

class _ProfilesTab extends ConsumerWidget {
  const _ProfilesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final profilesAsync = ref.watch(profilesProvider);
    final currentId = ref.watch(currentProfileIdProvider);

    return Stack(
      children: [
        profilesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (profiles) => ListView(
            padding: const EdgeInsets.fromLTRB(
                BaraemSpace.md, BaraemSpace.md, BaraemSpace.md, 96),
            children: [
              for (final p in profiles)
                Card(
                  color: context.colors.card,
                  child: ListTile(
                    leading: Text(p.avatar, style: const TextStyle(fontSize: 28)),
                    title: Text(p.name),
                    subtitle: Text(p.mode.label),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (p.id == currentId)
                          Icon(Icons.check_circle,
                              color: context.colors.sage)
                        else
                          TextButton(
                            onPressed: () => ref
                                .read(currentProfileIdProvider.notifier)
                                .select(p.id),
                            child: Text(l.startSession),
                          ),
                        IconButton(
                          icon: Icon(Icons.delete_outline,
                              color: context.colors.ink2),
                          onPressed: () => _confirmDelete(context, ref, p),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        Positioned.directional(
          textDirection: Directionality.of(context),
          end: BaraemSpace.lg,
          bottom: BaraemSpace.lg,
          child: FloatingActionButton.extended(
            backgroundColor: context.colors.sageDeep,
            foregroundColor: context.colors.onAccent,
            onPressed: () => showCreateProfileSheet(context, ref),
            icon: const Icon(Icons.add_rounded),
            label: Text(l.addProfile),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, ChildProfile p) async {
    final l = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(p.name),
        content: Text('${l.delete}؟'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.cancel)),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l.delete)),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(profileRepositoryProvider).deleteProfile(p.id);
      if (ref.read(currentProfileIdProvider) == p.id) {
        ref.read(currentProfileIdProvider.notifier).select(null);
      }
    }
  }
}

// ---------------------------------------------------------------- helpers

class _NoChildHint extends StatelessWidget {
  const _NoChildHint(this.l);
  final AppLocalizations l;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(BaraemSpace.xl),
        child: Text(l.tabProfiles, style: context.texts.bodyLarge),
      );
}

class _NoDataHint extends StatelessWidget {
  const _NoDataHint(this.l);
  final AppLocalizations l;
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(BaraemSpace.xl),
          child: Text(l.reportNoData,
              style: context.texts.bodyLarge, textAlign: TextAlign.center),
        ),
      );
}
