// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literaloka/jual_buku/screens/katalog.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class CheckoutDialog extends StatefulWidget {
  const CheckoutDialog({super.key});

  @override
  State<StatefulWidget> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  final _formKey = GlobalKey<FormState>();
  String nama = "";
  String alamat = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return AlertDialog(
      title: const Text('Masukkan detail Checkout!'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  alignLabelWithHint: true,
                  hintText: "Masukkan nama penerima...",
                ),
                onChanged: (String? value) {
                  setState(() {
                    nama = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Nama tidak boleh kosong!";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Alamat',
                    alignLabelWithHint: true,
                    hintText: "Masukkan alamat penerima..."),
                onChanged: (String? value) {
                  setState(() {
                    alamat = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Alamat tidak boleh kosong!";
                  }
                  return null;
                },
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Checkout'),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final response = await request.postJson(
                  "http://10.0.2.2:8000/cart_checkout/checkout_keranjang/",
                  jsonEncode(<String, String>{
                    'nama': nama,
                    'alamat': alamat,
                  }));
              if (response['status'] == true) {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const KatalogPage()),
                );
              }
            }
          },
        ),
      ],
    );
  }
}
