import 'package:flutter/material.dart';
import 'package:literaloka/checkout/screens/keranjang_user.dart';
import 'package:literaloka/jual_buku/screens/buku_user.dart';
import 'package:literaloka/jual_buku/screens/katalog.dart';
import 'package:literaloka/main/menu.dart';
import 'package:literaloka/resensi/screens/all_resensi.dart';
import 'package:literaloka/review/screens/review.dart';
import 'package:literaloka/user/login.dart';
import 'package:literaloka/wishlist/wishlist.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(78,217,148,1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'LiteraLoka',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart_rounded),
            title: const Text('Katalog'),
            onTap: () {
              if (request.loggedIn) {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const KatalogPage(),
                ),
              );
              } else {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Wishlist'),
            onTap: () {
              if (request.loggedIn) {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WishlistPage(),
                ),
              );
              } else {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart_rounded),
            title: const Text('Keranjang'),
            onTap: () {
              if (request.loggedIn) {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const KeranjangUserPage(),
                ),
              );
              } else {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.book_rounded),
            title: const Text('Buku User'),
            onTap: () {
              if (request.loggedIn) {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BukuUserPage(),
                ),
              );
              } else {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
              }
              
            },
          ),
          ListTile(
            leading: const Icon(Icons.rate_review_outlined),
            title: const Text('Review Page'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReviewPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.reviews),
            title: const Text('Resensi Buku'),
            onTap: () {
              if (request.loggedIn) {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllResensiPage(),
                ),
              );
              } else {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );
              }
            },
          ),
          if (request.loggedIn) ...[
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                final response = await request.logout(
                  "https://literaloka.my.id/auth/logout/",
                );
                String message = response["message"];
                if (response['status']) {
                  String uname = response["username"];
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("$message Sampai jumpa, $uname."),
                  ));
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                  );
                }
              },
            ),
          ] else ...[
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
