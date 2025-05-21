// lib/admin/admin_orders_screen.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'admin_order_details_screen.dart';

class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  Future<bool> checkAdmin() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.exists && doc.data()?['isAdmin'] == true;
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
      'status': newStatus,
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkAdmin(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.data!) {
          return const Scaffold(body: Center(child: Text("Access denied. Admins only.")));
        }

        return Scaffold(
          appBar: AppBar(title: const Text("Admin Orders")),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('orders').orderBy('createdAt', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final orders = snapshot.data?.docs ?? [];

              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final data = order.data() as Map<String, dynamic>;
                  final delivery = data['deliveryInfo'];
                  final status = data['status'] ?? 'pending';

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AdminOrderDetailsScreen(order: order),
                          ),
                        );
                      },
                      title: Text("Name: ${delivery['name']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Address: ${delivery['address']}"),
                          Text("Phone: ${delivery['phone']}"),
                          Text("Status: $status"),
                          Text("Total: \$${data['total'].toString()}"),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (val) => updateOrderStatus(order.id, val),
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'shipped', child: Text("Mark as Shipped")),
                          const PopupMenuItem(value: 'delivered', child: Text("Mark as Delivered")),
                          const PopupMenuItem(value: 'cancelled', child: Text("Cancel Order")),
                        ],
                        child: const Icon(Icons.more_vert),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}