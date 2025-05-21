import 'package:flutter/material.dart';
import '../../admin/admin_orders_screen.dart';
import '../../cart/screens/cart_screen.dart';
import '../../orders/screens/order_tracking_screen.dart';
import '../../auth/screens/login_screen.dart'; // Import login screen for logout functionality
import 'catalog_screen.dart';
// ignore_for_file: avoid_print

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    CatalogScreen(),
    CartScreen(),
    OrderTrackingScreen(),
    AdminOrdersScreen(), // Replaced Profile with Admin Orders
  ];

  final List<String> _titles = [
    'ShopEase',
    'My Cart',
    'My Orders',
    'Admin',     // Updated title
  ];

  final List<IconData> _icons = [
    Icons.storefront,
    Icons.shopping_cart,
    Icons.local_shipping,
    Icons.admin_panel_settings, // Updated icon
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: Colors.black87,
        type: BottomNavigationBarType.fixed,
        items: [
          for (int i = 0; i < _titles.length; i++)
            BottomNavigationBarItem(
              icon: Icon(_icons[i]),
              label: _titles[i],
            ),
        ],
      ),
    );
  }
}