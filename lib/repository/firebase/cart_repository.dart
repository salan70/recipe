import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'package:recipe/domain/recipe.dart';
import 'package:recipe/domain/cart.dart';

class CartRepository {
  CartRepository({required this.user, this.recipe});

  final User user;
  final Recipe? recipe;

  /// fetch
  Stream<List<RecipeListInCart>> fetchRecipeListInCart() {
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

            return RecipeListInCart(
              recipeId: recipeId,
              recipeName: recipeName,
              forHowManyPeople: forHowManyPeople,
              countInCart: countInCart,
              ingredientList: ingredientList,
            );
          }).toList(),
        );

    return recipeStream;
  }

  /// update
  Future updateCount(String recipeId, int count) async {
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
