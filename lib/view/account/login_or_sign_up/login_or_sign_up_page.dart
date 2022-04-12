import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// レシピ一覧画面
class LoginOrSignUpPage extends ConsumerWidget {
  const LoginOrSignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            Container(),
          ],
        ),
      ),
    );
  }
}
