import 'package:hive/hive.dart';
import 'package:recipe/domain/type_adapter/cart_item/cart_item.dart';

class CartItemRepository {
  Box<CartItem> getCartItems() {
    return CartItemBoxes.getCartItems();
  }

  Future<void> putIsInBuyList({
    required CartItem item,
    required bool isInBuyList,
  }) async {
    final cartItem = CartItem(
      id: item.id,
      isInBuyList: isInBuyList,
      isChecked: item.isChecked,
    );
    final box = getCartItems();
    await box.put(item.id, cartItem);
  }

  Future<void> putIsChecked({
    required CartItem item,
    required bool isChecked,
  }) async {
    final cartItem = CartItem(
      id: item.id,
      isInBuyList: item.isInBuyList,
      isChecked: isChecked,
    );
    final box = getCartItems();
    await box.put(item.id, cartItem);
  }

  CartItem fetchCartItem(String id) {
    final box = getCartItems();
    final getBox = box.get(
      id,
      defaultValue: CartItem(id: id, isInBuyList: true, isChecked: false),
    )!;
    return getBox;
  }

  Future<void> deleteBuyListItem(String id) async {
    final box = getCartItems();
    await box.delete(id);
  }

  Future<void> deleteAllCartItem() async {
    final box = getCartItems();
    await box.deleteFromDisk();
    await Hive.openBox<CartItem>('cartItems');
  }
}
