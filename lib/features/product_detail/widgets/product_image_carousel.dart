import 'package:flutter/material.dart';

class ProductImageCarousel extends StatefulWidget {
  final String imageUrl;
  const ProductImageCarousel({super.key, required this.imageUrl});

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  bool _isLoading = true;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.teal.shade700,
                Colors.teal.shade500,
              ],
            ),
          ),
        ),

        // Main product image
        Container(
          height: 300,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: _hasError
              ? _buildErrorWidget()
              : Stack(
            alignment: Alignment.center,
            children: [
              // Show loading indicator while image loads
              if (_isLoading)
                const CircularProgressIndicator(
                  color: Colors.white,
                ),

              // Product image with fade transition
              Image.network(
                widget.imageUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    // Image has been loaded
                    _isLoading = false;
                    return AnimatedOpacity(
                      opacity: _isLoading ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 500),
                      child: child,
                    );
                  }
                  return const SizedBox();
                },
                errorBuilder: (context, error, stackTrace) {
                  setState(() {
                    _hasError = true;
                    _isLoading = false;
                  });
                  return _buildErrorWidget();
                },
              ),
            ],
          ),
        ),

        // Scrim gradient for better text visibility
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 100,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Bottom decoration curve
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Image not available',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}