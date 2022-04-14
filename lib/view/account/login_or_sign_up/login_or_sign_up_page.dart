import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/components/providers.dart';

// レシピ一覧画面
class LoginOrSignUpPage extends ConsumerWidget {
  const LoginOrSignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        .maxLength(16, '16文字以下で入力してください')
        .build();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('ログイン / 新規登録'),
          bottom: TabBar(
            indicatorColor: Colors.black,
            tabs: <Widget>[
              Tab(
                  child: Text(
                'ログイン',
                style: Theme.of(context).primaryTextTheme.subtitle1,
              )),
              Tab(
                  child: Text(
                '新規登録',
                style: Theme.of(context).primaryTextTheme.subtitle1,
              )),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            /// ログインタブ
            Container(),

            /// 新規登録タブ
            Padding(
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
                          errorText: password == ''
                              ? null
                              : passwordValidate(password),
                          prefixIcon: Icon(Icons.lock_open_rounded),
                          suffixIcon: IconButton(
                            // 文字の表示・非表示でアイコンを変える
                            icon: Icon(passwordIsObscure
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded),
                            // アイコンがタップされたら現在と反対の状態をセットする
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
                          onPressed: () {},
                          child: Text(
                            '登録',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '他のアカウントで登録',
                      style: Theme.of(context).primaryTextTheme.subtitle1,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
