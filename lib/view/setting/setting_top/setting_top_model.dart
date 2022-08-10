import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/re_auth.dart';
import '../../../state/auth/auth_provider.dart';

class SettingTopModel extends ChangeNotifier {
  Future<ReAuth> reAuthWithGoogle(WidgetRef ref) async {
    final userNotifier = ref.watch(userStateNotifierProvider.notifier);

    try {
      return await userNotifier.reAuthWithGoogle(ref);
    } on Exception catch (e) {
      return ReAuth(e.toString(), null);
    }
  }

  Future<ReAuth> reAuthWithApple(WidgetRef ref) async {
    final userNotifier = ref.watch(userStateNotifierProvider.notifier);

    try {
      return await userNotifier.reAuthWithApple(ref);
    } on Exception catch (e) {
      return ReAuth(e.toString(), null);
    }
  }
}
