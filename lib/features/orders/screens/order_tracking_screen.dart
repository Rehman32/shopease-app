import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderTrackingScreen extends ConsumerWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text("Please log in to view your orders."));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text("No orders yet."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final order = docs[index];
              final data = order.data() as Map<String, dynamic>;
              final createdAt = (data['createdAt'] as Timestamp).toDate();
              final items = data['items'] as List<dynamic>;
              final status = data['status'] ?? 'pending';
              final statusIndex = _statusToIndex(status);

              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("🧾 Order #${order.id.substring(0, 6)}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      ...items.map((item) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Image.network(item['image'], width: 40, height: 40),
                          title: Text(item['title'], maxLines: 1, overflow: TextOverflow.ellipsis),
                          subtitle: Text("Quantity: ${item['quantity']}"),
                          trailing: Text("₹${item['price']}"),
                        );
                      }),
                      const Divider(),
                      _buildStatusTracker(statusIndex),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Status: $status", style: const TextStyle(color: Colors.teal)),
                          Text(
                            "${createdAt.day}/${createdAt.month}/${createdAt.year} ${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text("Total: ₹${data['total']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusTracker(int currentIndex) {
    const stages = ['Pending', 'Processing', 'Shipped', 'Delivered'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(stages.length, (index) {
        final isDone = index <= currentIndex;
        return Column(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: isDone ? Colors.teal : Colors.grey[300],
              child: Icon(Icons.check, size: 14, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(stages[index], style: TextStyle(fontSize: 10, color: isDone ? Colors.teal : Colors.grey)),
          ],
        );
      }),
    );
  }

  int _statusToIndex(String status) {
    switch (status) {
      case 'processing':
        return 1;
      case 'shipped':
        return 2;
      case 'delivered':
        return 3;
      default:
        return 0; // pending
    }
  }
}
