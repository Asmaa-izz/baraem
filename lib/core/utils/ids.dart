import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// A fresh UUID v4 for user-created rows (profiles, sessions, trials, user
/// content). System content reuses stable ids from `content.json`.
String newId() => _uuid.v4();
