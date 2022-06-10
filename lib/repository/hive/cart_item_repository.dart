import 'package:hive/hive.dart';
import 'package:recipe/domain/type_adapter/cart_item/cart_item.dart';

class CartItemRepository {
  Future<void> putIsNeed(CartItem item, bool isNeed) async {
    final cartItem =
        CartItem(id: item.id, isInBuyList: isNeed, isChecked: item.isChecked);
    final box = CartItemBoxes.getCartItems();
    await box.put(item.id, cartItem);
  }

  Future<void> putIsChecked(CartItem item, bool isChecked) async {
    final cartItem = CartItem(
      id: item.id,
      isInBuyList: item.isInBuyList,
      isChecked: isChecked,
    );
    final box = CartItemBoxes.getCartItems();
    await box.put(item.id, cartItem);
  }

  CartItem fetchItem(String id) {
    final box = CartItemBoxes.getCartItems();
    final getBox = box.get(
      id,
      defaultValue: CartItem(id: id, isInBuyList: true, isChecked: false),
    )!;
    return getBox;
  }

  Future<void> deleteAllCartItem() async {
    final box = CartItemBoxes.getCartItems();
    await box.deleteFromDisk();
    await Hive.openBox<CartItem>('cartItems');
  }
}
