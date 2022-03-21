import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:recipe/domain/recipe.dart';
import 'package:recipe/domain/cart.dart';

class CartRepository {
  CartRepository({required this.user, this.recipe});

  final User user;
  final Recipe? recipe;

  /// delete
  Future deleteRecipeInCart(String recipeId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .doc(recipeId)
        .update({
      'countInCart': 0,
    });
  }

  /// fetch
  Stream<List<InCartRecipe>> fetchRecipeRefList() {
    final recipeCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .orderBy('addedAt');

    final recipeStream = recipeCollection.snapshots().map(
          (e) => e.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            final String inCartRecipeId = document.id;
            final String recipeId = data['recipeId'];
            final DocumentReference recipeRef = data['recipeRef'];
            final int? count = data['count'];

            return InCartRecipe(
                inCartRecipeId: inCartRecipeId,
                recipeId: recipeId,
                recipeRef: recipeRef,
                count: count);
          }).toList(),
        );

    return recipeStream;
  }

  Stream<Recipe> fetchRecipe(String recipeId) {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .doc(recipeId);

    final recipeStream = docRef.snapshots().map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

      final String recipeName = data['recipeName'];
      final int? forHowManyPeople = data['forHowManyPeople'];
      final String? imageUrl = data['imageUrl'];

      return Recipe(
        recipeName: recipeName,
        forHowManyPeople: forHowManyPeople,
        imageUrl: imageUrl,
      );
    });

    return recipeStream;
  }

  Stream<int> fetchCount(String inCartRecipeId) {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(inCartRecipeId);

    final countStream = docRef.snapshots().map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

      final int count = data['count'];

      return count;
    });

    return countStream;
  }

  /// add
  Future<void> addRecipeInCart(int count, String recipeId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .doc(recipeId)
        .update({'countInCart': count});
  }

  /// update
  Future<void> updateRecipe(int count, String recipeId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .doc(recipeId)
        .update({
      'countInCart': count,
    });
  }

  /// search
  bool searchRecipe(String recipeId) {
    bool isExist = false;

    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart')
          .where('recipeId', isEqualTo: recipeId)
          .get();
      isExist = true;
    } catch (e) {
      print(e);
    }

    return isExist;
  }
}
