// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literaloka/jual_buku/screens/katalog.dart';
import 'package:literaloka/main/left_drawer.dart';
import 'package:literaloka/models/buku.dart';
import 'package:literaloka/models/resensi.dart';
import 'package:literaloka/resensi/widget/resensi_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class BookResensiPage extends StatefulWidget {
  final Buku buku;
  const BookResensiPage(this.buku, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BookResensiPageState createState() => _BookResensiPageState();
}

class _BookResensiPageState extends State<BookResensiPage> {
  Future<List<Resensi>> fetchBookResensi(request) async {
    var response = await request.postJson(
        "http://127.0.0.1:8000/resensi/resensi_buku/",
        jsonEncode(<String, String>{
          'pk': widget.buku.pk.toString(),
        }));

    List<Resensi> listBookResensi = [];
    for (var d in response) {
      if (d != null) {
        listBookResensi.add(Resensi.fromJson(d));
      }
    }
    return listBookResensi;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resensi ${widget.buku.fields.title.length > 30 ? "${widget.buku.fields.title.substring(0, 30)}..." : widget.buku.fields.title}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 52, 235, 146),
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: width * 0.05),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder<List<Resensi>>(
                future: fetchBookResensi(request),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (!snapshot.hasData ||
                      snapshot.data!.isEmpty ||
                      snapshot.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: width,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const KatalogPage(),
                                  ));
                            },
                            child: const Text(
                              'Balik ke Katalog',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2 / 1,
                      ),
                      primary: false,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ResensiCard(snapshot.data![index]);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
