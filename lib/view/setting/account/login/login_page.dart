import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:form_validator/form_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/view/other/introduction_take_over/introduction_take_over_page.dart';
import 'package:recipe/view/setting/account/login/login_model.dart';
import 'package:sign_button/sign_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:recipe/state/auth/auth_provider.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LoginModel loginModel = LoginModel();

    final passwordIsObscure = ref.watch(passwordIsObscureProvider);
    final passwordIsObscureNotifier =
        ref.watch(passwordIsObscureProvider.notifier);

    final email = ref.watch(emailProvider);
    final emailNotifier = ref.watch(emailProvider.notifier);

    final password = ref.watch(passwordProvider);
    final passwordNotifier = ref.watch(passwordProvider.notifier);

    final emailValidate =
        ValidationBuilder().email('有効なメールアドレスを入力してください').build();

    return Scaffold(
      appBar: AppBar(
        title: Text('ログイン'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0).r,
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
                  padding: const EdgeInsets.all(8.0).r,
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
                  padding: const EdgeInsets.all(8.0).r,
                  child: TextField(
                    onChanged: (password) {
                      passwordNotifier.update((state) => password);
                    },
                    obscureText: passwordIsObscure,
                    decoration: InputDecoration(
                      labelText: 'パスワード',
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
                    width: 144.w,
                    child: ElevatedButton(
                      onPressed: () async {
                        final yesAction = TextButton(
                          child: Text('はい'),
                          onPressed: () async {
                            Navigator.pop(context);
                            EasyLoading.show(status: 'loading...');
                            String? errorText = await loginModel.loginWithEmail(
                                ref, email, password);
                            if (errorText == null) {
                              Navigator.pop(context);
                              EasyLoading.showSuccess('ログインしました');
                            } else {
                              EasyLoading.dismiss();
                              _showLoginErrorAlertDialog(context, errorText);
                            }
                          },
                        );
                        _showLoginAlertDialog(context, yesAction);
                      },
                      child: Text(
                        'ログイン',
                        style: TextStyle(fontSize: 20.sp),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  '他のアカウントでログイン',
                  style: Theme.of(context).primaryTextTheme.subtitle1,
                  textAlign: TextAlign.left,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0).r,
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
                          final yesWidget = TextButton(
                            child: Text('はい'),
                            onPressed: () async {
                              Navigator.pop(context);
                              EasyLoading.show(status: 'loading...');
                              final errorText =
                                  await loginModel.loginWithGoogle(ref);
                              if (errorText == null) {
                                Navigator.pop(context);
                                EasyLoading.showSuccess('ログインしました');
                              } else {
                                EasyLoading.dismiss();
                                _showLoginErrorAlertDialog(context, errorText);
                              }
                            },
                          );
                          _showLoginAlertDialog(context, yesWidget);
                        }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0).r,
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
                          final yesWidget = TextButton(
                            child: Text('はい'),
                            onPressed: () async {
                              Navigator.pop(context);
                              EasyLoading.show(status: 'loading...');
                              final errorText =
                                  await loginModel.loginWithApple(ref);
                              if (errorText == null) {
                                Navigator.pop(context);
                                EasyLoading.showSuccess('ログインしました');
                              } else {
                                EasyLoading.dismiss();
                                _showLoginErrorAlertDialog(context, errorText);
                              }
                            },
                          );
                          _showLoginAlertDialog(context, yesWidget);
                        }),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                TextButton.icon(
                  icon: Icon(Icons.info_outline),
                  label: Text('ログインで引き継がれる/引き継がれない要素について'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IntroductionTakeOverPage(),
                          fullscreenDialog: false,
                        ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _showLoginAlertDialog(BuildContext context, Widget yesAction) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('注意'),
          content: Text(
            'このままログインする場合、現在登録されているレシピが消えてしまいますがよろしいですか？\n\n※現在登録されているレシピを保存したい場合、「新規登録画面」より新規登録を行ってください。',
            textAlign: TextAlign.left,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('いいえ'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            yesAction,
          ],
        );
      },
    );
  }

  Future _showLoginErrorAlertDialog(BuildContext context, String errorText) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('ログイン失敗'),
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
