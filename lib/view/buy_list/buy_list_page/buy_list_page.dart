import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/view/buy_list/buy_list_page/ingredient_tab/ingredient_tab_widget.dart';

class BuyListPage extends ConsumerWidget {
  const BuyListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'カート',
        ),
      ),
      body: const IngredientTabWidget(),
    );
  }
}
