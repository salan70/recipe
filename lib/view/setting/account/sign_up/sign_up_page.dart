import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_validator/form_validator.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/view/other/introduction_take_over/introduction_take_over_page.dart';
import 'package:recipe/view/setting/account/sign_up/sign_up_model.dart';
import 'package:sign_button/sign_button.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpModel = SignUpModel();

    final passwordIsObscure = ref.watch(passwordIsObscureProvider);
    final passwordIsObscureNotifier =
        ref.watch(passwordIsObscureProvider.notifier);

    final email = ref.watch(emailProvider);
    final emailNotifier = ref.watch(emailProvider.notifier);

    final password = ref.watch(passwordProvider);
    final passwordNotifier = ref.watch(passwordProvider.notifier);

    final emailValidate =
        ValidationBuilder().email('有効なメールアドレスを入力してください').build();
    final passwordValidate =
        ValidationBuilder().minLength(6, '6文字以上で入力してください').build();

    return Scaffold(
      appBar: AppBar(
        title: const Text('新規登録'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16).r,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'メールアドレスで登録',
                style: Theme.of(context).primaryTextTheme.subtitle1,
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
                        errorText:
                            password == '' ? null : passwordValidate(password),
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
                      await EasyLoading.show(status: 'loading...');

                      if (passwordValidate(password) == '8文字以上で入力してください') {
                        await _signUpErrorAlertDialog(
                          context,
                          '8文字以上で入力してください',
                        );
                      }

                      final errorText = await signUpModel.signUpWithEmail(
                        ref,
                        email,
                        password,
                      );
                      if (errorText == null) {
                        Navigator.pop(context);
                        await EasyLoading.showSuccess('登録しました');
                      } else {
                        await EasyLoading.dismiss();
                        await _signUpErrorAlertDialog(context, errorText);
                      }
                    },
                    child: Text(
                      '登録',
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Text(
                '他のアカウントで登録',
                style: Theme.of(context).primaryTextTheme.subtitle1,
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
                          await EasyLoading.show(status: 'loading...');
                          final errorText =
                              await signUpModel.signUpWithGoogle(ref);
                          if (errorText == null) {
                            Navigator.pop(context);
                            await EasyLoading.showSuccess('登録しました');
                          } else {
                            await EasyLoading.dismiss();
                            await _signUpErrorAlertDialog(
                              context,
                              errorText,
                            );
                          }
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
                          await EasyLoading.show(status: 'loading...');
                          final errorText =
                              await signUpModel.signUpWithApple(ref);
                          if (errorText == null) {
                            Navigator.pop(context);
                            await EasyLoading.showSuccess('登録しました');
                          } else {
                            await EasyLoading.dismiss();
                            await _signUpErrorAlertDialog(
                              context,
                              errorText,
                            );
                          }
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
                  Navigator.push<MaterialPageRoute<void>>(
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

  Future<void> _signUpErrorAlertDialog(
    BuildContext context,
    String errorText,
  ) {
    return showDialog<AlertDialog>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('登録失敗'),
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
