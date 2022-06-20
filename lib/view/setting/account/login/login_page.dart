import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_validator/form_validator.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/view/other/introduction_take_over/introduction_take_over_page.dart';
import 'package:recipe/view/setting/account/login/login_model.dart';
import 'package:sign_button/sign_button.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginModel = LoginModel();

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
        title: const Text('ログイン'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16).r,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'メールアドレスでログイン',
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: const EdgeInsets.all(8).r,
                child: Column(
                  children: [
                    TextField(
                      onChanged: (email) {
                        emailNotifier.update((state) => email);
                      },
                      decoration: InputDecoration(
                        labelText: 'メールアドレス',
                        errorText: email == '' ? null : emailValidate(email),
                        prefixIcon: const Icon(Icons.mail_outline_rounded),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    TextField(
                      onChanged: (password) {
                        passwordNotifier.update((state) => password);
                      },
                      obscureText: passwordIsObscure,
                      decoration: InputDecoration(
                        labelText: 'パスワード',
                        prefixIcon: const Icon(Icons.lock_open_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordIsObscure
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                          ),
                          onPressed: () {
                            passwordIsObscureNotifier
                                .update((state) => !passwordIsObscure);
                          },
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  width: 144.w,
                  child: ElevatedButton(
                    onPressed: () async {
                      final yesAction = TextButton(
                        child: const Text('はい'),
                        onPressed: () async {
                          Navigator.pop(context);
                          await EasyLoading.show(status: 'loading...');
                          final errorText = await loginModel.loginWithEmail(
                            ref,
                            email,
                            password,
                          );
                          if (errorText == null) {
                            Navigator.pop(context);
                            await EasyLoading.showSuccess('ログインしました');
                          } else {
                            await EasyLoading.dismiss();
                            await _loginErrorAlertDialog(
                              context,
                              errorText,
                            );
                          }
                        },
                      );
                      await _showLoginAlertDialog(context, yesAction);
                    },
                    child: Text(
                      'ログイン',
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Text(
                '他のアカウントでログイン',
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.left,
              ),
              Padding(
                padding: const EdgeInsets.all(8).r,
                child: Center(
                  child: Column(
                    children: [
                      SignInButton(
                        buttonType: ButtonType.google,
                        buttonSize: ButtonSize.large,
                        width: double.infinity,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 1,
                        onPressed: () async {
                          final yesWidget = TextButton(
                            child: const Text('はい'),
                            onPressed: () async {
                              Navigator.pop(context);
                              await EasyLoading.show(status: 'loading...');
                              final errorText =
                                  await loginModel.loginWithGoogle(ref);
                              if (errorText == null) {
                                Navigator.pop(context);
                                await EasyLoading.showSuccess('ログインしました');
                              } else {
                                await EasyLoading.dismiss();
                                await _loginErrorAlertDialog(
                                  context,
                                  errorText,
                                );
                              }
                            },
                          );
                          await _showLoginAlertDialog(context, yesWidget);
                        },
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      SignInButton(
                        buttonType: ButtonType.apple,
                        buttonSize: ButtonSize.large,
                        width: double.infinity,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 1,
                        onPressed: () async {
                          final yesWidget = TextButton(
                            child: const Text('はい'),
                            onPressed: () async {
                              Navigator.pop(context);
                              await EasyLoading.show(status: 'loading...');
                              final errorText =
                                  await loginModel.loginWithApple(ref);
                              if (errorText == null) {
                                Navigator.pop(context);
                                await EasyLoading.showSuccess('ログインしました');
                              } else {
                                await EasyLoading.dismiss();
                                await _loginErrorAlertDialog(
                                  context,
                                  errorText,
                                );
                              }
                            },
                          );
                          await _showLoginAlertDialog(context, yesWidget);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              TextButton.icon(
                icon: const Icon(Icons.info_outline),
                label: const Text('ログインで引き継がれる/引き継がれない要素について'),
                onPressed: () {
                  Navigator.push<MaterialPageRoute<dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IntroductionTakeOverPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showLoginAlertDialog(BuildContext context, Widget yesAction) {
    return showDialog<AlertDialog>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('注意'),
          content: const Text(
            'このままログインする場合、現在登録されているレシピが消えてしまいますがよろしいですか？'
            '\n\n※現在登録されているレシピを保存したい場合、「新規登録画面」より新規登録を行ってください。',
            textAlign: TextAlign.left,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('いいえ'),
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

  Future<void> _loginErrorAlertDialog(
    BuildContext context,
    String errorText,
  ) {
    return showDialog<AlertDialog>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('ログイン失敗'),
          content: Text(errorText),
          actions: [
            TextButton(
              child: const Text('閉じる'),
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
