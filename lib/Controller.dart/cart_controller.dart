import 'package:DIPSTORE/Model.dart/Productmodel.dart';
import 'package:DIPSTORE/Model.dart/cart_item.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final cartItems = <CartItem>[].obs;

  /// Adds a product to the cart. If already present, increases its quantity.
  CartItem addToCart(
    Product product, {
    int quantity = 1,
    String size = "M",
  }) {
    final qtyToAdd = quantity > 0 ? quantity : 1;

    final existingIndex = cartItems.indexWhere(
      (item) => item.matchesProduct(product),
    );

    if (existingIndex != -1) {
      final existingItem = cartItems[existingIndex];
      existingItem.quantity += qtyToAdd;
      existingItem.selected = true;
      cartItems.refresh();
      return existingItem;
    } else {
      final newItem = CartItem.fromProduct(
        product,
        quantity: qtyToAdd,
        size: size,
        selected: true,
      );
      cartItems.add(newItem);
      return newItem;
    }
  }

  /// Increments quantity for a cart item
  void incrementQuantity(CartItem item) {
    item.quantity++;
    cartItems.refresh();
  }

  /// Decrements quantity for a cart item, preventing it from dropping below 1
  void decrementQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      cartItems.refresh();
    }
  }

  /// Completely removes a specific CartItem
  void removeFromCart(CartItem item) {
    cartItems.remove(item);
  }

  /// Completely removes an item by its Product reference
  void removeProduct(Product product) {
    cartItems.removeWhere((item) => item.matchesProduct(product));
  }

  /// Toggles selected state for a specific item
  void toggleItemSelected(CartItem item, bool selected) {
    item.selected = selected;
    cartItems.refresh();
  }

  /// Toggles selected state for all items in the cart
  void toggleSelectAll(bool selected) {
    for (final item in cartItems) {
      item.selected = selected;
    }
    cartItems.refresh();
  }

  /// Empties the entire cart
  void clearCart() {
    cartItems.clear();
  }

  /// Subtotal of all currently selected cart items
  double get subtotal => cartItems
      .where((item) => item.selected)
      .fold(0.0, (sum, item) => sum + item.lineTotal);

  /// Total value of all items in cart regardless of selection
  double get totalAllItems =>
      cartItems.fold(0.0, (sum, item) => sum + item.lineTotal);

  /// Total number of items in the cart, counting quantities (e.g. 2 shirts + 1 jacket = 3)
  int get totalItemCount =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  /// Total number of selected items, counting quantities
  int get selectedItemCount => cartItems
      .where((item) => item.selected)
      .fold(0, (sum, item) => sum + item.quantity);

  /// Whether all items in the cart are selected
  bool get isAllSelected =>
      cartItems.isNotEmpty && cartItems.every((item) => item.selected);

  bool get isEmpty => cartItems.isEmpty;
  bool get isNotEmpty => cartItems.isNotEmpty;
}
