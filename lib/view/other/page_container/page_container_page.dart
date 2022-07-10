import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:recipe/state/auth/auth_provider.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/view/buy_list/buy_list_page/buy_list_page.dart';
import 'package:recipe/view/cart/cart_list_page.dart';
import 'package:recipe/view/other/page_container/page_container_model.dart';
import 'package:recipe/view/recipe/add_cart_recipe_list/add_cart_recipe_list_page.dart';
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
      CartListPage(),
      const BuyListPage(),
    ];

    return Scaffold(
      body: pages[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPage,
        selectedFontSize: 12.sp,
        onTap: (int index) {
          selectedPageNotifier.state = index;
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu_book_rounded,
            ),
            label: 'レシピ',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart_rounded,
            ),
            label: 'カート',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_box_rounded,
            ),
            label: '買い物リスト',
          ),
        ],
      ),
    );
  }
}
