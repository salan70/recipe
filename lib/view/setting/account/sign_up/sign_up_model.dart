import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/state/auth/auth_provider.dart';

class SignUpModel extends ChangeNotifier {
  Future<String?> signUpWithEmail(
    WidgetRef ref,
    String email,
    String password,
  ) async {
    final userNotifier = ref.watch(userStateNotifierProvider.notifier);

    try {
      return await userNotifier.signUpWithEmail(email, password);
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<String?> signUpWithGoogle(WidgetRef ref) async {
    final userNotifier = ref.watch(userStateNotifierProvider.notifier);

    try {
      return await userNotifier.signUpWithGoogle();
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<String?> signUpWithApple(WidgetRef ref) async {
    final userNotifier = ref.watch(userStateNotifierProvider.notifier);

    try {
      return await userNotifier.signUpWithApple();
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
