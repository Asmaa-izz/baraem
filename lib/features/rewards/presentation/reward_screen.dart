import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/baraem_tokens.dart';
import '../../../core/theme/context_ext.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/garden_view.dart';

/// S5 — the cumulative garden grows with each mastered word.
class RewardScreen extends ConsumerWidget {
  const RewardScreen({super.key, this.masteredThisSession = 0});

  final int masteredThisSession;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final id = ref.watch(currentProfileIdProvider);

    return AppScaffold(
      child: FutureBuilder<int>(
        future: id == null ? Future.value(0) : _masteredCount(ref, id),
        builder: (context, snapshot) {
          final count = snapshot.data ?? 0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: BaraemSpace.lg),
              Text(l.gardenGrowing,
                  style: context.texts.displaySmall, textAlign: TextAlign.center),
              const SizedBox(height: BaraemSpace.sm),
              Text(l.masteredWords(count),
                  style: context.texts.bodyLarge, textAlign: TextAlign.center),
              const SizedBox(height: BaraemSpace.xl),
              Expanded(
                child: SingleChildScrollView(
                  child: GardenView(
                    count: count,
                    newlyEarnedIndex:
                        masteredThisSession > 0 ? count - 1 : null,
                  ),
                ),
              ),
              const SizedBox(height: BaraemSpace.lg),
              AppButton.primary(
                label: l.keepGoing,
                onPressed: () => context.go('/home'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<int> _masteredCount(WidgetRef ref, String childId) async {
    final summary = await ref.read(reportsRepositoryProvider).getSummary(childId);
    return summary.mastered + summary.archived;
  }
}
