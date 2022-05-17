import 'package:firebase_auth/firebase_auth.dart';

class ReAuth {
  ReAuth(this.errorText, this.credential);

  final String? errorText;
  final AuthCredential? credential;
}
