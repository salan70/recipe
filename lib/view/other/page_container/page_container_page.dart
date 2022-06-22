import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/view/cart/cart_list_page/cart_list_page.dart';
import 'package:recipe/view/other/page_container/page_container_model.dart';
import 'package:recipe/view/recipe/add_cart_recipe_list/add_cart_recipe_list_page.dart';
import 'package:recipe/view/recipe/add_recipe/add_recipe_page.dart';
import 'package:recipe/view/recipe/recipe_list/recipe_list_page.dart';
import 'package:recipe/view/recipe/search_recipe/search_recipe_page.dart';
import 'package:recipe/view/setting/setting_top/setting_top_page.dart';

class PageContainerPage extends ConsumerWidget {
  const PageContainerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPage = ref.watch(selectPageProvider);
    final selectedPageNotifier = ref.watch(selectPageProvider.notifier);

    final user = ref.watch(userStateNotifierProvider);

    final pages = [
      const RecipeListPage(),
      const CartListPage(),
    ];

    return Scaffold(
      body: HawkFabMenu(
        /// HawkFab関連
        icon: AnimatedIcons.list_view,
        fabColor: Theme.of(context).bottomAppBarColor,
        iconColor: Theme.of(context).primaryColorDark,
        items: [
          HawkFabMenuItem(
            color: Theme.of(context).bottomAppBarColor,
            label: 'カートの中身を変更',
            labelBackgroundColor: Theme.of(context).bottomAppBarColor,
            labelColor: Theme.of(context).primaryColorDark,
            ontap: () {
              Navigator.push<MaterialPageRoute<dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCartRecipeListPage(),
                ),
              );
            },
            icon: Icon(
              Icons.add_shopping_cart_rounded,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          HawkFabMenuItem(
            color: Theme.of(context).bottomAppBarColor,
            label: 'レシピを検索',
            labelBackgroundColor: Theme.of(context).bottomAppBarColor,
            labelColor: Theme.of(context).primaryColorDark,
            ontap: () {
              showCupertinoModalBottomSheet<SearchRecipePage>(
                expand: true,
                context: context,
                builder: (context) => const SearchRecipePage(),
              );
            },
            icon: Icon(
              Icons.search_rounded,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          HawkFabMenuItem(
            color: Theme.of(context).bottomAppBarColor,
            label: '設定',
            labelBackgroundColor: Theme.of(context).bottomAppBarColor,
            labelColor: Theme.of(context).primaryColorDark,
            ontap: () {
              Navigator.push<MaterialPageRoute<dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingTopPage(),
                ),
              );
            },
            icon: Icon(
              Icons.settings_rounded,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ],

        /// PersistentTabView関連
        body: pages[selectedPage],
      ),
      floatingActionButton: selectedPage == 0
          ? FloatingActionButton(
              child: Icon(
                Icons.edit_note_rounded,
                size: 32.0.sp,
              ),
              onPressed: () {
                if (selectedPage == 0) {
                  Navigator.push<MaterialPageRoute<dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddRecipePage(),
                      fullscreenDialog: true,
                    ),
                  );
                }
              },
            )
          : FloatingActionButton(
              child: Icon(
                Icons.post_add_rounded,
                size: 32.0.sp,
              ),
              onPressed: () async {
                await _addOtherCartItemDialog(context, user!);
              },
            ),
      // null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                Icons.menu_book_rounded,
                semanticLabel: 'レシピ',
                color: selectedPage == 0
                    ? Theme.of(context).primaryColor
                    : Colors.black,
              ),
              onPressed: () {
                selectedPageNotifier.state = 0;
              },
            ),
            IconButton(
              icon: Icon(
                Icons.shopping_cart_rounded,
                color: selectedPage == 1
                    ? Theme.of(context).primaryColor
                    : Colors.black,
              ),
              onPressed: () {
                selectedPageNotifier.state = 1;
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addOtherCartItemDialog(
    BuildContext context,
    User user,
  ) {
    final pageContainerModel = PageContainerModel(user: user);
    var title = '';
    var subTitle = '';

    return showDialog<AlertDialog>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('カートにアイテムを追加'),
          content: SizedBox(
            height: 160.h,
            width: 300.w,
            child: Column(
              children: [
                SizedBox(
                  height: 8.h,
                ),
                TextField(
                  autofocus: true,
                  maxLength: 20,
                  decoration: const InputDecoration(
                    labelText: 'タイトル (必須)',
                  ),
                  onChanged: (value) {
                    title = value;
                  },
                ),
                TextField(
                  maxLength: 20,
                  decoration: const InputDecoration(
                    labelText: '詳細',
                  ),
                  onChanged: (value) {
                    subTitle = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                await EasyLoading.show(status: 'loading...');
                if (title == '') {
                  await EasyLoading.showError(
                    'タイトルの入力は必須です。',
                  );
                } else {
                  final errorText = await pageContainerModel.addOtherCartItem(
                    title,
                    subTitle,
                  );
                  if (errorText == null) {
                    Navigator.of(context).pop();
                    await EasyLoading.showSuccess(
                      '$titleを追加しました',
                    );
                  } else {
                    await EasyLoading.showError(
                      errorText,
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
