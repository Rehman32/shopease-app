import 'dart:convert';
import 'package:http/http.dart' as http;
// ignore_for_file: avoid_print

class EmailService {
  static const String baseUrl = 'http://10.0.2.2:5000'; // localhost for Android emulator
  // use 'http://localhost:5000' if you're testing in web

  static Future<void> sendOrderConfirmation({
    required String email,
    required String name,
    required String orderId,
  }) async {
    final url = Uri.parse('$baseUrl/order/placed');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'name': name,
          'orderId': orderId,
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Confirmation email sent');
      } else {
        print('❌ Failed to send confirmation email: ${response.body}');
      }
    } catch (e) {
      print('❌ Error sending email: $e');
    }
  }
}
