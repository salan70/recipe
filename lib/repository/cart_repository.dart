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

  /// fetch
  Stream<List<RecipeForInCartList>> fetchRecipeListInCart() {
    final recipeCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .where('countInCart', isGreaterThan: 0);

    final recipeStream = recipeCollection.snapshots().map(
          (e) => e.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            final String recipeId = document.id;
            final String recipeName = data['recipeName'];
            final int forHowManyPeople = data['forHowManyPeople'];
            final int? countInCart = data['countInCart'];

            return RecipeForInCartList(
                recipeId: recipeId,
                recipeName: recipeName,
                forHowManyPeople: forHowManyPeople,
                countInCart: countInCart);
          }).toList(),
        );

    return recipeStream;
  }

  /// add

  /// update
  Future<void> updateCount(String recipeId, int count) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes')
        .doc(recipeId)
        .update({
      'countInCart': count,
    });
  }
}
