import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../../catalog/model/product_model.dart';

final cartProvider = StateNotifierProvider<CartController, List<CartItem>>(
      (ref) => CartController(),
);

class CartController extends StateNotifier<List<CartItem>> {
  CartController() : super([]);

  void addToCart(Product product) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      state[index].quantity += 1;
      state = [...state]; // Trigger UI update
    } else {
      state = [...state, CartItem(product: product)];
    }
  }

  void removeFromCart(Product product) {
    state = state.where((item) => item.product.id != product.id).toList();
  }

  void updateQuantity(Product product, int quantity) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      state[index].quantity = quantity;
      state = [...state];
    }
  }

  void clearCart() {
    state = [];
  }

  double get totalPrice =>
      state.fold(0, (sum, item) => sum + item.total);

  int get totalItems =>
      state.fold(0, (sum, item) => sum + item.quantity);
}
