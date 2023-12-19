import 'package:flutter/material.dart';
import 'package:literaloka/checkout/screens/keranjang_user.dart';
import 'package:literaloka/jual_buku/screens/buku_user.dart';
import 'package:literaloka/jual_buku/screens/katalog.dart';
import 'package:literaloka/main/menu.dart';
import 'package:literaloka/resensi/screens/all_resensi.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.indigo,
            ),
            child: Column(
              children: [
                Text(
                  'Literaloka',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart_rounded),
            title: const Text('Katalog'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const KatalogPage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart_rounded),
            title: const Text('Keranjang'),
            // Bagian redirection ke MyHomePage
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const KeranjangUserPage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.book_rounded),
            title: const Text('Jual Buku'),
            // Bagian redirection ke ShopFormPage
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JualBukuPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.reviews),
            title: const Text('Resensi Buku'),
            // Bagian redirection ke ShopFormPage
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllResensiPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
