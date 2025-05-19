//checkout_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../cart/models/cart_item.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false; // To show a loading indicator

  Future<void> _submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true; // Start loading
    });

    final cart = ref.read(cartProvider);
    final total = ref.read(cartProvider.notifier).totalPrice;
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _isLoading = false; // Stop loading
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You must be logged in to place an order.")),
        );
      }
      return;
    }

    final userToken = await FirebaseMessaging.instance.getToken(); // 🔥 Get user's FCM token

    final order = {
      'userId': user.uid,
      'userToken': userToken, // ✅ Save token
      'items': cart.map((CartItem item) => {
        'id': item.product.id,
        'title': item.product.title,
        'price': item.product.price,
        'quantity': item.quantity,
        'image': item.product.image,
      }).toList(),
      'total': total,
      'status': 'pending',
      'createdAt': Timestamp.now(),
      'deliveryInfo': {
        'name': _nameController.text,
        'address': _addressController.text,
        'phone': _phoneController.text,
      }
    };



    try {
      await FirebaseFirestore.instance.collection('orders').add(order);
      ref.read(cartProvider.notifier).clearCart();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order placed successfully")),
        );
        // Introduce a small delay before navigation
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.popUntil(context, ModalRoute.withName('/home'));
          }
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to place order: $error")),
        );
      }
    } finally {
      setState(() {
        _isLoading = false; // Stop loading regardless of success or failure
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Delivery Information", style: TextStyle(fontSize: 18)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (val) => val == null || val.isEmpty ? "Enter name" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Address"),
                validator: (val) => val == null || val.isEmpty ? "Enter address" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                validator: (val) => val == null || val.length < 7 ? "Enter valid phone" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitOrder, // Disable button while loading
                child: _isLoading
                    ? const CircularProgressIndicator() // Show loading indicator
                    : const Text("Place Order"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}