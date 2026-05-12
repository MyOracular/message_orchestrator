import 'package:shared_preferences/shared_preferences.dart';
import 'storage_adapter.dart';

class PrefsStorage implements StorageAdapter {
  SharedPreferences? _prefs;
  
  static const String _lastShownPrefix = 'fmo_last_shown_';
  static const String _hasShownPrefix = 'fmo_has_shown_';

  @override
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  @override
  Future<void> clearAll() async {
    await init();
    final keys = _prefs!.getKeys();
    for (final key in keys) {
      if (key.startsWith(_lastShownPrefix) || key.startsWith(_hasShownPrefix)) {
        await _prefs!.remove(key);
      }
    }
  }

  @override
  Future<void> clearMessageData(String messageId) async {
    await init();
    await _prefs!.remove('$_lastShownPrefix$messageId');
    await _prefs!.remove('$_hasShownPrefix$messageId');
  }

  @override
  Future<DateTime?> getLastShownTime(String messageId) async {
    await init();
    final timestamp = _prefs!.getInt('$_lastShownPrefix$messageId');
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  @override
  Future<bool> hasBeenShown(String messageId) async {
    await init();
    return _prefs!.getBool('$_hasShownPrefix$messageId') ?? false;
  }

  @override
  Future<void> markAsShown(String messageId) async {
    await init();
    await _prefs!.setBool('$_hasShownPrefix$messageId', true);
  }

  @override
  Future<void> setLastShownTime(String messageId, DateTime time) async {
    await init();
    await _prefs!.setInt('$_lastShownPrefix$messageId', time.millisecondsSinceEpoch);
  }
}
