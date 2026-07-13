import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

import '../../app/providers.dart';
import '../../data/models/domain.dart';
import '../../data/models/enums.dart';
import '../../data/repositories/sound_repository.dart';

/// Speaks item names and plays voice clips. Every item and praise word can own
/// several voices (see [SoundRepository]); one enabled voice is chosen at random
/// per playback. When no clip is available the Arabic text is spoken via TTS
/// (offline on mobile, via the browser on web). All failures are swallowed —
/// audio is never essential, and Arabic TTS voices may be absent on some
/// platforms.
class AudioService {
  AudioService(this._sounds) {
    _init();
  }

  final SoundRepository _sounds;
  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _player = AudioPlayer();
  final Random _random = Random();

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

  /// Plays one clip, dispatching by path shape: bundled asset, self-contained
  /// `data:` URI (web), or a native file. Returns whether playback started.
  Future<bool> _playClip(String audioPath) async {
    try {
      await _player.stop();
      if (audioPath.startsWith('assets/')) {
        await _player.setAsset(audioPath);
      } else if (audioPath.startsWith('data:')) {
        await _player.setUrl(audioPath);
      } else if (!kIsWeb && audioPath.isNotEmpty) {
        await _player.setFilePath(audioPath);
      } else {
        return false;
      }
      await _player.play();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Public one-shot preview (used by the audio picker): play [audioPath], or
  /// speak [fallbackText] if it can't.
  Future<void> playClip(String audioPath, String fallbackText) async {
    if (await _playClip(audioPath)) return;
    await speak(fallbackText);
  }

  /// Picks a random enabled voice for [ownerType]/[ownerId] and plays it, else
  /// the optional [nativeFileFallback] (a per-image recording), else TTS of
  /// [fallbackText].
  Future<void> playRandomVoice(
    SoundOwner ownerType,
    String ownerId,
    String fallbackText, [
    String? nativeFileFallback,
  ]) async {
    final clips = await _sounds.getEnabledSounds(ownerType, ownerId);
    if (clips.isNotEmpty) {
      final pick = clips[_random.nextInt(clips.length)];
      if (await _playClip(pick.audioPath)) return;
    }
    if (nativeFileFallback != null &&
        nativeFileFallback.isNotEmpty &&
        !kIsWeb) {
      if (await _playClip(nativeFileFallback)) return;
    }
    await speak(fallbackText);
  }

  /// Plays a random voice for an item (falling back to a per-exemplar recording,
  /// then TTS of the vocalized name).
  Future<void> playItem(Item item, [Exemplar? exemplar]) =>
      playRandomVoice(SoundOwner.item, item.id, item.spoken, exemplar?.audioPath);

  /// Plays a random voice for an encouragement word, TTS of its label otherwise.
  Future<void> playPraiseWord(Praise praise) =>
      playRandomVoice(SoundOwner.praise, praise.id, praise.label);

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
  final service = AudioService(ref.watch(soundRepositoryProvider));
  ref.onDispose(service.dispose);
  return service;
});
