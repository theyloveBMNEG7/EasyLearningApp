import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/live_class_session.dart';

class LiveClassService {
  static final _collection =
      FirebaseFirestore.instance.collection('live_classes');

  static Future<void> createClass(LiveClassModel session) async {
    await _collection.add(session.toMap());
  }

  static Stream<List<LiveClassModel>> getLiveClasses() {
    return _collection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => LiveClassModel.fromMap(doc.id, doc.data()))
        .toList());
  }

  static Future<void> updateStatus(String id, String status) async {
    await _collection.doc(id).update({'status': status});
  }

  static Future<void> deleteClass(String id) async {
    await _collection.doc(id).delete();
  }
}
