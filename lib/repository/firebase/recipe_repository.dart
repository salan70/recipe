import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Future<void> deleteRecipe(Recipe recipe) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .doc(recipe.recipeId)
        .delete();
  }

  // deleteRecipeの前にdeleteImageをする
  Future<void> deleteImage(Recipe recipe) async {
    final imageRef = FirebaseStorage.instance.refFromURL(recipe.imageUrl!);

    try {
      await imageRef.delete();
    } on Exception catch (e) {
      print('e: ${e.toString()}');
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
      final data = document.data()! as Map<String, dynamic>;

      final recipeId = document.id;
      final recipeName = data['recipeName'] as String;
      final recipeGrade = data['recipeGrade'] as double?;
      final forHowManyPeople = data['forHowManyPeople'] as int;
      final countInCart = data['countInCart'] as int?;
      final recipeMemo = data['recipeMemo'] as String?;
      final imageUrl = data['imageUrl'] as String?;

      // ingredient関連
      final ingredientListMap = Map<String, dynamic>.from(
        data['ingredientList'] as Map<String, dynamic>,
      );

      final sortedIngredientListMap = SplayTreeMap<String, dynamic>.from(
        ingredientListMap,
        (String key, String value) => key.compareTo(value),
      );
      final ingredientList = <Ingredient>[];
      sortedIngredientListMap.forEach((key, dynamic value) {
        ingredientList.add(
          Ingredient(
            id: const Uuid().v4(),
            name: value['ingredientName'] as String?,
            amount: value['ingredientAmount'] as String?,
            unit: value['ingredientUnit'] as String?,
          ),
        );
      });
      // procedure関連
      final procedureListMap = Map<String, dynamic>.from(
        data['procedureList'] as Map<String, dynamic>,
      );
      final sortedProcedureListMap = SplayTreeMap<String, dynamic>.from(
        procedureListMap,
        (String key, String value) => key.compareTo(value),
      );
      final procedureList = <Procedure>[];
      sortedProcedureListMap.forEach((key, dynamic value) {
        procedureList.add(
          Procedure(
            id: const Uuid().v4(),
            content: value['content'] as String?,
          ),
        );
      });

      return Recipe(
        recipeId: recipeId,
        recipeName: recipeName,
        recipeGrade: recipeGrade,
        forHowManyPeople: forHowManyPeople,
        countInCart: countInCart,
        recipeMemo: recipeMemo,
        imageUrl: imageUrl,
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

    final recipeNameAndIngredientNameListStream =
        recipeCollection.snapshots().asBroadcastStream().map(
              (e) => e.docs.map((DocumentSnapshot document) {
                final data = document.data()! as Map<String, dynamic>;

                final recipeId = document.id;
                final recipeName = data['recipeName'] as String;
                // ingredient関連
                final ingredientListMap = Map<String, dynamic>.from(
                  data['ingredientList'] as Map<String, dynamic>,
                );
                final sortedIngredientListMap =
                    SplayTreeMap<String, dynamic>.from(
                  ingredientListMap,
                  (String key, String value) => key.compareTo(value),
                );
                final ingredientNameList = <String>[];
                sortedIngredientListMap.forEach((key, dynamic value) {
                  ingredientNameList.add(value['ingredientName'] as String);
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

    final recipeListStream =
        recipeCollection.snapshots().asBroadcastStream().map(
              (e) => e.docs.map((DocumentSnapshot document) {
                final data = document.data()! as Map<String, dynamic>;

                final recipeId = document.id;
                final recipeName = data['recipeName'] as String;
                final recipeGrade = data['recipeGrade'] as double?;
                final forHowManyPeople = data['forHowManyPeople'] as int?;
                final countInCart = data['countInCart'] as int?;
                final recipeMemo = data['recipeMemo'] as String?;
                final imageUrl = data['imageUrl'] as String?;

                return Recipe(
                  recipeId: recipeId,
                  recipeName: recipeName,
                  recipeGrade: recipeGrade,
                  forHowManyPeople: forHowManyPeople,
                  countInCart: countInCart,
                  recipeMemo: recipeMemo,
                  imageUrl: imageUrl,
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
    Map<String, Map<String, dynamic>>? procedureListMap,
  ) async {
    //レシピを保存
    final DocumentReference docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .add(<String, dynamic>{
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

  Future<void> addImage(File imageFile, String recipeId) async {
    final timestamp = DateTime.now().microsecondsSinceEpoch;

    final name = imageFile.path.split('/').last;
    final path = '${timestamp}_$name';
    final task = await FirebaseStorage.instance
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
  Future<void> updateRecipe(
    String originalRecipeId,
    Recipe recipe,
    Map<String, Map<String, dynamic>>? ingredientListMap,
    Map<String, Map<String, dynamic>>? procedureListMap,
  ) async {
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
