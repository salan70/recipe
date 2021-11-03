import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:photoapp/photo.dart';
// import 'package:photoapp/photo_repository.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

// 11/3 一旦コメントアウト
// // ref.watch() を使うことで他Providerのデータを取得できる
// final recipeListProvider = StreamProvider.autoDispose((ref) {
//   final User? user = ref.watch(userProvider).data?.value;
//   return user == null
//       ? Stream.value(<Recipe>[])
//       : RecipeRepository(user).getRecipeList();
// });
//
// final photoListIndexProvider = StateProvider.autoDispose((ref) {
//   return 0;
// });
//
// final photoViewInitialIndexProvider = ScopedProvider<int>(null);
