import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import '../../catalog/model/product_model.dart';
import '../widgets/product_detail_info.dart';
import '../widgets/product_image_carousel.dart';
import '../../cart/controllers/cart_controller.dart'; // Import your cart controller

class ProductDetailScreen extends ConsumerWidget { // Use ConsumerWidget
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Add WidgetRef
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageCarousel(imageUrl: product.image),
            ProductDetailInfo(product: product),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.shopping_cart),
          label: const Text("Add to Cart"),
          onPressed: () {
            ref.read(cartProvider.notifier).addToCart(product); // Use ref.read
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added to cart')),
            );
          },
        ),
      ),
    );
  }
}
