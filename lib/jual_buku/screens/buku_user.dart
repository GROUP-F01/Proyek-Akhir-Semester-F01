// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:literaloka/jual_buku/screens/tambahbuku_form.dart';
import 'package:literaloka/jual_buku/screens/katalog.dart';
import 'package:literaloka/jual_buku/screens/updatebuku_form.dart';
import 'package:literaloka/main/left_drawer.dart';
import 'package:literaloka/models/buku.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class JualBukuPage extends StatefulWidget {
  const JualBukuPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _JualBukuPageState createState() => _JualBukuPageState();
}

class _JualBukuPageState extends State<JualBukuPage> {
  Future<List<Buku>> fetchBukuUser(request) async {
    var response =
        await request.get("http://127.0.0.1:8000/jualbuku/show_buku_flutter/");

    List<Buku> listBukuUser = [];
    for (var d in response) {
      if (d != null) {
        listBukuUser.add(Buku.fromJson(d));
      }
    }
    return listBukuUser;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jual Buku',
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: width * 0.05),
            SizedBox(
              width: width,
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TambahBukuFormPage()),
                  );
                },
                child: const Text(
                  "Add New Book",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: width * 0.02),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder<List<Buku>>(
                future: fetchBukuUser(request),
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
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1 / 2,
                      ),
                      primary: false,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return cardBuku(
                            context, request, snapshot.data![index]);
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

  Card cardBuku(BuildContext context, request, Buku buku) {
    double width = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 10.0,
      child: InkWell(
        onTap: () async {
          modalBuku(context, request, buku);
        },
        child: Container(
          height: screenHeight * 0.3,
          width: width * 0.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, left: 8.0, right: 8.0, bottom: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      buku.fields.imageUrl,
                      fit: BoxFit.cover,
                      height: screenHeight * 0.3,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        buku.fields.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        buku.fields.author,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void modalBuku(BuildContext context, request, Buku buku) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppBar(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  automaticallyImplyLeading: false,
                  title: const Text(
                    "Detail Buku",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  width: width * 0.2,
                  height: height * 0.3,
                  child: Image.network(
                    buku.fields.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 10),
                Text(buku.fields.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text("ISBN: ${buku.fields.isbn}"),
                Text("Author: ${buku.fields.author}"),
                Text("Category: ${buku.fields.category}"),
                Text("Price: ${buku.fields.price.toString()}"),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: width * 0.6,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            child: const Text(
                              'Update Book',
                              style: TextStyle(
                                fontSize: 10, // Font size
                                fontWeight: FontWeight.bold, // Font weight
                              ),
                            ),
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateBukuFormPage(buku)),
                              );
                            })),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: width * 0.6,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            child: const Text(
                              'Delete Book',
                              style: TextStyle(
                                fontSize: 10, // Font size
                                fontWeight: FontWeight.bold, // Font weight
                              ),
                            ),
                            onPressed: () async {
                              await request.postJson(
                                  "http://127.0.0.1:8000/jualbuku/delete_buku_flutter/",
                                  jsonEncode(<String, String>{
                                    'pk': buku.pk.toString(),
                                  }));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const JualBukuPage()),
                              );
                            })),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
