// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:literaloka/jual_buku/screens/katalog.dart';
import 'package:literaloka/main/left_drawer.dart';
import 'package:literaloka/models/resensi.dart';
import 'package:literaloka/resensi/widget/resensi_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AllResensiPage extends StatefulWidget {
  const AllResensiPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AllResensiPageState createState() => _AllResensiPageState();
}

class _AllResensiPageState extends State<AllResensiPage> {
  Future<List<Resensi>> fetchAllResensi(request) async {
    var response =
        await request.get("http://10.0.2.2:8000/resensi/get_resensi/");

    List<Resensi> listAllResensi = [];
    for (var d in response) {
      if (d != null) {
        listAllResensi.add(Resensi.fromJson(d));
      }
    }
    return listAllResensi;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Resensi',
          textAlign: TextAlign.center,
          style: TextStyle(
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
                future: fetchAllResensi(request),
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
                        childAspectRatio: 2 / 1.5,
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
