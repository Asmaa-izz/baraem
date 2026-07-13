import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

import '../../data/models/domain.dart';

/// Speaks item names and plays parent-recorded audio.
///
/// System content has no audio files, so the item's Arabic label is spoken via
/// TTS (offline on mobile, via the browser on web). Parent-recorded files play
/// through just_audio. All failures are swallowed — audio is never essential,
/// and Arabic TTS voices may be absent on some platforms.
class AudioService {
  AudioService() {
    _init();
  }

  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _player = AudioPlayer();

  Future<void> _init() async {
    try {
      await _tts.setLanguage('ar-SA');
      await _tts.setSpeechRate(0.45); // gentle pace for children
      await _tts.setPitch(1.0);
    } catch (_) {/* voice/config unavailable — stay silent */}
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    try {
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {}
  }

  /// Plays an encouragement clip on a correct answer: a bundled asset or a
  /// parent-recorded file, with TTS of [fallbackWord] if playback fails.
  Future<void> playPraise(String audioPath, String fallbackWord) async {
    if (audioPath.startsWith('assets/')) {
      try {
        await _player.stop();
        await _player.setAsset(audioPath);
        await _player.play();
        return;
      } catch (_) {/* fall through */}
    } else if (audioPath.startsWith('data:')) {
      // Self-contained base64 clip (web-uploaded audio).
      try {
        await _player.stop();
        await _player.setUrl(audioPath);
        await _player.play();
        return;
      } catch (_) {/* fall through */}
    } else if (!kIsWeb && audioPath.isNotEmpty) {
      try {
        await _player.stop();
        await _player.setFilePath(audioPath);
        await _player.play();
        return;
      } catch (_) {/* fall through */}
    }
    await speak(fallbackWord);
  }

  /// Plays the best available audio for an item: a bundled asset (system),
  /// a recorded file (user, native), else TTS of the vocalized name.
  Future<void> playItem(Item item, [Exemplar? exemplar]) async {
    final audio = item.audioPath;

    // Bundled asset audio (system content).
    if (audio != null && audio.startsWith('assets/')) {
      try {
        await _player.stop();
        await _player.setAsset(audio);
        await _player.play();
        return;
      } catch (_) {/* fall through */}
    }

    // Self-contained base64 clip (web-uploaded audio).
    if (audio != null && audio.startsWith('data:')) {
      try {
        await _player.stop();
        await _player.setUrl(audio);
        await _player.play();
        return;
      } catch (_) {/* fall through */}
    }

    // Recorded file audio (user content, native only).
    final file = (audio != null &&
            !audio.startsWith('assets/') &&
            !audio.startsWith('data:'))
        ? audio
        : exemplar?.audioPath;
    if (file != null && file.isNotEmpty && !kIsWeb) {
      try {
        await _player.stop();
        await _player.setFilePath(file);
        await _player.play();
        return;
      } catch (_) {/* fall through */}
    }

    await speak(item.spoken);
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
      await _player.stop();
    } catch (_) {}
  }

  void dispose() {
    _tts.stop();
    _player.dispose();
  }
}

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(service.dispose);
  return service;
});
