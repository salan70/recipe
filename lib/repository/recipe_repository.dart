import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:recipe/domain/recipe.dart';

class RecipeRepository {
  RecipeRepository({required this.user, this.recipe});

  final User user;
  final Recipe? recipe;

  int ingredientListOrderNum = 0;
  int procedureListOrderNum = 0;

  /// delete
  Future deleteRecipe(Recipe recipe) async {
    _deleteIngredients(recipe);
    _deleteProcedures(recipe);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .doc(recipe.recipeId)
        .delete();

    if (recipe.imageUrl != '') {
      _deleteImage(recipe);
    }
    print('delete:' + recipe.recipeId!);
  }

  Future<void> _deleteIngredients(Recipe recipe) async {
    try {
      final deleteIngredients = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('recipes')
          .doc(recipe.recipeId)
          .collection('ingredients')
          .get();

      deleteIngredients.docs.forEach((doc) {
        doc.reference.delete();
      });
      print('材料削除成功');
    } catch (e) {
      print('材料削除失敗');
      print(e);
    }
  }

  Future<void> _deleteProcedures(Recipe recipe) async {
    try {
      final deleteProcedures = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('recipes')
          .doc(recipe.recipeId)
          .collection('procedures')
          .get();

      deleteProcedures.docs.forEach((doc) {
        doc.reference.delete();
      });
      print('手順削除成功');
    } catch (e) {
      print('手順削除失敗');
      print(e);
    }
  }

  Future<void> _deleteImage(Recipe recipe) async {
    final imageRef = FirebaseStorage.instance.refFromURL(recipe.imageUrl!);

    try {
      await imageRef.delete();
      print('レシピ画像削除成功');
    } catch (e) {
      print('レシピ画像削除失敗');
      print(e);
    }
  }

  /// fetch
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

  /// add
  Future addRecipe(Recipe recipe) async {
    final int timestamp = DateTime.now().microsecondsSinceEpoch;
    final DateTime nowDatetime = DateTime.now();
    String imageUrl = '';

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
      'createdAt': nowDatetime
    });

    // 画像をStorageに保存
    if (recipe.imageFile != null) {
      File imageFile = recipe.imageFile!;
      final String name = imageFile.path.split('/').last;
      final String path = '${timestamp}_$name';
      final TaskSnapshot task = await FirebaseStorage.instance
          .ref()
          .child('users/${user.uid}/recipeImages/${docRef.id}')
          .child(path)
          .putFile(imageFile);

      imageUrl = await task.ref.getDownloadURL();
    }
    await docRef.update({'imageUrl': imageUrl});

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
        if (recipe.procedureList![i].content != '') {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('recipes')
              .doc(docRef.id)
              .collection('procedures')
              .add({
            'id': recipe.procedureList![i].id,
            'content': recipe.procedureList![i].content,
            'orderNum': procedureListOrderNum
          });
          procedureListOrderNum++;
        }
      }
    }
  }

  /// update
  Future updateRecipe(String originalRecipeId, Recipe recipe) async {
    final int timestamp = DateTime.now().microsecondsSinceEpoch;
    print('imageUrl:' + recipe.imageUrl!);
    String imageUrl = '';

    // 画像をStorageに保存
    if (recipe.imageFile != null) {
      _deleteImage(recipe);

      File imageFile = recipe.imageFile!;
      final String name = imageFile.path.split('/').last;
      final String path = '${timestamp}_$name';
      final TaskSnapshot task = await FirebaseStorage.instance
          .ref()
          .child('users/${user.uid}/recipeImages/$originalRecipeId')
          .child(path)
          .putFile(imageFile);

      imageUrl = await task.ref.getDownloadURL();
    } else if (recipe.imageUrl != '') {
      imageUrl = recipe.imageUrl!;
    }

    //レシピを保存
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .doc(originalRecipeId)
        .update({
      'recipeName': recipe.recipeName,
      'recipeGrade': recipe.recipeGrade,
      'forHowManyPeople': recipe.forHowManyPeople,
      'recipeMemo': recipe.recipeMemo,
      'imageUrl': imageUrl,
    });

    // 材料を保存
    if (recipe.ingredientList != null) {
      print('test:' + recipe.ingredientList!.length.toString());

      final deleteIngredients = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('recipes')
          .doc(originalRecipeId)
          .collection('ingredients')
          .get();

      deleteIngredients.docs.forEach((doc) {
        doc.reference.delete();
      });

      for (int i = 0; i < recipe.ingredientList!.length; i++) {
        print('test2:' + recipe.ingredientList!.length.toString());
        if (recipe.ingredientList![i].name != '') {
          print('test ingredientListName:' + recipe.ingredientList![i].name!);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('recipes')
              .doc(originalRecipeId)
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
    // if (recipe.procedureList != null) {
    //   for (int i = 0; i < recipe.procedureList!.length; i++) {
    //     if (recipe.procedureList![i].content != '') {
    //       await FirebaseFirestore.instance
    //           .collection('users')
    //           .doc(user.uid)
    //           .collection('recipes')
    //           .doc(originalRecipeId)
    //           .collection('procedures')
    //           .add({
    //         'id': recipe.procedureList![i].id,
    //         'content': recipe.procedureList![i].content,
    //         'orderNum': procedureListOrderNum
    //       });
    //       procedureListOrderNum++;
    //     }
    //   }
    // }
  }
}
