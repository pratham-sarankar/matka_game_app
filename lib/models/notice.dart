import 'package:cloud_firestore/cloud_firestore.dart';

class Notice {
  final String id;
  final String content;
  final DateTime createdAt;

  Notice({
    required this.id,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Notice.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final createdAt = data['createdAt'];
    return Notice(
      id: doc.id,
      content: data['content'] as String,
      createdAt: createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
    );
  }
}
