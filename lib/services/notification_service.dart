import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/notification_model.dart';

class NotificationService {
  static final _collection =
      FirebaseFirestore.instance.collection('notifications');

  static Future<void> sendNotification(NotificationModel notification) async {
    await _collection.add(notification.toMap());
  }

  static Stream<List<NotificationModel>> getNotificationsForRole(String role) {
    return _collection
        .where('targetRole', whereIn: [role, 'all'])
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromMap(doc.id, doc.data()))
            .toList());
  }
}
