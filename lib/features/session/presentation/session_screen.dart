import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/motion/motion.dart';
import '../../../core/theme/baraem_tokens.dart';
import '../../../core/theme/context_ext.dart';
import '../../../core/utils/exemplar_image.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/category_chip.dart';
import '../../../core/widgets/choice_card.dart';
import '../../../core/widgets/emoji_fallback.dart';
import '../../../core/widgets/feedback_banner.dart';
import '../../../core/widgets/keyboard_hint.dart';
import '../../../core/widgets/media_tile.dart';
import '../../../core/widgets/progress_dots.dart';
import '../../../core/widgets/speaker_button.dart';
import '../../../data/models/domain.dart';
import '../../../data/seed/fallback_emoji.dart';
import '../../engine/engine_models.dart';
import '../../engine/session_controller.dart';
import 'presentation_config.dart';

/// S3 + S4 — one session runner that shows a learn view or a quiz view
/// depending on the current trial's mode.
class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  Timer? _advanceTimer;
  String? _lastSpokenKey;
  bool _navigated = false;
  final Random _praiseRandom = Random();

  @override
  void dispose() {
    _advanceTimer?.cancel();
    super.dispose();
  }

  bool get _muted => ref.read(mutedProvider).value ?? false;

  /// Positive reinforcement on a correct answer: a satisfying haptic + a warm
  /// encouragement clip (parent-managed). Sparkles + tile pop render in the view.
  void _celebrate(SessionState s) {
    HapticFeedback.mediumImpact();
    if (_muted) return;
    final clips =
        (ref.read(praisesProvider).value ?? const <Praise>[])
            .where((p) => p.enabled)
            .toList();
    if (clips.isEmpty) return; // parent disabled all — visuals/haptic remain
    final word = clips[_praiseRandom.nextInt(clips.length)];
    // Picks a random enabled voice of the chosen word (TTS fallback inside).
    ref.read(audioServiceProvider).playPraiseWord(word);
  }

  /// Gentle, non-punishing hint on a wrong tap: a soft haptic tick + re-speak
  /// the word so the child hears the answer (no negative sound, ever).
  void _giveHint(SessionState s) {
    HapticFeedback.selectionClick();
    if (!_muted) ref.read(audioServiceProvider).playItem(s.item);
  }

  void _autoSpeak(SessionState s) {
    if (s.phase != SessionPhase.asking) return;
    final key = '${s.index}:${s.item.id}';
    if (_lastSpokenKey == key) return;
    _lastSpokenKey = key;
    if (_muted || s.item.label.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(audioServiceProvider).playItem(s.item, s.exemplar);
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ref.watch(currentProfileIdProvider);
    if (id == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => context.go('/'));
      return const Scaffold(body: SizedBox.shrink());
    }

    ref.listen(sessionControllerProvider(id), (prev, next) {
      final s = next.value;
      if (s == null) return;
      final was = prev?.value?.phase;
      if (s.phase == SessionPhase.finished && !_navigated) {
        _navigated = true;
        if (s.sessionMode == SessionMode.learn) {
          context.go('/home'); // browsing has no reward screen
        } else {
          context.go('/reward', extra: s.masteredThisSession);
        }
      } else if (s.phase == SessionPhase.correct) {
        if (was != SessionPhase.correct) _celebrate(s);
        _advanceTimer?.cancel();
        _advanceTimer = Timer(
          PresentationConfig.forMode(s.profileMode).advanceDelay,
          () => ref.read(sessionControllerProvider(id).notifier).advance(),
        );
      } else if (s.phase == SessionPhase.hint && was != SessionPhase.hint) {
        _giveHint(s);
      }
    });

    ref.watch(praisesProvider); // warm the clips so praise is ready on correct
    final async = ref.watch(sessionControllerProvider(id));
    final controller = ref.read(sessionControllerProvider(id).notifier);

    return Scaffold(
      backgroundColor: context.colors.ground,
      body: SafeArea(
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (s) {
            if (s.isFinished) {
              return const Center(child: CircularProgressIndicator());
            }
            _autoSpeak(s);
            final pres = PresentationConfig.forMode(s.profileMode);
            return Focus(
              autofocus: true,
              onKeyEvent: (node, event) => _onKey(event, s, controller),
              // Keep a comfortable, centered column on wide (web) screens.
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 680),
                  child: Padding(
                padding: const EdgeInsetsDirectional.all(BaraemSpace.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _TopBar(s: s, onExit: () => context.go('/home')),
                    const SizedBox(height: BaraemSpace.md),
                    Expanded(
                      child: s.mode == TrialMode.display
                          ? _LearnView(
                              s: s,
                              onNext: controller.advance,
                              onSpeak: () => ref
                                  .read(audioServiceProvider)
                                  .playItem(s.item, s.exemplar),
                            )
                          : _QuizView(
                              s: s,
                              pres: pres,
                              onChoose: controller.answer,
                              onReplay: () => ref
                                  .read(audioServiceProvider)
                                  .playItem(s.item),
                            ),
                    ),
                  ],
                ),
              ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  KeyEventResult _onKey(
    KeyEvent event,
    SessionState s,
    SessionController controller,
  ) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final k = event.logicalKey;
    if (s.mode == TrialMode.display) {
      if (k == LogicalKeyboardKey.space ||
          k == LogicalKeyboardKey.enter ||
          k == LogicalKeyboardKey.arrowLeft ||
          k == LogicalKeyboardKey.arrowRight) {
        controller.advance();
        return KeyEventResult.handled;
      }
    } else if (s.phase != SessionPhase.correct) {
      final idx = _digitIndex(k);
      if (idx != null && idx < s.options.length) {
        controller.answer(s.options[idx].item.id);
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  int? _digitIndex(LogicalKeyboardKey k) {
    const digits = [
      LogicalKeyboardKey.digit1,
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4,
    ];
    final i = digits.indexOf(k);
    return i == -1 ? null : i;
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.s, required this.onExit});
  final SessionState s;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final label = s.mode == TrialMode.quiz ? l.quizTitle : s.categoryName;
    return Row(
      children: [
        IconButton(
          onPressed: onExit,
          icon: const Icon(Icons.close_rounded),
          iconSize: 26,
          tooltip: l.back,
          color: context.colors.ink2,
        ),
        const SizedBox(width: BaraemSpace.xs),
        CategoryChip(
          label: label,
          dotColor: s.categoryId.isEmpty
              ? null
              : context.colors.category(s.categoryId),
        ),
        const Spacer(),
        ProgressDots(count: s.total, index: s.index),
      ],
    );
  }
}

class _LearnView extends StatelessWidget {
  const _LearnView({
    required this.s,
    required this.onNext,
    required this.onSpeak,
  });

  final SessionState s;
  final VoidCallback onNext;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        const Spacer(),
        // Big, responsive image: fill the column but cap by height and a max,
        // so it scales up nicely on web without overflowing short screens.
        LayoutBuilder(
          builder: (context, c) {
            final side = [
              c.maxWidth,
              MediaQuery.sizeOf(context).height * 0.52,
              560.0,
            ].reduce((a, b) => a < b ? a : b);
            return SizedBox(
              width: side,
              child: MediaTile(
                emoji: emojiForItem(s.item.id, categoryId: s.categoryId),
                image: exemplarImage(s.exemplar),
                seed: s.item.id,
                overlay: SpeakerButton(onPressed: onSpeak),
              ),
            );
          },
        ),
        const SizedBox(height: BaraemSpace.lg),
        Text(s.item.label,
            style: context.texts.displayMedium, textAlign: TextAlign.center),
        const Spacer(),
        AppButton.primary(
          label: l.next,
          onPressed: onNext,
          trailingIcon: Icons.chevron_left_rounded,
        ),
        const SizedBox(height: BaraemSpace.sm),
        KeyboardHint(l.keyboardHintNext),
      ],
    );
  }
}

class _QuizView extends StatelessWidget {
  const _QuizView({
    required this.s,
    required this.pres,
    required this.onChoose,
    required this.onReplay,
  });

  final SessionState s;
  final PresentationConfig pres;
  final ValueChanged<String> onChoose;
  final VoidCallback onReplay;

  ChoiceState _stateFor(QuizOption o) {
    final isTarget = o.item.id == s.item.id;
    if (s.phase == SessionPhase.correct && isTarget) return ChoiceState.correct;
    if (s.phase == SessionPhase.hint) {
      if (isTarget) return ChoiceState.correct; // gently reveal the answer
      if (o.item.id == s.chosenItemId) return ChoiceState.hint;
    }
    return ChoiceState.idle;
  }

  /// Support mode spotlights the answer: once the answer is revealed (correct
  /// or hint), the untapped, non-answer tiles fade back so the right one — with
  /// its sage border, glow and tick — is unmistakable. Normal mode never dims.
  double _opacityFor(ChoiceState state) {
    if (!pres.spotlightAnswer) return 1;
    final revealed =
        s.phase == SessionPhase.correct || s.phase == SessionPhase.hint;
    return revealed && state == ChoiceState.idle ? 0.35 : 1;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final crossAxis = s.options.length == 3 ? 3 : 2;
    final feedback = switch (s.phase) {
      SessionPhase.correct => (FeedbackKind.correct, l.wellDone),
      SessionPhase.hint => (FeedbackKind.hint, l.tryAgain),
      _ => (FeedbackKind.none, null),
    };

    final content = Column(
      children: [
        const SizedBox(height: BaraemSpace.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                l.whereIs(s.item.label),
                style: context.texts.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: BaraemSpace.sm),
            SpeakerButton(onPressed: onReplay, diameter: 44),
          ],
        ),
        const Spacer(),
        LayoutBuilder(
          builder: (context, c) {
            // Bigger choices on web; 2-row layouts capped by height.
            final rows = crossAxis == 3 ? 1 : (s.options.length / 2).ceil();
            final byHeight = MediaQuery.sizeOf(context).height *
                (rows >= 2 ? 0.62 : 0.42);
            final width =
                [c.maxWidth, 600.0, byHeight * crossAxis / rows].reduce((a, b) => a < b ? a : b);
            return SizedBox(
              width: width,
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: crossAxis,
                mainAxisSpacing: pres.choiceSpacing,
                crossAxisSpacing: pres.choiceSpacing,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final o in s.options)
                    if (_stateFor(o) case final state)
                      AnimatedOpacity(
                        opacity: _opacityFor(state),
                        duration: motionDuration(context, BaraemMotion.feedback),
                        curve: BaraemMotion.curve,
                        child: ChoiceCard(
                          state: state,
                          onTap: s.phase == SessionPhase.correct
                              ? null
                              : () => onChoose(o.item.id),
                          child: _OptionTile(option: o),
                        ),
                      ),
                ],
              ),
            );
          },
        ),
        const Spacer(),
        FeedbackBanner(kind: feedback.$1, text: feedback.$2),
      ],
    );

    return Stack(
      children: [
        content,
        if (s.phase == SessionPhase.correct)
          Positioned.fill(
            child: IgnorePointer(
              child: _Sparkles(
                key: ValueKey(s.index),
                gentle: pres.gentleCelebration,
              ),
            ),
          ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.option});
  final QuizOption option;

  @override
  Widget build(BuildContext context) {
    final image = exemplarImage(option.exemplar);
    final emoji = emojiForItem(option.item.id, categoryId: option.item.categoryId);
    if (image == null) {
      return EmojiFallback(emoji: emoji, seed: option.item.id);
    }
    return Image(
      image: image,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) =>
          EmojiFallback(emoji: emoji, seed: option.item.id),
      // Fade the photo in over the card surface instead of flashing the emoji
      // tile first (which reads as a jarring image swap on each new card).
      frameBuilder: (context, child, frame, wasSync) {
        if (wasSync) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: motionDuration(context, BaraemMotion.crossFade),
          curve: BaraemMotion.curve,
          child: child,
        );
      },
    );
  }
}

/// A soft, one-shot sparkle burst on a correct answer — gentle, calm, and
/// skipped entirely when reduced-motion is on. In [gentle] mode (support) it
/// shows fewer sparkles with a shorter, softer rise to lower the sensory load.
class _Sparkles extends StatelessWidget {
  const _Sparkles({super.key, this.gentle = false});

  final bool gentle;

  static const _emojis = ['✨', '⭐', '🌟', '✨', '⭐', '🌟'];

  @override
  Widget build(BuildContext context) {
    if (!motionOn(context)) return const SizedBox.shrink();
    final count = gentle ? 3 : _emojis.length;
    final rise = gentle ? -40.0 : -70.0;
    final spread = gentle ? 0.5 : 0.28;
    return Stack(
      children: [
        for (var i = 0; i < count; i++)
          Align(
            alignment: Alignment(-0.7 + i * spread, 0.15),
            child: Text(_emojis[i], style: const TextStyle(fontSize: 30))
                .animate()
                .fadeIn(duration: 180.ms)
                .moveY(
                  begin: 10,
                  end: rise,
                  duration: 800.ms,
                  curve: Curves.easeOut,
                )
                .then(delay: 150.ms)
                .fadeOut(duration: 300.ms),
          ),
      ],
    );
  }
}
