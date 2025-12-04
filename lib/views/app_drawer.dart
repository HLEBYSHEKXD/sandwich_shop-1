import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.fastfood, size: 48, color: Colors.white),
                SizedBox(height: 8),
                Text('Sandwich Shop', style: TextStyle(color: Colors.white, fontSize: 24)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Cart'),
            onTap: () {
              Navigator.of(context).pushNamed('/cart');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Us'),
            onTap: () {
              Navigator.of(context).pushNamed('/about');
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile / Sign-In'),
            onTap: () {
              Navigator.of(context).pushNamed('/profile');
            },
          ),
        ],
      ),
    );
  }
}
