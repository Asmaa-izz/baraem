import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../app/providers.dart';
import '../../core/utils/ids.dart';
import '../../data/models/domain.dart';
import '../../data/models/enums.dart';
import '../../data/repositories/content_repository.dart';
import '../../data/repositories/learning_repository.dart';
import 'engine_config.dart';
import 'engine_models.dart';
import 'learning_engine.dart';

part 'session_controller.g.dart';

/// Where a trial is in its lifecycle.
enum SessionPhase { asking, correct, hint, finished }

/// One quiz choice tile (an item shown via one of its exemplars).
class QuizOption {
  const QuizOption({required this.item, required this.exemplar});
  final Item item;
  final Exemplar exemplar;
}

/// Immutable UI view of the running session.
class SessionState {
  const SessionState({
    required this.sessionMode,
    required this.mode,
    required this.phase,
    required this.item,
    required this.exemplar,
    required this.options,
    required this.index,
    required this.total,
    required this.correctCount,
    required this.masteredThisSession,
    required this.profileMode,
    required this.categoryId,
    required this.categoryName,
    this.chosenItemId,
  });

  final SessionMode sessionMode; // learn (browse) or quiz (test)
  final TrialMode mode; // current trial: display or quiz
  final SessionPhase phase;
  final Item item; // current target
  final Exemplar exemplar; // exemplar shown for the target
  final List<QuizOption> options; // empty in display mode
  final int index; // 0-based trial number
  final int total; // learn: item count; quiz: session length
  final int correctCount; // first-attempt correct this session
  final int masteredThisSession;
  final ProfileMode profileMode;
  final String categoryId;
  final String categoryName;
  final String? chosenItemId; // last tapped choice (for highlighting)

  bool get isFinished => phase == SessionPhase.finished;

  SessionState copyWith({
    SessionPhase? phase,
    List<QuizOption>? options,
    int? index,
    int? correctCount,
    int? masteredThisSession,
    String? chosenItemId,
  }) {
    return SessionState(
      sessionMode: sessionMode,
      mode: mode,
      phase: phase ?? this.phase,
      item: item,
      exemplar: exemplar,
      options: options ?? this.options,
      index: index ?? this.index,
      total: total,
      correctCount: correctCount ?? this.correctCount,
      masteredThisSession: masteredThisSession ?? this.masteredThisSession,
      profileMode: profileMode,
      categoryId: categoryId,
      categoryName: categoryName,
      chosenItemId: chosenItemId ?? this.chosenItemId,
    );
  }
}

/// Drives a session. Two explicit modes chosen on the home screen:
/// - learn: browse the chosen category's images (display only, never quizzes);
/// - quiz: test the chosen category's items (errorless engine, distractors from
///   the same category, mastery/Leitner persisted).
@riverpod
class SessionController extends _$SessionController {
  late ProfileConfig _cfg;
  late LearningEngine _engine;
  SessionInfo? _session;
  SessionMode _sessionMode = SessionMode.learn;
  String? _categoryId;
  Set<String> _scopeItemIds = {};
  final Map<String, String> _categoryNames = {};
  final List<String> _recent = [];

  // learn-mode browse queue
  List<Item> _learnItems = [];
  final Map<String, List<Exemplar>> _exemplarsByItem = {};
  // Last exemplar shown per item, so a word's repeated appearances (rounds > 1)
  // prefer a different image each time.
  final Map<String, String> _lastExemplarByItem = {};

  int _index = 0;
  int _sessionCorrect = 0;
  int _masteredThisSession = 0;
  bool _inRetry = false;
  bool _sessionEnded = false;

  static const _placeholderItem =
      Item(id: '', label: '', categoryId: '', source: ContentSource.system);
  static const _placeholderExemplar = Exemplar(
    id: '',
    itemId: '',
    imagePath: '',
    order: 0,
    hasImage: false,
    source: ContentSource.system,
  );

  late LearningState _state; // quiz only
  Item _item = _placeholderItem;
  Exemplar _exemplar = _placeholderExemplar;
  List<QuizOption> _options = const [];

  @override
  Future<SessionState> build(String profileId) async {
    _engine = ref.read(learningEngineProvider);
    final profile =
        await ref.read(profileRepositoryProvider).getProfile(profileId);
    if (profile == null) throw StateError('profile $profileId not found');
    _cfg = ProfileConfig.forProfile(profile);
    _sessionMode = ref.read(sessionModeControllerProvider);
    _categoryId = ref.read(selectedCategoryProvider);

    final content = ref.read(contentRepositoryProvider);
    for (final c in await content.getCategories()) {
      _categoryNames[c.id] = c.name;
    }

    final scopeItems = _categoryId == null
        ? await _allItems(content)
        : await content.getItemsByCategory(_categoryId!);
    _scopeItemIds = scopeItems.map((i) => i.id).toSet();

    // Admit up to activeWindowSize items (in curated order) into this child's
    // active window before either mode runs. Both browse and quiz then operate
    // on that window only — a small, per-child set that grows as items are
    // mastered — instead of the whole (eventually large) category.
    final learn = ref.read(learningRepositoryProvider);
    await _admitWithinWindow(profileId, scopeItems, learn);

    final activeIds =
        (await learn.getActiveStates(profileId)).map((s) => s.itemId).toSet();
    final windowItems =
        scopeItems.where((it) => activeIds.contains(it.id)).toList();

    if (_sessionMode == SessionMode.learn) {
      // Repeat the active window `rounds` times; shuffle each round on its own so
      // every item appears exactly `rounds` times, spread across the session.
      _learnItems = [
        for (var r = 0; r < _cfg.rounds; r++)
          ...(List.of(windowItems)..shuffle(_engine.random)),
      ];
      for (final it in windowItems) {
        _exemplarsByItem[it.id] = await content.getExemplars(it.id);
      }
      return _buildLearnTrial();
    }

    _session = await learn.startSession(profileId, _now());
    return _buildQuizTrial(profileId);
  }

  DateTime _now() => _engine.clock.now();

  Future<List<Item>> _allItems(ContentRepository content) async {
    final result = <Item>[];
    for (final c in await content.getCategories()) {
      result.addAll(await content.getItemsByCategory(c.id));
    }
    return result;
  }

  // -------------------------------------------------------------- learn mode

  SessionState _buildLearnTrial() {
    if (_learnItems.isEmpty || _index >= _learnItems.length) {
      return _finishedView();
    }
    _item = _learnItems[_index];
    final exemplars = _exemplarsByItem[_item.id] ?? const [];
    _exemplar = exemplars.isEmpty
        ? _placeholderExemplar
        : _engine.pickExemplar(exemplars, avoid: _lastExemplarByItem[_item.id]);
    _lastExemplarByItem[_item.id] = _exemplar.id;
    return _view(
      trialMode: TrialMode.display,
      phase: SessionPhase.asking,
      total: _learnItems.length,
      options: const [],
    );
  }

  // -------------------------------------------------------------- quiz mode

  /// Keeps this child's active window filled to (at most) [activeWindowSize]
  /// non-graduated items within scope, introducing new items one at a time in
  /// curated order. A slot only frees when an item durably graduates
  /// ([LearningEngine.isGraduated]), so growth is gradual — a new word appears
  /// only after the child has solidly mastered a current one. Runs at session
  /// start for both browse and quiz.
  Future<void> _admitWithinWindow(
    String childId,
    List<Item> scopeItems,
    LearningRepository learn,
  ) async {
    final states = await learn.getStates(childId);
    final statedIds = states.map((s) => s.itemId).toSet();
    var occupants = states
        .where((s) =>
            _scopeItemIds.contains(s.itemId) &&
            s.status != ItemStatus.archived &&
            !_engine.isGraduated(s))
        .length;
    final now = _now();
    for (final it in scopeItems) {
      if (occupants >= _cfg.activeWindowSize) break;
      if (statedIds.contains(it.id)) continue; // already introduced (any status)
      await learn.initState(childId, it.id, now);
      occupants++;
    }
  }

  Future<SessionState> _buildQuizTrial(String childId) async {
    final learn = ref.read(learningRepositoryProvider);
    final content = ref.read(contentRepositoryProvider);
    final pool = (await learn.getActiveStates(childId))
        .where((s) => _scopeItemIds.contains(s.itemId))
        .toList();

    if (pool.isEmpty) {
      await _endSessionInDb();
      return _finishedView();
    }

    _state = _engine.selectNextState(pool, _recent.toSet(), _now());
    _item = (await content.getItem(_state.itemId))!;
    final exemplars = await content.getExemplars(_state.itemId);
    _exemplar = _engine.pickExemplar(exemplars, avoid: _state.lastExemplarId);

    _recent.add(_state.itemId);
    while (_recent.length > _cfg.recentAvoid) {
      _recent.removeAt(0);
    }

    final activeItemIds = pool.map((s) => s.itemId).toSet();
    _options = await _buildOptions(_item, content, activeItemIds);
    _inRetry = false;
    return _view(
      trialMode: TrialMode.quiz,
      phase: SessionPhase.asking,
      total: _cfg.sessionLength,
      options: _options,
    );
  }

  Future<List<QuizOption>> _buildOptions(
    Item target,
    ContentRepository content,
    Set<String> activeItemIds,
  ) async {
    // Distractors come from the child's active window only (same category), so
    // the quiz never shows an item that hasn't been introduced yet.
    final sameCategory = (await content.getItemsByCategory(target.categoryId))
        .where((i) => activeItemIds.contains(i.id))
        .toList();
    final distractors = _engine.pickDistractors(
      target,
      sameCategory,
      _cfg.choicesCount,
      _engine.difficultyFor(_state),
    );
    final options = <QuizOption>[QuizOption(item: target, exemplar: _exemplar)];
    for (final d in distractors) {
      final ex = await content.getExemplars(d.id);
      options.add(QuizOption(item: d, exemplar: _engine.pickExemplar(ex)));
    }
    options.shuffle(_engine.random);
    return options;
  }

  // -------------------------------------------------------------- shared

  SessionState _view({
    required TrialMode trialMode,
    required SessionPhase phase,
    required int total,
    required List<QuizOption> options,
  }) {
    return SessionState(
      sessionMode: _sessionMode,
      mode: trialMode,
      phase: phase,
      item: _item,
      exemplar: _exemplar,
      options: options,
      index: _index,
      total: total,
      correctCount: _sessionCorrect,
      masteredThisSession: _masteredThisSession,
      profileMode: _cfg.mode,
      categoryId: _item.categoryId,
      categoryName: _categoryNames[_item.categoryId] ?? '',
    );
  }

  SessionState _finishedView() {
    return SessionState(
      sessionMode: _sessionMode,
      mode: TrialMode.display,
      phase: SessionPhase.finished,
      item: _item,
      exemplar: _exemplar,
      options: const [],
      index: _index,
      total: _sessionMode == SessionMode.learn
          ? _learnItems.length
          : _cfg.sessionLength,
      correctCount: _sessionCorrect,
      masteredThisSession: _masteredThisSession,
      profileMode: _cfg.mode,
      categoryId: '',
      categoryName: '',
    );
  }

  // -------------------------------------------------------------- interactions

  /// Quiz tap. Errorless: the first wrong answer demotes once and gently reveals
  /// the correct tile; retries never re-demote/re-promote.
  Future<void> answer(String chosenItemId) async {
    final view = state.value;
    if (view == null || _sessionMode != SessionMode.quiz) return;
    if (view.phase == SessionPhase.correct || view.phase == SessionPhase.finished) {
      return;
    }

    final learn = ref.read(learningRepositoryProvider);
    final now = _now();
    final correct = chosenItemId == _item.id;

    await learn.logTrial(TrialLog(
      id: newId(),
      childId: _session!.childId,
      sessionId: _session!.id,
      itemId: _item.id,
      chosenItemId: chosenItemId,
      correct: correct,
      timestamp: now,
      choicesCount: _cfg.choicesCount,
      exemplarId: _exemplar.id,
      isRetry: _inRetry,
    ));

    if (correct) {
      final wasRetry = _inRetry;
      final prevStatus = _state.status;
      final updated = _engine
          .applyAnswer(_state, true, _cfg.masteryThreshold, now)
          .copyWith(lastExemplarId: _exemplar.id);
      await learn.upsertState(updated);
      _state = updated;

      if (!wasRetry) _sessionCorrect++;
      if (updated.status == ItemStatus.mastered &&
          prevStatus != ItemStatus.mastered) {
        _masteredThisSession++;
      }
      if (_engine.isStableForArchive(updated, _cfg.masteryThreshold)) {
        await learn.upsertState(updated.copyWith(status: ItemStatus.archived));
      }
      _inRetry = false;
      state = AsyncData(view.copyWith(
        phase: SessionPhase.correct,
        chosenItemId: chosenItemId,
        correctCount: _sessionCorrect,
        masteredThisSession: _masteredThisSession,
      ));
    } else if (!_inRetry) {
      final updated = _engine
          .applyAnswer(_state, false, _cfg.masteryThreshold, now)
          .copyWith(lastExemplarId: _exemplar.id);
      await learn.upsertState(updated);
      _state = updated;
      _inRetry = true;
      state = AsyncData(
          view.copyWith(phase: SessionPhase.hint, chosenItemId: chosenItemId));
    } else {
      state = AsyncData(
          view.copyWith(phase: SessionPhase.hint, chosenItemId: chosenItemId));
    }
  }

  /// Advance to the next trial (the "next" button, or after correct feedback).
  Future<void> advance() async {
    final view = state.value;
    if (view == null || view.isFinished) return;

    _index++;
    if (_sessionMode == SessionMode.learn) {
      state = AsyncData(
          _index >= _learnItems.length ? _finishedView() : _buildLearnTrial());
      return;
    }

    if (_index >= _cfg.sessionLength) {
      await _finish();
      return;
    }
    state = AsyncData(await _buildQuizTrial(_session!.childId));
  }

  Future<void> _finish() async {
    await _endSessionInDb();
    state = AsyncData(_finishedView());
  }

  Future<void> _endSessionInDb() async {
    if (_sessionEnded || _session == null) return;
    _sessionEnded = true;
    await ref.read(learningRepositoryProvider).endSession(
          _session!.id,
          _now(),
          itemsSeen: _index,
          correctCount: _sessionCorrect,
        );
  }
}
