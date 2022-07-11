import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchRecipeHistoryPage extends ConsumerWidget {
  const SearchRecipeHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Theme.of(context).backgroundColor,
    );
  }
}
