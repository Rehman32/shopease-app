import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../controllers/cart_controller.dart';

class CartItemTile extends ConsumerWidget {
  final CartItem item;
  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Image.network(item.product.image, width: 50, height: 50),
      title: Text(item.product.title),
      subtitle: Text('\$${item.product.price.toStringAsFixed(2)} x ${item.quantity}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              if (item.quantity > 1) {
                ref.read(cartProvider.notifier).updateQuantity(item.product, item.quantity - 1);
              } else {
                ref.read(cartProvider.notifier).removeFromCart(item.product);
              }
            },
          ),
          Text('${item.quantity}'),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              ref.read(cartProvider.notifier).updateQuantity(item.product, item.quantity + 1);
            },
          ),
        ],
      ),
    );
  }
}
