import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:recipe/view/setting/privacy_policy/privacy_policy_page.dart';
import 'package:recipe/view/setting/setting_top/setting_top_model.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/view/other/edit_ingredient_unit/edit_ingredient_unit_page.dart';
import 'package:recipe/view/setting/account/login/login_page.dart';
import 'package:recipe/view/setting/account/sign_up/sign_up_page.dart';
import 'package:recipe/view/setting/customize/edit_theme/edit_theme_page.dart';
import 'package:recipe/view/setting/send_feedback/send_feedback_page.dart';
import 'package:recipe/view/setting/terms/terms_page.dart';

class SettingTopPage extends ConsumerWidget {
  const SettingTopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateNotifierProvider);
    final userNotifier = ref.watch(userStateNotifierProvider.notifier);

    final SettingTopModel settingTopModel = SettingTopModel();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '設定',
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text(
              'アカウント',
            ),
            tiles: [
              user!.isAnonymous
                  ? SettingsTile.navigation(
                      title: Text('ログイン'),
                      trailing: Icon(Icons.chevron_right_rounded),
                      onPressed: (context) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              fullscreenDialog: false,
                              builder: (context) => LoginPage(),
                            ));
                      },
                    )
                  : SettingsTile.navigation(
                      title: Text('${user.email}'),
                      trailing: Text(''),
                    ),
              user.isAnonymous
                  ? SettingsTile.navigation(
                      title: Text('新規登録'),
                      trailing: Icon(Icons.chevron_right_rounded),
                      onPressed: (context) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              fullscreenDialog: false,
                              builder: (context) => SignUpPage(),
                            ));
                      },
                    )
                  : SettingsTile.navigation(
                      title: Text('ログアウト'),
                      trailing: Icon(Icons.logout_rounded),
                      onPressed: (context) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('確認'),
                              content: Text('本当にログアウトしますか？'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('いいえ'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: Text('はい'),
                                  onPressed: () async {
                                    EasyLoading.show(status: 'loading...');
                                    await userNotifier.signOut();
                                    Navigator.pop(context);
                                    EasyLoading.showSuccess('ログアウトしました');
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
            title: Text('カスタマイズ'),
            tiles: [
              SettingsTile.navigation(
                title: Text('材料の単位を編集'),
                trailing: Icon(Icons.chevron_right_rounded),
                onPressed: (context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditIngredientUnitPage(),
                        fullscreenDialog: false,
                      ));
                },
              ),
              SettingsTile.navigation(
                title: Text('テーマの変更'),
                trailing: Icon(Icons.chevron_right_rounded),
                onPressed: (context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditThemePage(),
                        fullscreenDialog: false,
                      ));
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('サポート'),
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
                title: Text('ご意見・ご要望'),
                trailing: Icon(Icons.chevron_right_rounded),
                onPressed: (context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SendFeedbackPage(),
                        fullscreenDialog: false,
                      ));
                },
              ),
              SettingsTile.navigation(
                title: Text('お問い合わせ'),
                trailing: Icon(Icons.chevron_right_rounded),
                onPressed: (context) async {
                  if (!await sendInquiry()) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('エラー'),
                          content: Text('エラーが発生しました。\n再度お試しください。'
                              '\n\n何度かお試しいただいても解決されない場合、お手数ではございますが次の宛先までお問い合わせ内容をお送りください。\n\ntoda.myrecipe@gmail.com'),
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
                },
              ),
              SettingsTile.navigation(
                title: Text('レビューを書く'),
                trailing: Icon(Icons.chevron_right_rounded),
                onPressed: (context) async {
                  final InAppReview inAppReview = InAppReview.instance;

                  if (await inAppReview.isAvailable()) {
                    inAppReview.requestReview();
                  }
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('アプリについて'),
            tiles: [
              SettingsTile.navigation(
                title: Text('利用規約'),
                trailing: Icon(Icons.chevron_right_rounded),
                onPressed: (context) async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TermsPage(),
                        fullscreenDialog: false,
                      ));
                },
              ),
              SettingsTile.navigation(
                title: Text('プライバシーポリシー'),
                trailing: Icon(Icons.chevron_right_rounded),
                onPressed: (context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivacyPolicyPage(),
                        fullscreenDialog: false,
                      ));
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
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('確認'),
                        content: Text(
                            '本当に退会しますか？\n\n※ログインしている場合、退会するには再度認証が必要です。\n※退会した場合、登録したアカウントやレシピの情報全てが削除され、二度とログインすることができなくなります。'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('いいえ'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text('はい（認証へ進む）'),
                            onPressed: () async {
                              // providerId : 認証(ログイン)種別
                              final providerId = userNotifier.fetchProviderId();
                              print(providerId);

                              /// 匿名
                              if (providerId == null) {
                                EasyLoading.show(status: 'loading...');
                                final deleteUserErrorText =
                                    await userNotifier.deleteUser(ref, null);

                                if (deleteUserErrorText == null) {
                                  EasyLoading.showSuccess('退会しました');
                                  int popInt = 0;
                                  Navigator.popUntil(
                                      context, (_) => popInt++ >= 2);
                                } else {
                                  EasyLoading.dismiss();
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('退会失敗'),
                                        content: Text('$deleteUserErrorText'),
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

                              /// email
                              else if (providerId == 'password') {
                                final email = userNotifier.fetchEmail();
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ReAuthWithEmailDialog(email);
                                  },
                                );
                              }

                              /// google
                              else if (providerId == 'google.com') {
                                EasyLoading.show(status: 'loading...');
                                final reAuth =
                                    await settingTopModel.reAuthWithGoogle(ref);
                                final loginErrorText = reAuth.errorText;

                                if (loginErrorText == null) {
                                  final deleteUserErrorText = await userNotifier
                                      .deleteUser(ref, reAuth.credential);

                                  if (deleteUserErrorText == null) {
                                    EasyLoading.showSuccess('退会しました');
                                    int popInt = 0;
                                    Navigator.popUntil(
                                        context, (_) => popInt++ >= 2);
                                  } else {
                                    EasyLoading.dismiss();
                                    return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('退会失敗'),
                                          content: Text('$deleteUserErrorText'),
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
                                } else {
                                  EasyLoading.dismiss();
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('認証失敗'),
                                        content: Text('$loginErrorText'),
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

                              /// apple
                              else if (providerId == 'apple.com') {
                                EasyLoading.show(status: 'loading...');
                                final reAuth =
                                    await settingTopModel.reAuthWithApple(ref);
                                final loginErrorText = reAuth.errorText;

                                if (loginErrorText == null) {
                                  final deleteUserErrorText = await userNotifier
                                      .deleteUser(ref, reAuth.credential);

                                  if (deleteUserErrorText == null) {
                                    EasyLoading.showSuccess('退会しました');
                                    int popInt = 0;
                                    Navigator.popUntil(
                                        context, (_) => popInt++ >= 2);
                                  } else {
                                    EasyLoading.dismiss();
                                    return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('退会失敗'),
                                          content: Text('$deleteUserErrorText'),
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
                                } else {
                                  EasyLoading.dismiss();
                                  return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('認証失敗'),
                                        content: Text('$loginErrorText'),
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
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ))
        ],
      ),
    );
  }

  Future<bool> sendInquiry() async {
    try {
      final Email email = Email(
        body:
            'お困りの状況について、以下のフォーマットを参考にお問い合わせいただけますと幸いです。\n\n■お問い合わせフォーマット\n1.発生した事象やお困りの状況の詳細(画面の表示や挙動など)\n\n2.事象が発生した日時\n\n3.事象発生時に行った操作\n\n4.その他',
        subject: '',
        recipients: ['toda.myrecipe@gmail.com'],
      );
      await FlutterEmailSender.send(email);
      return true;
    } catch (e) {
      return false;
    }
  }
}

class ReAuthWithEmailDialog extends ConsumerWidget {
  ReAuthWithEmailDialog(this.email);

  final email;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNotifier = ref.watch(userStateNotifierProvider.notifier);

    final password = ref.watch(passwordProvider);
    final passwordNotifier = ref.watch(passwordProvider.notifier);

    final passwordIsObscure = ref.watch(passwordIsObscureProvider);
    final passwordIsObscureNotifier =
        ref.watch(passwordIsObscureProvider.notifier);

    return AlertDialog(
      title: Text('退会するために再度認証をお願いします。'),
      content: SizedBox(
        height: 140.h,
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8).r,
                child: Row(
                  children: [
                    Icon(Icons.mail_outline_rounded),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      email,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                )),
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
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('キャンセル'),
          onPressed: () {
            int popInt = 0;
            Navigator.popUntil(context, (_) => popInt++ >= 2);
          },
        ),
        TextButton(
          child: Text('再認証して退会'),
          onPressed: () async {
            EasyLoading.show(status: 'loading...');
            final reAuth =
                await userNotifier.reAuthWithEmail(ref, email, password);
            final loginErrorText = reAuth.errorText;

            if (loginErrorText == null) {
              final deleteUserErrorText =
                  await userNotifier.deleteUser(ref, reAuth.credential);

              if (deleteUserErrorText == null) {
                EasyLoading.showSuccess('退会しました');
                int popInt = 0;
                Navigator.popUntil(context, (_) => popInt++ >= 3);
              }
            } else {
              EasyLoading.dismiss();
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('認証失敗'),
                    content: Text('$loginErrorText'),
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
          },
        ),
      ],
    );
  }
}
