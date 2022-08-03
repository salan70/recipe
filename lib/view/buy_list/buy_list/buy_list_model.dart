import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe/domain/buy_list.dart';
import 'package:recipe/repository/firebase/cart_repository.dart';

class BuyListModel extends ChangeNotifier {
  BuyListModel({required this.user});
  final User user;

  Future<String?> addOtherCartItem(String title, String? subTitle) async {
    final cartRepository = CartRepository(user: user);
    final otherCartItem = OtherBuyListItem(
      itemId: null,
      createdAt: DateTime.now(),
      title: title,
      subTitle: subTitle,
    );

    try {
      await cartRepository.addOtherCartItem(otherCartItem);
      return null;
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
