import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/state/auth/auth_state.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final userStateNotifierProvider =
    StateNotifierProvider.autoDispose<AuthStateNotifier, User?>(
  (ref) => AuthStateNotifier()..appStarted(),
);

final infoTextProvider = StateProvider.autoDispose((ref) {
  return '';
});

final passwordIsObscureProvider = StateProvider.autoDispose((ref) => true);

final emailProvider = StateProvider.autoDispose((ref) => '');

final passwordProvider = StateProvider.autoDispose((ref) => '');
