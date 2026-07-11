import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../../core/utils/ids.dart';
import '../db/app_database.dart';

/// App-level settings: the parent PIN (stored salted+hashed, never plaintext),
/// mute flag, and theme override (PRD §14).
abstract class SettingsRepository {
  Future<bool> hasPin();
  Future<void> setPin(String pin);
  Future<bool> verifyPin(String pin);
  Future<bool> isMuted();
  Future<void> setMuted(bool value);
  Future<String?> getThemeMode(); // 'system' | 'light' | 'dark'
  Future<void> setThemeMode(String mode);
}

class DriftSettingsRepository implements SettingsRepository {
  DriftSettingsRepository(this.db);

  final AppDatabase db;

  static const _saltKey = 'pin_salt';
  static const _hashKey = 'pin_hash';
  static const _muteKey = 'muted';
  static const _themeKey = 'theme_mode';

  @override
  Future<bool> hasPin() async => (await db.getSetting(_hashKey)) != null;

  @override
  Future<void> setPin(String pin) async {
    var salt = await db.getSetting(_saltKey);
    if (salt == null) {
      salt = newId();
      await db.setSetting(_saltKey, salt);
    }
    await db.setSetting(_hashKey, _hash(pin, salt));
  }

  @override
  Future<bool> verifyPin(String pin) async {
    final salt = await db.getSetting(_saltKey);
    final hash = await db.getSetting(_hashKey);
    if (salt == null || hash == null) return false;
    return _hash(pin, salt) == hash;
  }

  String _hash(String pin, String salt) =>
      sha256.convert(utf8.encode('$salt:$pin')).toString();

  @override
  Future<bool> isMuted() async => (await db.getSetting(_muteKey)) == 'true';

  @override
  Future<void> setMuted(bool value) => db.setSetting(_muteKey, '$value');

  @override
  Future<String?> getThemeMode() => db.getSetting(_themeKey);

  @override
  Future<void> setThemeMode(String mode) => db.setSetting(_themeKey, mode);
}
