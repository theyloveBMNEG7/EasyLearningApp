import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/quiz_question_model.dart';

class QuizQuestionService {
  static final _collection =
      FirebaseFirestore.instance.collection('quiz_questions');

  static Future<void> addQuestion(QuizQuestionModel question) async {
    await _collection.add(question.toMap());
  }

  static Stream<List<QuizQuestionModel>> getQuestions() {
    return _collection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => QuizQuestionModel.fromMap(doc.id, doc.data()))
        .toList());
  }

  static Future<void> deleteQuestion(String id) async {
    await _collection.doc(id).delete();
  }
}
