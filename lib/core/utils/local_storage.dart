import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _deletedKey = 'deletedMessages';

  static Future<void> addDeletedMessage(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final deleted = prefs.getStringList(_deletedKey) ?? [];
    if (!deleted.contains(id)) {
      deleted.add(id);
      await prefs.setStringList(_deletedKey, deleted);
    }
  }

  static Future<List<String>> getDeletedMessages() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_deletedKey) ?? [];
  }
}
