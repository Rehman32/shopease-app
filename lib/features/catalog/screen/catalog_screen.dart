import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/product_controller.dart';
import '../controller/filter_controller.dart';
import '../model/product_model.dart';
import '../widgets/product_tile.dart';
import '../widgets/search_bar.dart';
import '../widgets/filter_drawer.dart';
import '../../cart/controllers/cart_controller.dart'; // Import your cart controller

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProducts = ref.watch(filteredProductsProvider);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(productControllerProvider.notifier).loadProducts(),
          )
        ],
      ),
      drawer: const FilterDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SearchBarWidget(),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(productControllerProvider.notifier).loadProducts();
              },
              child: filteredProducts.isEmpty
                  ? const Center(child: Text('No products match your filters.'))
                  : GridView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filteredProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ProductTile(product: product);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

