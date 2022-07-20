import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchRecipeHistoryWidget extends ConsumerWidget {
  const SearchRecipeHistoryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Theme.of(context).backgroundColor,
    );
  }
}
