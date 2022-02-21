import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe/domain/recipe.dart';

class RecipeListNotifier extends StateNotifier<List<Recipe>> {
  RecipeListNotifier() : super([]);

  List<Recipe>? recipes;
}

class RecipeListModel extends ChangeNotifier {
  List<Ingredient>? ingredientList;
  List<Procedure>? procedureList;

  Stream<List<Recipe>> fetchRecipeList(String uid) {
    final recipeCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('recipes');

    // データ（Map型）を取得
    final recipeStream = recipeCollection.snapshots().map(
          // CollectionのデータからItemクラスを生成する
          (e) => e.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            final String recipeName = data['recipeName'];
            final double? recipeGrade = data['recipeGrade'];
            final int? forHowManyPeople = data['forHowManyPeople'];
            final String? recipeMemo = data['recipeMemo'];
            final String? imageUrl = data['imageUrl'];
            final File? imageFile = null;

            final String recipeId = document.id;
            print(document.reference.toString());
            print(recipeId);

            final ingredientCollection = FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .collection('recipes')
                .doc(recipeId)
                .collection('ingredient');

            print('ingredientCollection:');
            // print(document.get(ingredientCollection));

            // final Stream<List<Ingredient>> ingredientStream =
            //     fetchIngredientList(uid, recipeId);
            // print(ingredientStream);

            print(1.5);

            final procedureCollection =
                recipeCollection.doc(recipeId).collection('procedure');
            print(4);

            final Stream<QuerySnapshot> _proceduresStream =
                procedureCollection.snapshots();

            _proceduresStream.listen((QuerySnapshot snapshot) async {
              print('procedure1');

              final List<Procedure> procedureList =
                  snapshot.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                final String id = data['id'];
                final String content = data['content'];
                print('procedure2');
                print('====================');

                return Procedure(id, content);
              }).toList();
              this.procedureList = procedureList;
            });

            if (ingredientList == null) {
              print(ingredientList!.length);
            }
            print("nullです");

            return Recipe(
                recipeName: recipeName,
                recipeGrade: recipeGrade,
                forHowManyPeople: forHowManyPeople,
                recipeMemo: recipeMemo,
                imageUrl: imageUrl,
                imageFile: imageFile,
                ingredientList: ingredientList,
                procedureList: procedureList);
          }).toList(),
        );

    return recipeStream;
  }

  ///
  Future<List<Ingredient>?> getIngredientList(
      String uid, String recipeId) async {
    print('aaaaaaaaaaaa');
    final collection = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('recipes')
        .doc(recipeId)
        .collection('ingredient')
        .get();
    final ingredientList = collection.docs
        .map((doc) => Ingredient(
            id: doc['id'],
            name: doc['name'],
            amount: doc['amount'],
            unit: doc['unit']))
        .toList();
    return ingredientList;
  }

  Stream<List<Ingredient>> fetchIngredientList(String uid, String recipeId) {
    print("in fetchIngredientList");
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

            print("in fetchIngredientList2");
            final String id = data['id'];
            final String? name = data['name'];
            final String? amount = data['amount'];
            final String? unit = data['unit'];

            print('aaa:' + name.toString());
            return Ingredient(id: id, name: name, amount: amount, unit: unit);
          }).toList(),
        );

    return ingredientStream;
  }
}
