import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/baraem_tokens.dart';
import '../../../core/theme/context_ext.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/audio_picker_field.dart';
import '../../../data/models/domain.dart';
import '../../../data/models/enums.dart';

/// Shared, platform-agnostic sheet for managing the voice clips of one item or
/// praise word: listen to each, add a new one (pick a file or record), and
/// delete unwanted ones. Used by both the content tab (items) and the
/// encouragement manager (praise words) so both places share one flow.
Future<void> showSoundListSheet(
  BuildContext context, {
  required SoundOwner ownerType,
  required String ownerId,
  required String title,
  required String fallbackLabel,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.ground,
    showDragHandle: true,
    builder: (_) => SoundListSheet(
      ownerType: ownerType,
      ownerId: ownerId,
      title: title,
      fallbackLabel: fallbackLabel,
    ),
  );
}

class SoundListSheet extends ConsumerStatefulWidget {
  const SoundListSheet({
    super.key,
    required this.ownerType,
    required this.ownerId,
    required this.title,
    required this.fallbackLabel,
  });

  final SoundOwner ownerType;
  final String ownerId;
  final String title;

  /// Spoken via TTS if preview playback fails.
  final String fallbackLabel;

  @override
  ConsumerState<SoundListSheet> createState() => _SoundListSheetState();
}

class _SoundListSheetState extends ConsumerState<SoundListSheet> {
  String? _pendingPath;
  int _pickerKey = 0; // bump to reset the picker after each add
  bool _saving = false;

  Future<void> _add() async {
    if (_pendingPath == null) return;
    setState(() => _saving = true);
    await ref.read(soundRepositoryProvider).addUserSound(
          ownerType: widget.ownerType,
          ownerId: widget.ownerId,
          audioPath: _pendingPath!,
        );
    if (!mounted) return;
    setState(() {
      _pendingPath = null;
      _pickerKey++;
      _saving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final soundsAsync =
        ref.watch(soundsProvider(widget.ownerType, widget.ownerId));

    return Padding(
      padding: EdgeInsets.fromLTRB(
        BaraemSpace.lg,
        BaraemSpace.sm,
        BaraemSpace.lg,
        BaraemSpace.lg + bottomInset,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.title, style: context.texts.titleLarge),
            const SizedBox(height: BaraemSpace.xs),
            Text(l.manageVoicesHint, style: context.texts.bodyMedium),
            const SizedBox(height: BaraemSpace.md),
            soundsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(BaraemSpace.lg),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Text('$e', style: context.texts.bodyMedium),
              data: (sounds) => sounds.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: BaraemSpace.md),
                      child: Text(l.noVoices, style: context.texts.bodyMedium),
                    )
                  : Column(
                      children: [
                        for (final s in sounds)
                          _SoundRow(
                            sound: s,
                            fallbackLabel: widget.fallbackLabel,
                          ),
                      ],
                    ),
            ),
            const Divider(height: BaraemSpace.xl),
            Text(l.addSound, style: context.texts.titleMedium),
            const SizedBox(height: BaraemSpace.md),
            AudioPickerField(
              key: ValueKey(_pickerKey),
              labelForPlayback: widget.fallbackLabel,
              onChanged: (path) => setState(() => _pendingPath = path),
            ),
            const SizedBox(height: BaraemSpace.lg),
            AppButton.primary(
              label: l.addSound,
              onPressed: (_pendingPath == null || _saving) ? null : _add,
            ),
          ],
        ),
      ),
    );
  }
}

class _SoundRow extends ConsumerWidget {
  const _SoundRow({required this.sound, required this.fallbackLabel});

  final Sound sound;
  final String fallbackLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final colors = context.colors;
    final repo = ref.read(soundRepositoryProvider);
    final enabled = sound.enabled;
    final isUser = sound.source == ContentSource.user;

    return Card(
      color: colors.card,
      child: ListTile(
        leading: IconButton(
          icon: Icon(Icons.play_circle_outline_rounded, color: colors.sky),
          iconSize: 32,
          tooltip: l.playAudio,
          onPressed: () =>
              ref.read(audioServiceProvider).playClip(sound.audioPath, fallbackLabel),
        ),
        title: Text(
          sound.label ?? '🎙️',
          style: context.texts.bodyLarge!.copyWith(
            color: enabled ? colors.ink : colors.ink2,
            decoration: enabled ? null : TextDecoration.lineThrough,
          ),
        ),
        subtitle: isUser ? Text('🎙️', style: TextStyle(color: colors.ink2)) : null,
        // User clips hard-delete (row + file). System clips soft-delete (their
        // asset can't be removed) and can be restored.
        trailing: isUser
            ? IconButton(
                icon: Icon(Icons.delete_outline_rounded, color: colors.ink2),
                tooltip: l.delete,
                onPressed: () => repo.deleteUserSound(sound.id),
              )
            : enabled
                ? IconButton(
                    icon: Icon(Icons.delete_outline_rounded, color: colors.ink2),
                    tooltip: l.delete,
                    onPressed: () => repo.setEnabled(sound.id, false),
                  )
                : TextButton.icon(
                    icon: const Icon(Icons.undo_rounded),
                    label: Text(l.restore),
                    onPressed: () => repo.setEnabled(sound.id, true),
                  ),
      ),
    );
  }
}
