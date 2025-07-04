import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/ai_logs.dart';

class AiLogService {
  static final _collection = FirebaseFirestore.instance.collection('ai_logs');

  static Future<void> logInteraction(AiLogModel log) async {
    await _collection.add(log.toMap());
  }

  static Stream<List<AiLogModel>> getLogsForUser(String userId) {
    return _collection.where('userId', isEqualTo: userId).snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => AiLogModel.fromMap(doc.id, doc.data()))
            .toList());
  }
}
