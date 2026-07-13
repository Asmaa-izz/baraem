import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';

import '../audio/audio_service.dart';
import '../l10n/app_localizations.dart';
import '../theme/baraem_tokens.dart';
import '../theme/context_ext.dart';
import '../utils/media_store.dart';
import 'app_button.dart';

/// Shared audio acquisition control: pick a file (web + mobile) or record with
/// the mic (mobile only), preview/play it, and clear it.
///
/// This is the single source of truth for "add or upload a sound", reused by
/// the praise (encouragement) sheet, the item editor, and per-word audio in the
/// content tab. It owns only the acquisition + preview; the host screen keeps
/// its own name/label fields and save button, and reacts to [onChanged].
class AudioPickerField extends ConsumerStatefulWidget {
  const AudioPickerField({
    super.key,
    this.initialPath,
    required this.labelForPlayback,
    required this.onChanged,
  });

  /// Existing audio to start from (e.g. a word that already has a clip). Its
  /// shape may be an asset path, a native file path, or a `data:` URI.
  final String? initialPath;

  /// Text spoken via TTS if preview playback of the selected clip fails.
  final String labelForPlayback;

  /// Called whenever the selected audio path changes (null once cleared).
  final ValueChanged<String?> onChanged;

  @override
  ConsumerState<AudioPickerField> createState() => _AudioPickerFieldState();
}

class _AudioPickerFieldState extends ConsumerState<AudioPickerField> {
  final _recorder = AudioRecorder();
  String? _audioPath;
  bool _recording = false;

  @override
  void initState() {
    super.initState();
    _audioPath = widget.initialPath;
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  void _setPath(String? path) {
    setState(() => _audioPath = path);
    widget.onChanged(path);
  }

  Future<void> _toggleRecording() async {
    if (_recording) {
      final path = await _recorder.stop();
      setState(() => _recording = false);
      _setPath(path);
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
    if (mounted) _setPath(audioPath);
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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colors = context.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
                Text(l.audioReady, style: context.texts.bodyMedium),
                const Spacer(),
                TextButton(
                  onPressed: () => ref
                      .read(audioServiceProvider)
                      .playClip(_audioPath!, widget.labelForPlayback),
                  child: Text(l.playAudio),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: colors.ink2),
                  tooltip: l.removeAudio,
                  onPressed: () => _setPath(null),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
