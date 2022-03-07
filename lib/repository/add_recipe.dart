import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:recipe/domain/recipe.dart';

class AddRecipeRepository {
  AddRecipeRepository(this.recipeName, this.imageUrl, this.recipeGrade,
      this.forHowManyPeople, this.recipeMemo, this.imageFile);

  String? recipeName;
  double? recipeGrade;
  int? forHowManyPeople;
  String? recipeMemo;
  String? imageUrl;
  File? imageFile;

  Future addRecipe(String uid, Recipe recipe) async {
    final int timestamp = DateTime.now().microsecondsSinceEpoch;
    final DateTime nowDatetime = DateTime.now();

    // 画像をStorageに保存
    if (recipe.imageFile != null) {
      File imageFile = recipe.imageFile!;
      final String name = imageFile.path.split('/').last;
      final String path = '${timestamp}_$name';
      final TaskSnapshot task = await FirebaseStorage.instance
          .ref()
          .child('users/$uid/recipeImages')
          .child(path)
          .putFile(imageFile);

      imageUrl = await task.ref.getDownloadURL();
    }

    //レシピを保存
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('recipes')
        .add({
      'recipeName': recipe.recipeName,
      'recipeGrade': recipe.recipeGrade,
      'forHowManyPeople': recipe.forHowManyPeople,
      'recipeMemo': recipe.recipeMemo,
      'imageUrl': imageUrl,
      'createdAt': nowDatetime
    });

    print(docRef.id);
    int ingredientListOrderNum = 0;

    // 材料を保存
    if (recipe.ingredientList != null) {
      for (int i = 0; i < recipe.ingredientList!.length; i++) {
        if (recipe.ingredientList![i].name != '') {
          print('test:' + recipe.ingredientList![i].name!);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .collection('recipes')
              .doc(docRef.id)
              .collection('ingredients')
              .add({
            'id': recipe.ingredientList![i].id,
            'name': recipe.ingredientList![i].name,
            'amount': recipe.ingredientList![i].amount,
            'unit': recipe.ingredientList![i].unit,
            'orderNum': ingredientListOrderNum,
          });
          ingredientListOrderNum++;
        }
      }
    }

    // 手順を保存
    if (recipe.procedureList != null) {
      for (int i = 0; i < recipe.procedureList!.length; i++) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('recipes')
            .doc(docRef.id)
            .collection('procedures')
            .add({
          'id': recipe.procedureList![i].id,
          'content': recipe.procedureList![i].content,
          'orderNum': i
        });
      }
    }
  }
}
