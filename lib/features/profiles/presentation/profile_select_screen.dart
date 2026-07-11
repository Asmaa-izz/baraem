import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/baraem_tokens.dart';
import '../../../core/theme/context_ext.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/profile_avatar.dart';
import '../../../data/models/domain.dart';
import 'profile_create_sheet.dart';

/// S1 — pick a child profile, or enter the parent area.
class ProfileSelectScreen extends ConsumerWidget {
  const ProfileSelectScreen({super.key});

  static const _accents = [0, 1, 2, 3, 4];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final colors = context.colors;
    final profilesAsync = ref.watch(profilesProvider);

    Color accentFor(int i) => [
          colors.sky,
          colors.lavender,
          colors.apricot,
          colors.honey,
          colors.sage,
        ][i % _accents.length];

    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(l.appName, style: context.texts.displaySmall),
              const Spacer(),
              IconButton(
                tooltip: l.parentArea,
                onPressed: () => context.go('/parent-gate'),
                icon: Icon(Icons.lock_outline_rounded, color: colors.ink2),
                iconSize: 28,
              ),
            ],
          ),
          Text(l.appTagline, style: context.texts.bodyMedium),
          Expanded(
            child: profilesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
              data: (profiles) => Center(
                child: SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: BaraemSpace.xl,
                    runSpacing: BaraemSpace.xl,
                    children: [
                      for (final (i, p) in profiles.indexed)
                        ProfileAvatar(
                          name: p.name,
                          emoji: p.avatar,
                          accent: accentFor(i),
                          onTap: () => _select(context, ref, p),
                        ),
                      _AddProfileButton(
                        onTap: () => showCreateProfileSheet(context, ref),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _select(BuildContext context, WidgetRef ref, ChildProfile p) {
    ref.read(currentProfileIdProvider.notifier).select(p.id);
    context.go('/home');
  }
}

class _AddProfileButton extends StatelessWidget {
  const _AddProfileButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colors = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppCard(
          onTap: onTap,
          radius: BaraemRadii.pill,
          padding: EdgeInsets.zero,
          borderColor: colors.lineStrong,
          shadow: false,
          child: SizedBox(
            width: BaraemSize.avatar,
            height: BaraemSize.avatar,
            child: Icon(Icons.add_rounded, color: colors.ink2, size: 36),
          ),
        ),
        const SizedBox(height: BaraemSpace.sm),
        Text(l.addProfile,
            style: TextStyle(fontFamily: kBodyFont, color: colors.ink2)),
      ],
    );
  }
}
