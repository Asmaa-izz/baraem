import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/baraem_tokens.dart';
import '../../../core/theme/context_ext.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/domain.dart';
import '../../../data/models/enums.dart';
import 'sound_list_sheet.dart';

/// Parent screen: list encouragement *words* (e.g. «شاطر»), each with its own
/// pool of voices. Tap a word to listen to / add / delete its voices. Deleting a
/// system word is cosmetic (enabled=false); the reset button restores defaults.
class PraiseManagerScreen extends ConsumerWidget {
  const PraiseManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final colors = context.colors;
    final praisesAsync = ref.watch(praisesProvider);

    return Scaffold(
      backgroundColor: colors.ground,
      appBar: AppBar(
        backgroundColor: colors.ground,
        title: Text(l.praiseSounds, style: context.texts.titleLarge),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.go('/parent'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: colors.sageDeep,
        foregroundColor: colors.onAccent,
        onPressed: () => _showAddWordSheet(context, ref),
        icon: const Icon(Icons.add_rounded),
        label: Text(l.addPraiseWord),
      ),
      body: praisesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (praises) => ListView(
          padding: const EdgeInsets.fromLTRB(
              BaraemSpace.md, BaraemSpace.md, BaraemSpace.md, 96),
          children: [
            Text(l.praiseSoundsHint, style: context.texts.bodyMedium),
            const SizedBox(height: BaraemSpace.md),
            for (final p in praises) _PraiseRow(praise: p),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddWordSheet(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.ground,
      showDragHandle: true,
      builder: (_) => const _AddPraiseWordSheet(),
    );
  }
}

class _PraiseRow extends ConsumerWidget {
  const _PraiseRow({required this.praise});
  final Praise praise;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final colors = context.colors;
    final repo = ref.read(praiseRepositoryProvider);
    final enabled = praise.enabled;
    final soundsAsync =
        ref.watch(soundsProvider(SoundOwner.praise, praise.id));
    final voiceCount = soundsAsync.maybeWhen(
      data: (s) => s.where((x) => x.enabled).length,
      orElse: () => 0,
    );

    return Card(
      color: colors.card,
      child: ListTile(
        onTap: () => showSoundListSheet(
          context,
          ownerType: SoundOwner.praise,
          ownerId: praise.id,
          title: praise.label,
          fallbackLabel: praise.label,
        ),
        leading: IconButton(
          icon: Icon(Icons.play_circle_outline_rounded, color: colors.sky),
          iconSize: 32,
          tooltip: l.playAudio,
          onPressed: () =>
              ref.read(audioServiceProvider).playPraiseWord(praise),
        ),
        title: Text(
          praise.label,
          style: context.texts.bodyLarge!.copyWith(
            color: enabled ? colors.ink : colors.ink2,
            decoration: enabled ? null : TextDecoration.lineThrough,
          ),
        ),
        subtitle: Text(
          l.voicesCount(voiceCount),
          style: context.texts.bodyMedium!.copyWith(color: colors.ink2),
        ),
        trailing: enabled
            ? IconButton(
                icon: Icon(Icons.delete_outline_rounded, color: colors.ink2),
                tooltip: l.delete,
                onPressed: () => repo.setEnabled(praise.id, false),
              )
            : TextButton.icon(
                icon: const Icon(Icons.undo_rounded),
                label: Text(l.restore),
                onPressed: () => repo.setEnabled(praise.id, true),
              ),
      ),
    );
  }
}

class _AddPraiseWordSheet extends ConsumerStatefulWidget {
  const _AddPraiseWordSheet();

  @override
  ConsumerState<_AddPraiseWordSheet> createState() =>
      _AddPraiseWordSheetState();
}

class _AddPraiseWordSheetState extends ConsumerState<_AddPraiseWordSheet> {
  final _name = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  bool get _canSave => !_saving && _name.text.trim().isNotEmpty;

  Future<void> _save() async {
    setState(() => _saving = true);
    final word = await ref
        .read(praiseRepositoryProvider)
        .addUserPraiseWord(label: _name.text.trim());
    if (!mounted) return;
    Navigator.of(context).pop();
    // Open the new word so voices can be added right away.
    await showSoundListSheet(
      context,
      ownerType: SoundOwner.praise,
      ownerId: word.id,
      title: word.label,
      fallbackLabel: word.label,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        BaraemSpace.lg,
        BaraemSpace.sm,
        BaraemSpace.lg,
        BaraemSpace.lg + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l.addPraiseWord, style: context.texts.titleLarge),
          const SizedBox(height: BaraemSpace.lg),
          TextField(
            controller: _name,
            decoration: InputDecoration(labelText: l.praiseWordName),
            style: context.texts.bodyLarge,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: BaraemSpace.xl),
          AppButton.primary(label: l.save, onPressed: _canSave ? _save : null),
        ],
      ),
    );
  }
}
