import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/view/other/edit_ingredient_unit/edit_ingredient_unit_page.dart';
import 'package:recipe/view/recipe/add_cart_recipe_list/add_cart_recipe_list_page.dart';
import 'package:recipe/view/setting/account/login/login_page.dart';
import 'package:recipe/view/setting/account/sign_up/sign_up_page.dart';
import 'package:recipe/view/setting/customize/edit_theme_color/edit_theme_color_page.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/components/providers.dart';

// レシピ一覧画面
class SettingTopPage extends ConsumerWidget {
  const SettingTopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateNotifierProvider);
    final userNotifier = ref.watch(userStateNotifierProvider.notifier);

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
                      trailing: Icon(Icons.chevron_right_rounded),
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
                title: Text('テーマカラーの変更'),
                trailing: Icon(Icons.chevron_right_rounded),
                onPressed: (context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditThemeColorPage(),
                        fullscreenDialog: false,
                      ));
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('サポート'),
            tiles: [
              SettingsTile.navigation(
                title: Text('お知らせ'),
                trailing: Icon(Icons.chevron_right_rounded),
              ),
              SettingsTile.navigation(
                title: Text('使い方'),
                trailing: Icon(Icons.chevron_right_rounded),
              ),
              SettingsTile.navigation(
                title: Text('ご意見・ご要望'),
                trailing: Icon(Icons.chevron_right_rounded),
              ),
              SettingsTile.navigation(
                title: Text('お問い合わせ'),
                trailing: Icon(Icons.chevron_right_rounded),
              ),
              SettingsTile.navigation(
                title: Text('レビューを書く'),
                trailing: Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          SettingsSection(
            title: Text('アプリについて'),
            tiles: [
              SettingsTile.navigation(
                title: Text('利用規約'),
                trailing: Icon(Icons.chevron_right_rounded),
              ),
              SettingsTile.navigation(
                title: Text('プライバシーポリシー'),
                trailing: Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
