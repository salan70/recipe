import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteRecipeRepository {
  Future deleteRecipe(String uid, String recipeId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('recipes')
        .doc(recipeId)
        .delete();
  }
}
