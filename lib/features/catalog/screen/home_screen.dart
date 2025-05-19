//home_screen.dart
import 'package:flutter/material.dart';
import '../../cart/screens/cart_screen.dart';
import '../../orders/screens/order_tracking_screen.dart';
import 'catalog_screen.dart';
import 'profile_screen.dart';

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
    ProfileScreen(),
  ];

  final List<String> _titles = [
    'ShopEase',
    'My Cart',
    'My Orders',
    'Profile',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<IconData> _icons = [
    Icons.storefront,
    Icons.shopping_cart,
    Icons.local_shipping,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 10,
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
