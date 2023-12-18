// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:literaloka/jual_buku/screens/buku_user.dart';
import 'package:literaloka/jual_buku/screens/katalog.dart';
import 'package:literaloka/main/login.dart';
import 'package:literaloka/resensi/screens/all_resensi.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class NavItem {
  final String name;
  final IconData icon;
  final Color color;

  NavItem(this.name, this.icon, this.color);
}

class NavCard extends StatelessWidget {
  final NavItem item;

  const NavCard(this.item, {super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Material(
      color: item.color,
      child: InkWell(
        onTap: () async {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!")));
          if (item.name == "Katalog") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KatalogPage(),
              ),
            );
          } 
          else if (item.name == "Buku User") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BukuUserPage(),
              ),
            );
          }
          else if (item.name == "Resensi Buku") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllResensiPage(),
              ),
            );
          } 
          else if (item.name == "Logout") {
            final response = await request.logout(
                "http://127.0.0.1:8000/auth/logout/"
              );
            String message = response["message"];
            if (response['status']) {
              String uname = response["username"];
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("$message Sampai jumpa, $uname."),
              ));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(message),
              ));
            }
          }
        },
        child: Container(
          // Container untuk menyimpan Icon dan Text
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}