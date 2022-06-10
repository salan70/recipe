import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackRepository {
  FeedbackRepository(this.user);

  final User user;

  Future<void> sendFeedback(String feedback) async {
    await FirebaseFirestore.instance
        .collection('feedbacks')
        .add(<String, dynamic>{
      'uid': user.uid,
      'createdAt': DateTime.now(),
      'feedback': feedback,
    });
  }
}
