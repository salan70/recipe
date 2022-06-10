import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:recipe/repository/firebase/feedback_repository.dart';

class SendFeedbackModel extends ChangeNotifier {
  SendFeedbackModel({required this.user});
  final User user;

  Future<String?> sendFeedback(String feedback) async {
    final feedbackRepository = FeedbackRepository(user);

    if (feedback == '') {
      return '内容が入力されていません。';
    }
    try {
      await feedbackRepository.sendFeedback(feedback);
      return null;
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
