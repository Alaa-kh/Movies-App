import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  const CommentModel({
    required this.id,
    required this.uid,
    required this.userName,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final String uid;
  final String userName;
  final String text;
  final DateTime createdAt;

  factory CommentModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final ts = data['createdAt'] as Timestamp?;
    return CommentModel(
      id: doc.id,
      uid: (data['uid'] as String?) ?? '',
      userName: (data['userName'] as String?) ?? '',
      text: (data['text'] as String?) ?? '',
      createdAt: (ts?.toDate()) ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'userName': userName,
        'text': text,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
