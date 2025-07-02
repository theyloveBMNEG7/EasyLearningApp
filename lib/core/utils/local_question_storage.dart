import 'package:shared_preferences/shared_preferences.dart';

class LocalQuestionStorage {
  static const _reviewedKey = 'reviewedQuestions';

  static Future<void> markAsReviewed(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final reviewed = prefs.getStringList(_reviewedKey) ?? [];
    if (!reviewed.contains(id)) {
      reviewed.add(id);
      await prefs.setStringList(_reviewedKey, reviewed);
    }
  }

  static Future<List<String>> getReviewedQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_reviewedKey) ?? [];
  }
}
