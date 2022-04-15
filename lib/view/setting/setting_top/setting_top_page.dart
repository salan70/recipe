import 'dart:io';

import 'package:flutter/material.dart';
import 'package:recipe/view/recipe/add_cart_recipe_list/add_cart_recipe_list_page.dart';
import 'package:recipe/view/setting/account/sign_up/sign_up_page.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe/components/providers.dart';

// レシピ一覧画面
class SettingTopPage extends ConsumerWidget {
  const SettingTopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              SettingsTile.navigation(
                title: Text('ログイン'),
                trailing: Icon(Icons.chevron_right_rounded),
              ),
              SettingsTile.navigation(
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
              ),
            ],
          ),
          SettingsSection(
            title: Text('カスタマイズ'),
            tiles: [
              SettingsTile.navigation(
                title: Text('材料の単位を編集'),
                trailing: Icon(Icons.chevron_right_rounded),
              ),
              SettingsTile.navigation(
                title: Text('テーマカラーの変更'),
                trailing: Icon(Icons.chevron_right_rounded),
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
              SettingsTile.navigation(
                title: Text('コピーライト'),
                trailing: Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
        ],
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Container(
      //     width: double.infinity,
      //     child: ListView(
      //       children: [
      //         Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text(
      //               'アカウント',
      //               style: Theme.of(context).primaryTextTheme.subtitle1,
      //               textAlign: TextAlign.left,
      //             ),
      //
      //           ],
      //         )
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
