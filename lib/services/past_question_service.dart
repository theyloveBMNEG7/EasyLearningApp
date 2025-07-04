import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/past_question_model.dart';

class PastQuestionService {
  static final _collection =
      FirebaseFirestore.instance.collection('past_questions');

  static Future<void> addQuestion(PastQuestionModel question) async {
    await _collection.add(question.toMap());
  }

  static Stream<List<PastQuestionModel>> getQuestions() {
    return _collection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => PastQuestionModel.fromMap(doc.id, doc.data()))
        .toList());
  }

  static Future<void> deleteQuestion(String id) async {
    await _collection.doc(id).delete();
  }
}
