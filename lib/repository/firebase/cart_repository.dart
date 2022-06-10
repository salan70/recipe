import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe/domain/cart.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:uuid/uuid.dart';

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
            final data = document.data()! as Map<String, dynamic>;

            final recipeId = document.id;
            final recipeName = data['recipeName'] as String;
            final forHowManyPeople = data['forHowManyPeople'] as int;
            final countInCart = data['countInCart'] as int?;
            // ingredient関連
            final ingredientListMap = Map<String, dynamic>.from(
              data['ingredientList'] as Map<String, dynamic>,
            );

            final ingredientList = <Ingredient>[];
            ingredientListMap.forEach((key, dynamic value) {
              ingredientList.add(
                Ingredient(
                  id: const Uuid().v4(),
                  name: value['ingredientName'] as String,
                  amount: value['ingredientAmount'] as String,
                  unit: value['ingredientUnit'] as String,
                ),
              );
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
