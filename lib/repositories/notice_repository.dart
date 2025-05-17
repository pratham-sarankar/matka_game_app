import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matka_game_app/models/notice.dart';

class NoticeRepository {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'notices';

  Query<Notice> getNoticesQuery() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .withConverter<Notice>(
          fromFirestore: (doc, _) => Notice.fromDoc(doc),
          toFirestore: (notice, _) => notice.toMap(),
        );
  }

  Future<void> addNotice(String content) async {
    final docRef = _firestore.collection(_collection).doc();
    await docRef.set({
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNotice(String id, String content) async {
    await _firestore.collection(_collection).doc(id).update({
      'content': content,
    });
  }

  Future<void> deleteNotice(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}
