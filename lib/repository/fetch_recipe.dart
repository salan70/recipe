import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:recipe/domain/recipe.dart';

class FetchRecipeRepository {
  FetchRecipeRepository(this.user);

  final User? user;

  Stream<List<Recipe>> fetchRecipeList(String uid) {
    final recipeCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('recipes');

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

  Stream<List<Ingredient>> fetchIngredientList(String uid, String recipeId) {
    final ingredientCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('recipes')
        .doc(recipeId)
        .collection('ingredient');

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

  Stream<List<Procedure>> fetchProcedureList(String uid, String recipeId) {
    final ingredientCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('recipes')
        .doc(recipeId)
        .collection('procedure');

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
}
