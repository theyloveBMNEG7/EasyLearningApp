import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/quiz_log_model.dart';

class QuizLogService {
  static final _collection = FirebaseFirestore.instance.collection('quiz_logs');

  static Future<void> logQuiz(QuizLogModel log) async {
    await _collection.add(log.toMap());
  }

  static Stream<List<QuizLogModel>> getLogsForStudent(String studentId) {
    return _collection.where('studentId', isEqualTo: studentId).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => QuizLogModel.fromMap(doc.id, doc.data()))
            .toList());
  }

  static Stream<List<QuizLogModel>> getAllLogs() {
    return _collection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => QuizLogModel.fromMap(doc.id, doc.data()))
        .toList());
  }
}
