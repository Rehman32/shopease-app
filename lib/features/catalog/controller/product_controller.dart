import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../model/product_model.dart';
import 'filter_controller.dart';

final productControllerProvider =
StateNotifierProvider<ProductController, AsyncValue<List<Product>>>(
      (ref) => ProductController(ref)..loadProducts(),
);

class ProductController extends StateNotifier<AsyncValue<List<Product>>> {
  final Ref ref;
  ProductController(this.ref) : super(const AsyncLoading());

  Future<void> loadProducts() async {
    try {
      state = const AsyncLoading();
      final res = await http.get(Uri.parse('https://fakestoreapi.com/products'));
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        final products = data.map((e) => Product.fromJson(e)).toList();
        state = AsyncData(products);
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

// 🔎 Filtered Products Provider
final filteredProductsProvider = Provider<List<Product>>((ref) {
  final search = ref.watch(searchQueryProvider).toLowerCase();
  final categories = ref.watch(selectedCategoriesProvider);
  final priceRange = ref.watch(priceRangeProvider);
  final products = ref.watch(productControllerProvider).maybeWhen(
    data: (p) => p,
    orElse: () => <Product>[], // Explicitly typed empty list
  );

  return products.where((product) {
    final inCategory = categories.isEmpty || categories.contains(product.category);
    final inPrice = product.price >= priceRange.start && product.price <= priceRange.end;
    final matchesSearch = product.title.toLowerCase().contains(search);
    return inCategory && inPrice && matchesSearch;
  }).toList();
});