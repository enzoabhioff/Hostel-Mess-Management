import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ================= SEND =================
  static Future<void> send({
    required String message,
    required String type, // normal | emergency
    Map<String, dynamic>? extraData,
  }) async {
    await _db.collection('notifications').add({
      "message": message,
      "type": type,
      "readBy": [],
      "createdAt":
          FieldValue.serverTimestamp(), // ✅ better than Timestamp.now()
      ...?extraData,
    });
  }

  // ================= ALL =================
  static Stream<QuerySnapshot> allStream() {
    return _db
        .collection('notifications')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // ================= UNREAD FOR USER =================
  static Stream<List<QueryDocumentSnapshot>> unreadForUser(String userId) {
    return allStream().map((snap) {
      return snap.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        final List readBy = data['readBy'] ?? [];
        return !readBy.contains(userId);
      }).toList();
    });
  }

  // ================= MARK SINGLE READ =================
  static Future<void> markRead({
    required String notificationId,
    required String userId,
  }) async {
    await _db.collection('notifications').doc(notificationId).update({
      "readBy": FieldValue.arrayUnion([userId]),
    });
  }

  // ================= MARK ALL READ =================
  static Future<void> markAllRead(String userId) async {
    final snapshot = await _db.collection('notifications').get();

    for (var doc in snapshot.docs) {
      await doc.reference.update({
        "readBy": FieldValue.arrayUnion([userId]),
      });
    }
  }
}
