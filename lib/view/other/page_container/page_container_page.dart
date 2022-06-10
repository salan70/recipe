import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/view/cart/cart_list_page/cart_list_page.dart';
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
          :
          // FloatingActionButton(
          //         child: Icon(
          //           Icons.post_add_rounded,
          //           size: 32.0.sp,
          //         ),
          //         onPressed: () {
          //           if (selectedPage == 1) {
          //             Navigator.push<MaterialPageRoute<dynamic>>(
          //                 context,
          //                 MaterialPageRoute(
          //                   builder: (context) => AddRecipePage(),
          //                   fullscreenDialog: true,
          //                 ));
          //           }
          //         },
          //       ),
          null,
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
}
