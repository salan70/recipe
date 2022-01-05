import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'auth/auth_controller.dart';
import 'package:recipe/view/recipe_list/recipe_list_screen.dart';
import 'package:recipe/sign_in/sign_in_screen.dart';

//main()を非同期を制御する
void main() async {
//アプリ起動時に処理したいので追記
  WidgetsFlutterBinding.ensureInitialized();
//Firebaseの初期化（同期）
  await Firebase.initializeApp();
//MyApp()をProviderScopeでラップして、アプリ内のどこからでも全てのプロバイダーにアクセスできるようにする。
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      // home: RecipeListPage(),
    );
  }
}

class HomeScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // final authControllerState = useProvider(authControllerProvider);
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('ShoppingList'),
    //     leading: authControllerState != null
    //         ? IconButton(
    //             onPressed: () =>
    //                 context.read(authControllerProvider.notifier).signOut(),
    //             icon: Icon(Icons.logout))
    //         : null,
    //   ),
    // );

    return MaterialApp(
      home: RecipeListPage(),
    );
  }
}

// アプリ起動時にログイン画面を表示するパターン
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Recipe App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       // アプリ起動時にログイン画面を表示
//       home: SignInScreen(),
//     );
//   }
// }

// アプリ起動時にレシピ一覧画面を表示するパターン
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Recipe App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       // アプリ起動時にログイン画面を表示
//       home: RecipeListPage(),
//     );
//   }
// }
