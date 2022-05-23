import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackRepository {
  FeedbackRepository(this.user);

  final User user;

  Future sendFeedback(String feedback) async {
    await FirebaseFirestore.instance.collection('feedbacks').add({
      'uid': user.uid,
      'createdAt': DateTime.now(),
      'feedback': feedback,
    });
  }
}
