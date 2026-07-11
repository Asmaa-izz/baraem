/// A source of "now", injectable so time-dependent logic (Leitner intervals,
/// due dates) is deterministic in tests. All times are UTC to match the DB,
/// which stores dates as ISO-8601 UTC text.
abstract class Clock {
  DateTime now();
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now().toUtc();
}

/// A controllable clock for tests.
class FixedClock implements Clock {
  FixedClock(this._now);

  DateTime _now;

  @override
  DateTime now() => _now;

  void set(DateTime t) => _now = t;
  void advance(Duration d) => _now = _now.add(d);
}
