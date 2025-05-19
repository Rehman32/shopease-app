import 'package:flutter/material.dart';

class ProductImageCarousel extends StatelessWidget {
  final String imageUrl;
  const ProductImageCarousel({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      height: 300,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
