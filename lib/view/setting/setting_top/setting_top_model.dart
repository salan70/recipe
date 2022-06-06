import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/domain/re_auth.dart';
import 'package:recipe/state/auth/auth_provider.dart';

class SettingTopModel extends ChangeNotifier {
  Future<ReAuth> reAuthWithGoogle(WidgetRef ref) async {
    final userNotifier = ref.watch(userStateNotifierProvider.notifier);

    try {
      return await userNotifier.reAuthWithGoogle(ref);
    } catch (e) {
      return ReAuth(e.toString(), null);
    }
  }

  Future<ReAuth> reAuthWithApple(WidgetRef ref) async {
    final userNotifier = ref.watch(userStateNotifierProvider.notifier);

    try {
      return await userNotifier.reAuthWithApple(ref);
    } catch (e) {
      return ReAuth(e.toString(), null);
    }
  }
}
