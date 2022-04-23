import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_validator/form_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/state/auth/auth_provider.dart';

// レシピ一覧画面
class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

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
        title: Text('ログイン'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'メールアドレスでログイン',
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
                      String? errorText =
                          await userNotifier.login(email, password);
                      if (errorText == null) {
                        Navigator.pop(context);
                        EasyLoading.showSuccess('ログインしました');
                      } else {
                        //TODO toastじゃなくてdialogのほうがいい？(エラーメッセージを読めるように)
                        EasyLoading.showError('ログインに失敗しました\n$errorText');
                      }
                    },
                    child: Text(
                      'ログイン',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '他のアカウントでログイン',
                style: Theme.of(context).primaryTextTheme.subtitle1,
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
