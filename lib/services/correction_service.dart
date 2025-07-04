import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/correction_model.dart';

class CorrectionService {
  static final _collection =
      FirebaseFirestore.instance.collection('corrections');

  static Future<void> addCorrection(CorrectionModel correction) async {
    await _collection.add(correction.toMap());
  }

  static Stream<List<CorrectionModel>> getCorrections() {
    return _collection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) =>
            CorrectionModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
        .toList());
  }

  static Future<void> deleteCorrection(String id) async {
    await _collection.doc(id).delete();
  }
}
