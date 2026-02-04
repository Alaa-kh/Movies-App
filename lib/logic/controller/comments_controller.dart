import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:movies/logic/model/comment_model.dart';
import 'package:movies/logic/services/trailer_service.dart';

class CommentsController extends GetxController {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _col(MediaType type, int id) {
    final docId = '${type.name}_$id';
    return _db.collection('media_comments').doc(docId).collection('items');
  }

  Stream<List<CommentModel>> watch(MediaType type, int id) {
    return _col(type, id)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map(CommentModel.fromDoc).toList());
  }

  Future<void> add({
    required MediaType type,
    required int id,
    required String text,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Unauthenticated');

    final name = user.displayName?.trim().isNotEmpty == true
        ? user.displayName!.trim()
        : (user.email ?? 'User');

    final ref = _col(type, id).doc();
    final comment = CommentModel(
      id: ref.id,
      uid: user.uid,
      userName: name,
      text: text.trim(),
      createdAt: DateTime.now(),
    );

    await ref.set(comment.toJson());
  }
}
