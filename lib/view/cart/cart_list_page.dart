import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:recipe/domain/cart.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/view/cart/cart_list_model.dart';
import 'package:recipe/view/recipe/add_cart_recipe_detail/add_cart_recipe_detail_page.dart';
import 'package:recipe/view/setting/setting_top/setting_top_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CartListPage extends ConsumerWidget {
  CartListPage({Key? key}) : super(key: key);

  final PanelController pageController = PanelController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateNotifierProvider);
    final recipeListInCartStream = ref.watch(recipeListInCartProvider);

    final recipeListInCart = ref.watch(recipeListInCartNotifierProvider);
    final recipeListInCartNotifier =
        ref.watch(recipeListInCartNotifierProvider.notifier);

    final stateIsChanged = ref.watch(stateIsChangedProvider);
    final stateIsChangedNotifier = ref.watch(stateIsChangedProvider.notifier);

    final cartListModel = CartListModel(user: user!);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.settings_rounded,
          ),
          onPressed: () {
            pushNewScreen<dynamic>(
              context,
              screen: const SettingTopPage(),
              withNavBar: false,
            );
          },
        ),
        title: const Text(
          'カート',
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog<AlertDialog>(
                context: context,
                builder: (context) => ConfirmDeleteDialog(
                  recipeListInCart: recipeListInCart,
                ),
              );
            },
            icon: Icon(
              Icons.delete_rounded,
              color: Theme.of(context).errorColor,
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 240.h,
          )
        ],
      ),
    );
  }
}

class ConfirmDeleteDialog extends ConsumerWidget {
  const ConfirmDeleteDialog({Key? key, required this.recipeListInCart})
      : super(key: key);

  final List<RecipeInCart> recipeListInCart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateNotifierProvider);
    final cartListModel = CartListModel(user: user!);

    return AlertDialog(
      title: const Text('確認'),
      content: const Text('本当にカートを空にしてよろしいですか？'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('いいえ'),
        ),
        TextButton(
          onPressed: () async {
            await EasyLoading.show(status: 'loading...');
            final errorText = await cartListModel.deleteAllRecipeFromCart(
              recipeListInCart,
            );
            if (errorText == null) {
              Navigator.pop(context);
              await EasyLoading.showSuccess('カートを空にしました');
            } else {
              await EasyLoading.dismiss();
              await showDialog<AlertDialog>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('カート更新失敗'),
                    content: Text(errorText),
                    actions: [
                      TextButton(
                        child: const Text('閉じる'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: const Text('はい'),
        ),
      ],
    );
  }
}
