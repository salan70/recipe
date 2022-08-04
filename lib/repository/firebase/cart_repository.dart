import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe/domain/buy_list.dart';
import 'package:recipe/domain/recipe.dart';
import 'package:uuid/uuid.dart';

class CartRepository {
  CartRepository({required this.user, this.recipe});

  final User user;
  final Recipe? recipe;

  /// fetch
  Stream<List<RecipeInCart>> fetchRecipeListInCart() {
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
            final imageUrl = data['imageUrl'] as String?;
            final forHowManyPeople = data['forHowManyPeople'] as int;
            final countInCart = data['countInCart'] as int?;
            // ingredient関連
            final ingredientListMap = Map<String, dynamic>.from(
              data['ingredientList'] as Map<String, dynamic>,
            );

            final ingredientList = <Ingredient>[];
            ingredientListMap.forEach((key, dynamic value) {
              value as Map<String, dynamic>;
              ingredientList.add(
                Ingredient(
                  id: const Uuid().v4(),
                  symbol: value['ingredientSymbol'] as String?,
                  name: value['ingredientName'] as String,
                  amount: value['ingredientAmount'] as String,
                  unit: value['ingredientUnit'] as String,
                ),
              );
            });

            return RecipeInCart(
              recipeId: recipeId,
              recipeName: recipeName,
              imageUrl: imageUrl,
              forHowManyPeople: forHowManyPeople,
              countInCart: countInCart,
              ingredientList: ingredientList,
            );
          }).toList(),
        );

    return recipeStream;
  }

  Stream<List<OtherBuyListItem>> fetchOtherBuyListItemList() {
    final otherCartItemCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('otherCartItems')
        .orderBy('createdAt');

    final otherBuyListItemList =
        otherCartItemCollection.snapshots().asBroadcastStream().map(
              (e) => e.docs.map((DocumentSnapshot document) {
                final data = document.data()! as Map<String, dynamic>;

                final itemId = document.id;
                final title = data['title'] as String;
                final subTitle = data['subTitle'] as String;

                return OtherBuyListItem(
                  itemId: itemId,
                  title: title,
                  subTitle: subTitle,
                );
              }).toList(),
            );

    return otherBuyListItemList;
  }

  /// update
  Future<String?> updateCount(String recipeId, int count) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('recipes')
          .doc(recipeId)
          .update({
        'countInCart': count,
      });
      return null;
    } on Exception catch (e) {
      return e.toString();
    }
  }

  /// add
  Future<void> addOtherCartItem(OtherBuyListItem otherCartItem) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('otherCartItems')
        .add(<String, dynamic>{
      'createdAt': DateTime.now(),
      'title': otherCartItem.title,
      'subTitle': otherCartItem.subTitle,
    });
  }

  /// delete
  Future<void> deleteOtherCartItem(String itemId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('otherCartItems')
        .doc(itemId)
        .delete();
  }
}
