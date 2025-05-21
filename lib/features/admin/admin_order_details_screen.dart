// lib/admin/admin_order_details_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrderDetailsScreen extends StatelessWidget {
  final DocumentSnapshot order;

  const AdminOrderDetailsScreen({super.key, required this.order});

  Future<void> _updateStatus(BuildContext context, String newStatus) async {
    await FirebaseFirestore.instance.collection('orders').doc(order.id).update({
      'status': newStatus,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Order marked as $newStatus")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = order.data() as Map<String, dynamic>;
    final delivery = data['deliveryInfo'];
    final items = List<Map<String, dynamic>>.from(data['items']);
    final status = data['status'];

    return Scaffold(
      appBar: AppBar(title: const Text("Order Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text("Delivery Info", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text("Name: ${delivery['name']}"),
            Text("Address: ${delivery['address']}"),
            Text("Phone: ${delivery['phone']}"),
            const Divider(height: 32),

            const Text("Items", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...items.map((item) {
              return ListTile(
                leading: Image.network(item['image'], width: 50, height: 50, fit: BoxFit.cover),
                title: Text(item['title']),
                subtitle: Text("Qty: ${item['quantity']}"),
                trailing: Text("\$${(item['price'] * item['quantity']).toStringAsFixed(2)}"),
              );
            }).toList(),

            const Divider(height: 32),
            Text("Total: \$${data['total'].toStringAsFixed(2)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: status,
              decoration: const InputDecoration(labelText: "Order Status"),
              items: const [
                DropdownMenuItem(value: 'pending', child: Text("Pending")),
                DropdownMenuItem(value: 'shipped', child: Text("Shipped")),
                DropdownMenuItem(value: 'delivered', child: Text("Delivered")),
                DropdownMenuItem(value: 'cancelled', child: Text("Cancelled")),
              ],
              onChanged: (val) {
                if (val != null) {
                  _updateStatus(context, val);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
