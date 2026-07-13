import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/baraem_tokens.dart';
import '../../../core/theme/context_ext.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/audio_picker_field.dart';
import '../../../data/models/domain.dart';
import '../../../data/models/enums.dart';

/// Parent screen: list, listen to, soft-delete/restore, and add encouragement
/// clips. Deletes are cosmetic (enabled=false); the reset button restores them.
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
        onPressed: () => _showAddSheet(context, ref),
        icon: const Icon(Icons.mic_none_rounded),
        label: Text(l.addSound),
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

  Future<void> _showAddSheet(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.ground,
      showDragHandle: true,
      builder: (_) => const _AddPraiseSheet(),
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

    return Card(
      color: colors.card,
      child: ListTile(
        leading: IconButton(
          icon: Icon(Icons.play_circle_outline_rounded, color: colors.sky),
          iconSize: 32,
          tooltip: l.playAudio,
          onPressed: () =>
              ref.read(audioServiceProvider).playPraise(praise.audioPath, praise.label),
        ),
        title: Text(
          praise.label,
          style: context.texts.bodyLarge!.copyWith(
            color: enabled ? colors.ink : colors.ink2,
            decoration: enabled ? null : TextDecoration.lineThrough,
          ),
        ),
        subtitle: praise.source == ContentSource.user
            ? Text('🎙️', style: TextStyle(color: colors.ink2))
            : null,
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

class _AddPraiseSheet extends ConsumerStatefulWidget {
  const _AddPraiseSheet();

  @override
  ConsumerState<_AddPraiseSheet> createState() => _AddPraiseSheetState();
}

class _AddPraiseSheetState extends ConsumerState<_AddPraiseSheet> {
  final _name = TextEditingController();
  String? _audioPath;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  bool get _canSave =>
      !_saving && _name.text.trim().isNotEmpty && _audioPath != null;

  Future<void> _save() async {
    setState(() => _saving = true);
    await ref.read(praiseRepositoryProvider).addUserPraise(
          label: _name.text.trim(),
          audioPath: _audioPath!,
        );
    if (mounted) Navigator.of(context).pop();
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
          Text(l.addSound, style: context.texts.titleLarge),
          const SizedBox(height: BaraemSpace.lg),
          TextField(
            controller: _name,
            decoration: InputDecoration(labelText: l.soundName),
            style: context.texts.bodyLarge,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: BaraemSpace.lg),
          AudioPickerField(
            labelForPlayback: _name.text.trim(),
            onChanged: (path) => setState(() => _audioPath = path),
          ),
          const SizedBox(height: BaraemSpace.xl),
          AppButton.primary(label: l.save, onPressed: _canSave ? _save : null),
        ],
      ),
    );
  }
}
