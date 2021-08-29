import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe/recipe_list/recipe_list_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // メールアドレス用のTextEditingController
  final TextEditingController _emailController = TextEditingController();
  // パスワード用のTextEditingController
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _formKey,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          // Columnを使い縦に並べる
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // タイトル
              Text(
                'Photo App',
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(height: 16),
              // 入力フォーム（メールアドレス）
              TextFormField(
                decoration: InputDecoration(labelText: 'メールアドレス'),
                keyboardType: TextInputType.emailAddress,
                // メールアドレス用のバリデーション
                validator: (String? value) {
                  if (value?.isEmpty == true) {
                    return 'メールアドレスを入力してください!!!';
                  }
                  return null;
                },
              ),

              SizedBox(height: 8),
              // 入力フォーム（パスワード）
              TextFormField(
                decoration: InputDecoration(labelText: 'パスワード'),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                // パスワード用のバリデーション
                validator: (String? value) {
                  if (value?.isEmpty == true) {
                    Text('パスワード入力してください');
                    return 'パスワードを入力してください!!!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                // ボタン（ログイン）
                child: ElevatedButton(
                  onPressed: () => _onSignIn(),
                  child: Text('ログイン'),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                // ボタン（新規登録）
                child: ElevatedButton(
                  onPressed: () => _onSignUp(),
                  child: Text('新規登録'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSignIn() {
    // 入力内容を確認する
    if (_formKey.currentState?.validate() != true) {
      // エラーメッセージがあるため処理を中断する
      return;
    }
  }

  Future<void> _onSignUp() async {
    print('in onSignUp');
    try {
      if (_formKey.currentState?.validate() != true) {
        return;
      }

      // メールアドレス・パスワードで新規登録
      //   TextEditingControllerから入力内容を取得
      //   Authenticationを使った複雑な処理はライブラリがやってくれる
      final String email = _emailController.text;
      final String password = _passwordController.text;
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // レシピ一覧画面に切り替え
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => RecipeListPage(),
        ),
      );
    } catch (e) {
      // 失敗したらエラーメッセージを表示
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('エラー'),
            content: Text(e.toString()),
          );
        },
      );
    }
  }
}
