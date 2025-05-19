import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;
  const OrderDetailScreen({required this.orderId, super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  String selectedStatus = 'pending';
  final List<String> statuses = ['pending', 'processing', 'shipped', 'delivered'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Detail")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('orders').doc(widget.orderId).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Order not found"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final items = data['items'] as List<dynamic>;
          selectedStatus = data['status'];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Delivery to: ${data['deliveryInfo']['name']} - ${data['deliveryInfo']['address']}"),
                const Divider(),
                Text("Items:", style: const TextStyle(fontWeight: FontWeight.bold)),
                ...items.map((item) => ListTile(
                  title: Text(item['title']),
                  subtitle: Text("Qty: ${item['quantity']}"),
                  trailing: Text("₹${item['price']}"),
                )),
                const Divider(),
                DropdownButton<String>(
                  value: selectedStatus,
                  items: statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (value) async {
                    if (value == null) return;
                    setState(() => selectedStatus = value);
                    await FirebaseFirestore.instance
                        .collection('orders')
                        .doc(widget.orderId)
                        .update({'status': value});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Order status updated to $value")),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
