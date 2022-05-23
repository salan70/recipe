import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:recipe/repository/firebase/feedback_repository.dart';

class SendFeedbackModel extends ChangeNotifier {
  SendFeedbackModel({required this.user});
  final User user;

  Future<String?> sendFeedback(String feedback) async {
    FeedbackRepository _feedbackRepository = FeedbackRepository(user);

    if (feedback == '') {
      return '内容が入力されていません。';
    }
    try {
      _feedbackRepository.sendFeedback(feedback);
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
