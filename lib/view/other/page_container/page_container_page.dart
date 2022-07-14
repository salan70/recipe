import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe/state/other_provider/providers.dart';
import 'package:recipe/view/buy_list/buy_list/buy_list_page.dart';
import 'package:recipe/view/cart/cart_list_page.dart';
import 'package:recipe/view/recipe/recipe_list/recipe_list_page.dart';

class PageContainerPage extends ConsumerWidget {
  const PageContainerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPage = ref.watch(selectPageProvider);
    final selectedPageNotifier = ref.watch(selectPageProvider.notifier);

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
