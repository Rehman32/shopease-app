import 'package:flutter/material.dart';
import '../../catalog/model/product_model.dart';

class ProductDetailInfo extends StatelessWidget {
  final Product product;
  const ProductDetailInfo({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 10),
          Text('\$${product.price}', style: const TextStyle(fontSize: 20, color: Colors.green)),
          const SizedBox(height: 20),
          Text(product.description),
        ],
      ),
    );
  }
}
