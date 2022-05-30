import 'dart:collection';
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

  // deleteRecipeの前にdeleteImageをする
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
      final sortedIngredientListMap = SplayTreeMap.from(ingredientListMap,
          (String key, String value) => key.compareTo(value));
      final List<Ingredient> ingredientList = [];
      sortedIngredientListMap.forEach((key, value) {
        ingredientList.add(Ingredient(
            id: Uuid().v4(),
            name: value['ingredientName'],
            amount: value['ingredientAmount'],
            unit: value['ingredientUnit']));
      });
      // procedure関連
      final Map<String, Map<String, dynamic>> procedureListMap =
          Map<String, Map<String, dynamic>>.from(data['procedureList']);
      final sortedProcedureListMap = SplayTreeMap.from(
          procedureListMap, (String key, String value) => key.compareTo(value));
      final List<Procedure> procedureList = [];
      sortedProcedureListMap.forEach((key, value) {
        procedureList.add(Procedure(
          id: Uuid().v4(),
          content: value['content'],
        ));
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
        procedureList: procedureList,
      );
    });

    return recipeStream;
  }

  // search用
  Stream<List<RecipeAndIngredientName>> fetchRecipeNameAndIngredientNameList() {
    final recipeCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .orderBy('createdAt');

    final recipeNameAndIngredientNameListStream = recipeCollection
        .snapshots()
        .asBroadcastStream()
        .map(
          (e) => e.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            final String recipeId = document.id;
            final String recipeName = data['recipeName'];
            // ingredient関連
            final Map<String, Map<String, dynamic>> ingredientListMap =
                Map<String, Map<String, dynamic>>.from(data['ingredientList']);
            final sortedIngredientListMap = SplayTreeMap.from(ingredientListMap,
                (String key, String value) => key.compareTo(value));
            final List<String> ingredientNameList = [];
            sortedIngredientListMap.forEach((key, value) {
              ingredientNameList.add(value['ingredientName']);
            });

            return RecipeAndIngredientName(
              recipeId: recipeId,
              recipeName: recipeName,
              ingredientNameList: ingredientNameList,
            );
          }).toList(),
        );

    return recipeNameAndIngredientNameListStream;
  }

  Stream<List<Recipe>> fetchRecipeList() {
    final recipeCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .orderBy('createdAt');

    // データ（Map型）を取得
    final recipeListStream =
        recipeCollection.snapshots().asBroadcastStream().map(
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
                  // ingredientList: ingredientList,
                );
              }).toList(),
            );

    return recipeListStream;
  }

  /// add
  Future<DocumentReference> addRecipe(
      Recipe recipe,
      Map<String, Map<String, dynamic>>? ingredientListMap,
      Map<String, Map<String, dynamic>>? procedureListMap) async {
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
      'procedureList': procedureListMap,
      'countInCart': 0,
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

  /// update
  Future updateRecipe(
      String originalRecipeId,
      Recipe recipe,
      Map<String, Map<String, dynamic>>? ingredientListMap,
      Map<String, Map<String, dynamic>>? procedureListMap) async {
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
      'ingredientList': ingredientListMap,
      'procedureList': procedureListMap,
    });
  }
}
