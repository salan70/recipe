import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/state/auth/auth_provider.dart';

class LoginModel extends ChangeNotifier {
  Future<String?> loginWithEmail(
      WidgetRef ref, String email, String password) async {
    final userNotifier = ref.watch(userStateNotifierProvider.notifier);

    try {
      return await userNotifier.loginWithEmail(email, password);
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> loginWithGoogle(WidgetRef ref) async {
    final userNotifier = ref.watch(userStateNotifierProvider.notifier);

    try {
      return await userNotifier.loginWithGoogle();
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> loginWithApple(WidgetRef ref) async {
    final userNotifier = ref.watch(userStateNotifierProvider.notifier);

    try {
      return await userNotifier.loginWithApple();
    } catch (e) {
      return e.toString();
    }
  }
}
