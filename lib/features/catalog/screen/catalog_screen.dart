import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controller/product_controller.dart';
import '../controller/filter_controller.dart';
import '../widgets/product_tile.dart';
import '../widgets/search_bar.dart';
import '../widgets/filter_drawer.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProducts = ref.watch(filteredProductsProvider);
    final isLoading = ref.watch(productControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(productControllerProvider.notifier).loadProducts(),
            tooltip: 'Refresh Products',
          )
        ],
      ),
      drawer: const FilterDrawer(), // Keeping the filter drawer
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SearchBarWidget(),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.filter_list),
        tooltip: 'Filter Products',
      ),
    );
  }
}