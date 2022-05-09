import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:recipe/domain/recipe.dart';
import 'package:uuid/uuid.dart';

class RecipeRepository {
  RecipeRepository({required this.user, this.recipe});

  final User user;
  final Recipe? recipe;

  int ingredientListOrderNum = 0;
  int procedureListOrderNum = 0;

  /// delete
  Future deleteRecipe(Recipe recipe) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .doc(recipe.recipeId)
        .delete();
  }

  Future deleteIngredients(String recipeId) async {
    try {
      final deleteIngredients = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('recipes')
          .doc(recipeId)
          .collection('ingredients')
          .get();

      deleteIngredients.docs.forEach((doc) {
        doc.reference.delete();
      });
      print('材料削除成功');
    } catch (e) {
      print('材料削除失敗');
      print('e:' + e.toString());
    }
  }

  Future deleteProcedures(String recipeId) async {
    try {
      final deleteProcedures = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('recipes')
          .doc(recipeId)
          .collection('procedures')
          .get();

      deleteProcedures.docs.forEach((doc) {
        doc.reference.delete();
      });
      print('手順削除成功');
    } catch (e) {
      print('手順削除失敗');
      print('e:' + e.toString());
    }
  }

  Future deleteImage(Recipe recipe) async {
    final imageRef = FirebaseStorage.instance.refFromURL(recipe.imageUrl!);

    try {
      await imageRef.delete();
      print('レシピ画像削除成功');
    } catch (e) {
      print('レシピ画像削除失敗');
      print('e:' + e.toString());
    }
  }

  /// fetch
  Stream<Recipe> fetchRecipe(String recipeId) {
    final recipeDocument = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .doc(recipeId);

    final recipeStream =
        recipeDocument.snapshots().map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

      final String? recipeId = document.id;
      final String recipeName = data['recipeName'];
      final double? recipeGrade = data['recipeGrade'];
      final int? forHowManyPeople = data['forHowManyPeople'];
      final int? countInCart = data['countInCart'];
      final String? recipeMemo = data['recipeMemo'];
      final String? imageUrl = data['imageUrl'];
      final File? imageFile = null;
      // ingredient関連
      final Map<String, Map<String, dynamic>> ingredientListMap =
          Map<String, Map<String, dynamic>>.from(data['ingredientList']);
      // print('ingredientListMap : $ingredientListMap');
      final List<Ingredient> ingredientList = [];
      ingredientListMap.forEach((key, value) {
        ingredientList.add(Ingredient(
            id: Uuid().v4(),
            name: value['ingredientName'],
            amount: value['ingredientAmount'],
            unit: value['ingredientUnit']));
      });

      return Recipe(
        recipeId: recipeId,
        recipeName: recipeName,
        recipeGrade: recipeGrade,
        forHowManyPeople: forHowManyPeople,
        countInCart: countInCart,
        recipeMemo: recipeMemo,
        imageUrl: imageUrl,
        imageFile: imageFile,
        ingredientList: ingredientList,
      );
    });

    return recipeStream;
  }

  Stream<List<Recipe>> fetchRecipeNameList(String searchWord) {
    final recipeCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .orderBy('createdAt');

    final recipeListStream =
        recipeCollection.snapshots().asBroadcastStream().map(
              // CollectionのデータからItemクラスを生成する
              (e) => e.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                final String? recipeId = document.id;
                final String recipeName = data['recipeName'];
                final double? recipeGrade = data['recipeGrade'];
                final int? forHowManyPeople = data['forHowManyPeople'];
                final int? countInCart = data['countInCart'];
                final String? recipeMemo = data['recipeMemo'];
                final String? imageUrl = data['imageUrl'];
                final File? imageFile = null;

                return Recipe(
                  recipeId: recipeId,
                  recipeName: recipeName,
                  recipeGrade: recipeGrade,
                  forHowManyPeople: forHowManyPeople,
                  countInCart: countInCart,
                  recipeMemo: recipeMemo,
                  imageUrl: imageUrl,
                  imageFile: imageFile,
                );
              }).toList(),
            );

    return recipeListStream;
  }

  Stream<List<Recipe>> fetchRecipeList() {
    final recipeCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .orderBy('createdAt');

    // データ（Map型）を取得
    final recipeListStream = recipeCollection
        .snapshots()
        .asBroadcastStream()
        .map(
          (e) => e.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            final String? recipeId = document.id;
            final String recipeName = data['recipeName'];
            final double? recipeGrade = data['recipeGrade'];
            final int? forHowManyPeople = data['forHowManyPeople'];
            final int? countInCart = data['countInCart'];
            final String? recipeMemo = data['recipeMemo'];
            final String? imageUrl = data['imageUrl'];
            final File? imageFile = null;
            // ingredient関連
            final Map<String, Map<String, dynamic>> ingredientListMap =
                Map<String, Map<String, dynamic>>.from(data['ingredientList']);
            // print('ingredientListMap : $ingredientListMap');
            final List<Ingredient> ingredientList = [];
            ingredientListMap.forEach((key, value) {
              ingredientList.add(Ingredient(
                  id: Uuid().v4(),
                  name: value['ingredientName'],
                  amount: value['ingredientAmount'],
                  unit: value['ingredientUnit']));
            });
            // print('ingredientList : $ingredientList');

            return Recipe(
              recipeId: recipeId,
              recipeName: recipeName,
              recipeGrade: recipeGrade,
              forHowManyPeople: forHowManyPeople,
              countInCart: countInCart,
              recipeMemo: recipeMemo,
              imageUrl: imageUrl,
              imageFile: imageFile,
              ingredientList: ingredientList,
            );
          }).toList(),
        );

    return recipeListStream;
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

            final String? name = data['name'];
            final String? amount = data['amount'];
            final String? unit = data['unit'];

            return Ingredient(
                id: Uuid().v4(), name: name, amount: amount, unit: unit);
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

            final String? content = data['content'];

            return Procedure(id: Uuid().v4(), content: content);
          }).toList(),
        );

    return procedureStream;
  }

  /// add
  Future<DocumentReference> addRecipe(Recipe recipe,
      Map<String, Map<String, dynamic>>? ingredientListMap) async {
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
      'createdAt': DateTime.now(),
      'imageUrl': '',
      'ingredientList': ingredientListMap,
    });
    return docRef;
  }

  Future addImage(File imageFile, String recipeId) async {
    final int timestamp = DateTime.now().microsecondsSinceEpoch;

    final String name = imageFile.path.split('/').last;
    final String path = '${timestamp}_$name';
    final TaskSnapshot task = await FirebaseStorage.instance
        .ref()
        .child('users/${user.uid}/recipeImages/$recipeId')
        .child(path)
        .putFile(imageFile);

    final imageUrl = await task.ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .doc(recipeId)
        .update({'imageUrl': imageUrl});
  }

  //TODO 不要になったら消す
  Future addIngredient(List<Ingredient> ingredientList, String recipeId) async {
    for (int i = 0; i < ingredientList.length; i++) {
      if (ingredientList[i].name != '') {
        print('test:' + ingredientList[i].name!);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('recipes')
            .doc(recipeId)
            .collection('ingredients')
            .add({
          'name': ingredientList[i].name,
          'amount': ingredientList[i].amount,
          'unit': ingredientList[i].unit,
          'orderNum': ingredientListOrderNum,
        });
        ingredientListOrderNum++;
      }
    }
  }

  /// TODO不要になったら消す
  Future addProcedure(List<Procedure> procedureList, String recipeId) async {
    for (int i = 0; i < procedureList.length; i++) {
      if (procedureList[i].content != '') {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('recipes')
            .doc(recipeId)
            .collection('procedures')
            .add({
          'content': procedureList[i].content,
          'orderNum': procedureListOrderNum
        });
        procedureListOrderNum++;
      }
    }
  }

  /// update
  Future updateRecipe(String originalRecipeId, Recipe recipe) async {
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
    });
  }
}
