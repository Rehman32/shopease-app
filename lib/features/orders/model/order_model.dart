// order_model.dart

import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Import Firestore for DocumentSnapshot and Timestamp

class OrderModel {
  final String id;
  final double total;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return OrderModel(
      id: doc.id,
      total: (data['total'] as num).toDouble(),
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

}
