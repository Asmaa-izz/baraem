// Domain enums, kept as pure Dart so the engine can depend on them without
// pulling in Drift. Drift persists these via `.textEnum()` (stores `.name`,
// stable across reordering). The Arabic labels are for the UI only.

enum ItemStatus {
  isNew('جديد'),
  learning('قيد التعلّم'),
  mastered('متقَن'),
  archived('مؤرشف');

  const ItemStatus(this.label);
  final String label;
}

enum ProfileMode {
  normal('عادي'),
  support('دعم');

  const ProfileMode(this.label);
  final String label;
}

enum ContentSource { system, user }
