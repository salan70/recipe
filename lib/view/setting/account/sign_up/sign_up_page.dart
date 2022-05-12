import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sign_button/sign_button.dart';
import 'package:form_validator/form_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/state/auth/auth_provider.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNotifier = ref.watch(userStateNotifierProvider.notifier);

    final passwordIsObscure = ref.watch(passwordIsObscureProvider);
    final passwordIsObscureNotifier =
        ref.watch(passwordIsObscureProvider.notifier);

    final email = ref.watch(emailProvider);
    final emailNotifier = ref.watch(emailProvider.notifier);

    final password = ref.watch(passwordProvider);
    final passwordNotifier = ref.watch(passwordProvider.notifier);

    final emailValidate =
        ValidationBuilder().email('有効なメールアドレスを入力してください').build();
    final passwordValidate = ValidationBuilder()
        .minLength(8, '8文字以上で入力してください')
        .maxLength(20, '20文字以下で入力してください')
        .build();

    return Scaffold(
      appBar: AppBar(
        title: Text('新規登録'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'メールアドレスで登録',
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (email) {
                      emailNotifier.update((state) => email);
                    },
                    decoration: InputDecoration(
                      labelText: 'メールアドレス',
                      errorText: email == '' ? null : emailValidate(email),
                      prefixIcon: Icon(Icons.mail_outline_rounded),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (password) {
                      passwordNotifier.update((state) => password);
                    },
                    obscureText: passwordIsObscure,
                    decoration: InputDecoration(
                      labelText: 'パスワード',
                      errorText:
                          password == '' ? null : passwordValidate(password),
                      prefixIcon: Icon(Icons.lock_open_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(passwordIsObscure
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded),
                        onPressed: () {
                          passwordIsObscureNotifier
                              .update((state) => !passwordIsObscure);
                        },
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: 144,
                    child: ElevatedButton(
                      onPressed: () async {
                        EasyLoading.show(status: 'loading...');
                        final errorText =
                            await userNotifier.signUpWithEmail(email, password);
                        if (errorText == null) {
                          Navigator.pop(context);
                          EasyLoading.showSuccess('登録しました');
                        } else {
                          EasyLoading.dismiss();
                          _showLoginErrorAlertDialog(context, errorText);
                        }
                      },
                      child: Text(
                        '登録',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  '他のアカウントで登録',
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SignInButton(
                        buttonType: ButtonType.google,
                        btnText: 'Google',
                        buttonSize: ButtonSize.large,
                        width: double.infinity,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 1,
                        onPressed: () async {
                          print('google');
                          EasyLoading.show(status: 'loading...');
                          final errorText =
                              await userNotifier.signUpWithGoogle();
                          if (errorText == null) {
                            Navigator.pop(context);
                            EasyLoading.showSuccess('登録しました');
                          } else {
                            EasyLoading.dismiss();
                            _showLoginErrorAlertDialog(context, errorText);
                          }
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: SignInButton(
                        buttonType: ButtonType.apple,
                        btnText: 'Apple',
                        buttonSize: ButtonSize.large,
                        width: double.infinity,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 1,
                        onPressed: () async {
                          print('apple');
                          EasyLoading.show(status: 'loading...');
                          final errorText =
                              await userNotifier.signUpWithApple();
                          if (errorText == null) {
                            Navigator.pop(context);
                            EasyLoading.showSuccess('登録しました');
                          } else {
                            EasyLoading.dismiss();
                            _showLoginErrorAlertDialog(context, errorText);
                          }
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _showLoginErrorAlertDialog(BuildContext context, String errorText) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('登録失敗'),
          content: Text('$errorText'),
          actions: [
            TextButton(
              child: Text('閉じる'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
