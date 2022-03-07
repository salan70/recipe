import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:recipe/domain/recipe.dart';

class RecipeRepository {
  RecipeRepository(this.user);

  final User user;

  Stream<List<Recipe>> fetchRecipeList() {
    final recipeCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .orderBy('createdAt');

    // データ（Map型）を取得
    final recipeStream = recipeCollection.snapshots().asBroadcastStream().map(
          // CollectionのデータからItemクラスを生成する
          (e) => e.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            final String? recipeId = document.id;
            final String recipeName = data['recipeName'];
            final double? recipeGrade = data['recipeGrade'];
            final int? forHowManyPeople = data['forHowManyPeople'];
            final String? recipeMemo = data['recipeMemo'];
            final String? imageUrl = data['imageUrl'];
            final File? imageFile = null;

            return Recipe(
              recipeId: recipeId,
              recipeName: recipeName,
              recipeGrade: recipeGrade,
              forHowManyPeople: forHowManyPeople,
              recipeMemo: recipeMemo,
              imageUrl: imageUrl,
              imageFile: imageFile,
            );
          }).toList(),
        );

    return recipeStream;
  }

  Stream<List<Ingredient>> fetchIngredientList(String recipeId) {
    final ingredientCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .doc(recipeId)
        .collection('ingredients')
        .orderBy('orderNum');

    // データ（Map型）を取得
    final ingredientStream = ingredientCollection.snapshots().map(
          // CollectionのデータからItemクラスを生成する
          (e) => e.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            final String id = data['id'];
            final String? name = data['name'];
            final String? amount = data['amount'];
            final String? unit = data['unit'];

            return Ingredient(id: id, name: name, amount: amount, unit: unit);
          }).toList(),
        );

    return ingredientStream;
  }

  Stream<List<Procedure>> fetchProcedureList(String recipeId) {
    final ingredientCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .doc(recipeId)
        .collection('procedures')
        .orderBy('orderNum');

    // データ（Map型）を取得
    final procedureStream = ingredientCollection.snapshots().map(
          // CollectionのデータからItemクラスを生成する
          (e) => e.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            final String? id = data['id'];
            final String? content = data['content'];

            return Procedure(id: id, content: content);
          }).toList(),
        );

    return procedureStream;
  }

  Future deleteRecipe(String recipeId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .doc(recipeId)
        .delete();
  }

  Future addRecipe(Recipe recipe) async {
    final int timestamp = DateTime.now().microsecondsSinceEpoch;
    final DateTime nowDatetime = DateTime.now();
    String imageUrl = '';

    // 画像をStorageに保存
    if (recipe.imageFile != null) {
      File imageFile = recipe.imageFile!;
      final String name = imageFile.path.split('/').last;
      final String path = '${timestamp}_$name';
      final TaskSnapshot task = await FirebaseStorage.instance
          .ref()
          .child('users/${user.uid}/recipeImages')
          .child(path)
          .putFile(imageFile);

      imageUrl = await task.ref.getDownloadURL();
    }

    //レシピを保存
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
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
              .doc(user.uid)
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
            .doc(user.uid)
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
