import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/tutorial_model.dart';

class TutorialService {
  static final _collection = FirebaseFirestore.instance.collection('tutorials');

  static Future<void> addTutorial(TutorialModel tutorial) async {
    await _collection.add(tutorial.toMap());
  }

  static Stream<List<TutorialModel>> getTutorials() {
    return _collection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) =>
            TutorialModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList());
  }

  static Future<void> deleteTutorial(String id) async {
    await _collection.doc(id).delete();
  }
}
