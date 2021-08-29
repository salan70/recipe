import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'recipe_list/recipe_list_screen.dart';
import 'package:recipe/sign_in/sign_in_screen.dart';

// 一旦コメントアウト
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(ProviderScope(child: MyRecipeApp()));
// }
//
// class MyRecipeApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'My Recipe App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: RecipeListPage(),
//     );
//   }
// }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // アプリ起動時にログイン画面を表示
      home: SignInScreen(),
    );
  }
}
