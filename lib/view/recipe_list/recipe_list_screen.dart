import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:recipe/providers.dart';

import 'package:recipe/auth/auth_controller.dart';
import 'package:recipe/view/add_recipe/add_recipe_screen.dart';

// レシピ一覧画面
class RecipeListPage extends ConsumerWidget {
  const RecipeListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'レシピ一覧',
          style: TextStyle(
            color: Colors.green,
          ),
        ),
      ),
      body: ListView(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Colors.green,
          size: 30.0,
        ),
        elevation: 3.0,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddRecipeScreen(),
                fullscreenDialog: true,
              ));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(height: 50.0),
        shape: CircularNotchedRectangle(),
      ),
    );
  }

//   Future<void> _onAddRecipe() async {
//     print('onPressed');
//     // 画像ファイルを選択
//     final FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//     );
//
//     // 画像ファイルが選択された場合
//     if (result != null) {
//       // ログイン中のユーザー情報を取得
//       final User user = FirebaseAuth.instance.currentUser!;
//
//       // フォルダとファイル名を指定し画像ファイルをアップロード
//       final int timestamp = DateTime.now().microsecondsSinceEpoch;
//       final File file = File(result.files.single.path!);
//       final String name = file.path.split('/').last;
//       final String path = '${timestamp}_$name';
//       final TaskSnapshot task = await FirebaseStorage.instance
//           .ref()
//           .child('users/${user.uid}/photos') // フォルダ名
//           .child(path) // ファイル名
//           .putFile(file); // 画像ファイル
//     }
//   }
//
}
