import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../../state/auth/auth_provider.dart';
import '../../other/edit_ingredient_unit/edit_ingredient_unit_page.dart';
import '../account/login/login_page.dart';
import '../account/sign_up/sign_up_page.dart';
import '../customize/edit_theme/edit_theme_page.dart';
import '../privacy_policy/privacy_policy_page.dart';
import '../send_feedback/send_feedback_page.dart';
import '../terms/terms_page.dart';
import 'setting_top_model.dart';

class SettingTopPage extends ConsumerWidget {
  const SettingTopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateNotifierProvider);
    final userNotifier = ref.watch(userStateNotifierProvider.notifier);

    final settingTopModel = SettingTopModel();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '設定',
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text(
              'アカウント',
            ),
            tiles: [
              user!.isAnonymous
                  ? SettingsTile.navigation(
                      title: const Text('ログイン'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onPressed: (context) {
                        Navigator.push<MaterialPageRoute<dynamic>>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                    )
                  : SettingsTile.navigation(
                      title: Text('${user.email}'),
                      trailing: const Text(''),
                    ),
              user.isAnonymous
                  ? SettingsTile.navigation(
                      title: const Text('新規登録'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onPressed: (context) {
                        Navigator.push<MaterialPageRoute<dynamic>>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
                    )
                  : SettingsTile.navigation(
                      title: const Text('ログアウト'),
                      trailing: const Icon(Icons.logout_rounded),
                      onPressed: (context) {
                        showDialog<AlertDialog>(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('確認'),
                              content: const Text('本当にログアウトしますか？'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('いいえ'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: const Text('はい'),
                                  onPressed: () async {
                                    await EasyLoading.show(
                                      status: 'loading...',
                                    );
                                    await userNotifier.signOut();
                                    Navigator.pop(context);
                                    await EasyLoading.showSuccess('ログアウトしました');
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
            ],
          ),
          SettingsSection(
            title: const Text('カスタマイズ'),
            tiles: [
              SettingsTile.navigation(
                title: const Text('材料の単位を編集'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onPressed: (context) {
                  Navigator.push<MaterialPageRoute<dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditIngredientUnitPage(),
                    ),
                  );
                },
              ),
              SettingsTile.navigation(
                title: const Text('テーマの変更'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onPressed: (context) {
                  Navigator.push<MaterialPageRoute<dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditThemePage(),
                    ),
                  );
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('サポート'),
            tiles: [
              // SettingsTile.navigation(
              //   title: Text('お知らせ'),
              //   trailing: Icon(Icons.chevron_right_rounded),
              // ),
              // SettingsTile.navigation(
              //   title: Text('使い方'),
              //   trailing: Icon(Icons.chevron_right_rounded),
              // ),
              SettingsTile.navigation(
                title: const Text('ご意見・ご要望'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onPressed: (context) {
                  Navigator.push<MaterialPageRoute<dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SendFeedbackPage(),
                    ),
                  );
                },
              ),
              SettingsTile.navigation(
                title: const Text('お問い合わせ'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onPressed: (context) async {
                  if (!await sendInquiry()) {
                    await showDialog<AlertDialog>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('エラー'),
                          content: const Text(
                            'エラーが発生しました。\n再度お試しください。'
                            '\n\n何度かお試しいただいても解決されない場合、'
                            'お手数ではございますが次の宛先までお問い合わせ内容をお送りください。'
                            '\n\ntoda.myrecipe@gmail.com',
                          ),
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
                },
              ),
              SettingsTile.navigation(
                title: const Text('レビューを書く'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onPressed: (context) async {
                  final inAppReview = InAppReview.instance;

                  if (await inAppReview.isAvailable()) {
                    await inAppReview.requestReview();
                  }
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('アプリについて'),
            tiles: [
              SettingsTile.navigation(
                title: const Text('利用規約'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onPressed: (context) async {
                  await Navigator.push<MaterialPageRoute<dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TermsPage(),
                    ),
                  );
                },
              ),
              SettingsTile.navigation(
                title: const Text('プライバシーポリシー'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onPressed: (context) {
                  Navigator.push<MaterialPageRoute<dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          CustomSettingsSection(
            child: Column(
              children: [
                SizedBox(
                  height: 48.h,
                ),
                TextButton(
                  child: Text(
                    '退会する',
                    style: TextStyle(color: Theme.of(context).errorColor),
                  ),
                  onPressed: () {
                    showDialog<AlertDialog>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('確認'),
                          content: const Text(
                            '本当に退会しますか？\n\n※ログインしている場合、退会するには再度認証が必要です。'
                            '\n※退会した場合、登録したアカウントやレシピの情報全てが削除され、'
                            '二度とログインすることができなくなります。',
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('いいえ'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: const Text('はい（認証へ進む）'),
                              onPressed: () async {
                                // providerId : 認証(ログイン)種別
                                final providerId =
                                    userNotifier.fetchProviderId();

                                /// 匿名
                                if (providerId == null) {
                                  await EasyLoading.show(status: 'loading...');
                                  final deleteUserErrorText =
                                      await userNotifier.deleteUser(ref, null);

                                  if (deleteUserErrorText == null) {
                                    await EasyLoading.showSuccess('退会しました');
                                    var popInt = 0;
                                    Navigator.popUntil(
                                      context,
                                      (_) => popInt++ >= 2,
                                    );
                                  } else {
                                    await EasyLoading.dismiss();
                                    return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('退会失敗'),
                                          content: Text(deleteUserErrorText),
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

                                /// email
                                else if (providerId == 'password') {
                                  final email = userNotifier.fetchEmail();
                                  await showDialog<ReAuthWithEmailDialog>(
                                    context: context,
                                    builder: (context) {
                                      return ReAuthWithEmailDialog(
                                        email: email,
                                      );
                                    },
                                  );
                                }

                                /// google
                                else if (providerId == 'google.com') {
                                  await EasyLoading.show(status: 'loading...');
                                  final reAuth = await settingTopModel
                                      .reAuthWithGoogle(ref);
                                  final loginErrorText = reAuth.errorText;

                                  if (loginErrorText == null) {
                                    final deleteUserErrorText =
                                        await userNotifier.deleteUser(
                                      ref,
                                      reAuth.credential,
                                    );

                                    if (deleteUserErrorText == null) {
                                      await EasyLoading.showSuccess('退会しました');
                                      var popInt = 0;
                                      Navigator.popUntil(
                                        context,
                                        (_) => popInt++ >= 2,
                                      );
                                    } else {
                                      await EasyLoading.dismiss();
                                      return showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('退会失敗'),
                                            content: Text(deleteUserErrorText),
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
                                  } else {
                                    await EasyLoading.dismiss();
                                    return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('認証失敗'),
                                          content: Text(loginErrorText),
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

                                /// apple
                                else if (providerId == 'apple.com') {
                                  await EasyLoading.show(status: 'loading...');
                                  final reAuth = await settingTopModel
                                      .reAuthWithApple(ref);
                                  final loginErrorText = reAuth.errorText;

                                  if (loginErrorText == null) {
                                    final deleteUserErrorText =
                                        await userNotifier.deleteUser(
                                      ref,
                                      reAuth.credential,
                                    );

                                    if (deleteUserErrorText == null) {
                                      await EasyLoading.showSuccess('退会しました');
                                      var popInt = 0;
                                      Navigator.popUntil(
                                        context,
                                        (_) => popInt++ >= 2,
                                      );
                                    } else {
                                      await EasyLoading.dismiss();
                                      return showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('退会失敗'),
                                            content: Text(deleteUserErrorText),
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
                                  } else {
                                    await EasyLoading.dismiss();
                                    return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('認証失敗'),
                                          content: Text(loginErrorText),
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
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<bool> sendInquiry() async {
    try {
      final email = Email(
        body: 'お困りの状況について、以下のフォーマットを参考にお問い合わせいただけますと幸いです。'
            '\n\n■お問い合わせフォーマット'
            '\n1.発生した事象やお困りの状況の詳細(画面の表示や挙動など)'
            '\n\n2.事象が発生した日時'
            '\n\n3.事象発生時に行った操作'
            '\n\n4.その他',
        recipients: ['toda.myrecipe@gmail.com'],
      );
      await FlutterEmailSender.send(email);
      return true;
    } on Exception {
      return false;
    }
  }
}

class ReAuthWithEmailDialog extends ConsumerWidget {
  const ReAuthWithEmailDialog({Key? key, required this.email})
      : super(key: key);

  final String email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNotifier = ref.watch(userStateNotifierProvider.notifier);

    final password = ref.watch(passwordProvider);
    final passwordNotifier = ref.watch(passwordProvider.notifier);

    final passwordIsObscure = ref.watch(passwordIsObscureProvider);
    final passwordIsObscureNotifier =
        ref.watch(passwordIsObscureProvider.notifier);

    return AlertDialog(
      title: const Text('退会するために再度認証をお願いします。'),
      content: SizedBox(
        height: 140.h,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8).r,
              child: Row(
                children: [
                  const Icon(Icons.mail_outline_rounded),
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    email,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8).r,
              child: TextField(
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
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('キャンセル'),
          onPressed: () {
            var popInt = 0;
            Navigator.popUntil(context, (_) => popInt++ >= 2);
          },
        ),
        TextButton(
          child: const Text('再認証して退会'),
          onPressed: () async {
            await EasyLoading.show(status: 'loading...');
            final reAuth =
                await userNotifier.reAuthWithEmail(ref, email, password);
            final loginErrorText = reAuth.errorText;

            if (loginErrorText == null) {
              final deleteUserErrorText =
                  await userNotifier.deleteUser(ref, reAuth.credential);

              if (deleteUserErrorText == null) {
                await EasyLoading.showSuccess('退会しました');
                var popInt = 0;
                Navigator.popUntil(context, (_) => popInt++ >= 3);
              }
            } else {
              await EasyLoading.dismiss();
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('認証失敗'),
                    content: Text(loginErrorText),
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
          },
        ),
      ],
    );
  }
}
