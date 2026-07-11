import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:record/record.dart';

import '../../../app/providers.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/baraem_tokens.dart';
import '../../../core/theme/context_ext.dart';
import '../../../core/utils/media_store.dart';
import '../../../core/widgets/app_button.dart';
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
  final _recorder = AudioRecorder();
  String? _audioPath;
  bool _recording = false;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_recording) {
      final path = await _recorder.stop();
      setState(() {
        _recording = false;
        _audioPath = path;
      });
    } else {
      if (!await _recorder.hasPermission()) return;
      final path = await newMediaPath('.m4a');
      await _recorder.start(const RecordConfig(), path: path);
      setState(() => _recording = true);
    }
  }

  /// Pick an audio file. On web it's stored as a self-contained data URI (so it
  /// persists); on mobile it's copied into the app's media directory.
  Future<void> _pickFile() async {
    final result =
        await FilePicker.pickFiles(type: FileType.audio, withData: kIsWeb);
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    String? audioPath;
    if (kIsWeb) {
      final bytes = file.bytes;
      if (bytes == null) return;
      audioPath = 'data:${_mimeFor(file.extension)};base64,${base64Encode(bytes)}';
    } else {
      final path = file.path;
      if (path == null) return;
      audioPath = await persistExternalFile(path, '.${file.extension ?? 'm4a'}');
    }
    if (mounted) setState(() => _audioPath = audioPath);
  }

  String _mimeFor(String? ext) {
    switch ((ext ?? '').toLowerCase()) {
      case 'mp3':
        return 'audio/mpeg';
      case 'm4a':
      case 'mp4':
      case 'aac':
        return 'audio/mp4';
      case 'wav':
        return 'audio/wav';
      case 'ogg':
        return 'audio/ogg';
      case 'webm':
        return 'audio/webm';
      default:
        return 'audio/mpeg';
    }
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
    final colors = context.colors;
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
          // Choose an audio file — works on web and mobile.
          AppButton(
            label: l.pickAudioFile,
            variant: AppButtonVariant.secondary,
            leadingIcon: Icons.audiotrack_rounded,
            onPressed: _pickFile,
          ),
          // Record with the mic — mobile only.
          if (!kIsWeb) ...[
            const SizedBox(height: BaraemSpace.sm),
            AppButton(
              label: _recording ? l.stopRecording : l.orRecord,
              variant: AppButtonVariant.secondary,
              leadingIcon:
                  _recording ? Icons.stop_rounded : Icons.mic_none_rounded,
              onPressed: _toggleRecording,
            ),
          ],
          if (_audioPath != null && !_recording)
            Padding(
              padding: const EdgeInsets.only(top: BaraemSpace.md),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: colors.sage, size: 20),
                  const SizedBox(width: BaraemSpace.xs),
                  Text('جاهز', style: context.texts.bodyMedium),
                  const Spacer(),
                  TextButton(
                    onPressed: () => ref
                        .read(audioServiceProvider)
                        .playPraise(_audioPath!, _name.text.trim()),
                    child: Text(l.playAudio),
                  ),
                ],
              ),
            ),
          const SizedBox(height: BaraemSpace.xl),
          AppButton.primary(label: l.save, onPressed: _canSave ? _save : null),
        ],
      ),
    );
  }
}
