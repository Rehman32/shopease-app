// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/signup_screen.dart';
import 'features/cart/screens/cart_screen.dart';
import 'features/catalog/screen/catalog_screen.dart';
import 'features/catalog/screen/home_screen.dart';
import 'features/checkout/screens/checkout_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyA6vMcdzY95WNwsXMl1chR-qBTyVymqZqg",
      appId: "1:421408284826:android:66e49892de979077cf3f23",
      messagingSenderId: "421408284826",
      projectId: "fitconnect-58633",
    ),
  );

  runApp(const ProviderScope(child: ShopEaseApp()));
}

class ShopEaseApp extends StatelessWidget {
  const ShopEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShopEase',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const LoginScreen(),
      routes: {
        '/signup': (_) => const SignupScreen(),
        '/login': (_) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/cart': (_) => const CartScreen(),
        '/checkout': (_) => const CheckoutScreen(),

      },
    );
  }
}
