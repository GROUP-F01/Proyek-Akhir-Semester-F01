// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:literaloka/models/buku.dart';
import 'package:literaloka/models/resensi.dart';
import 'package:literaloka/resensi/screens/all_resensi.dart';
import 'package:literaloka/resensi/screens/edit_resensi.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ResensiCard extends StatelessWidget {
  final Resensi resensi;

  const ResensiCard(this.resensi, {super.key});

  Future<Buku> fetchBuku(request) async {
    var response = await request.postJson(
        "https://literaloka.my.id/resensi/get_book/",
        jsonEncode(<String, String>{
          'pk': resensi.fields.book.toString(),
        }));

    return Buku.fromJson(response.first);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 10.0,
      child: InkWell(
          onTap: () async {
            showResensi(context, request);
          },
          child: FutureBuilder<Buku>(
              future: fetchBuku(request),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: screenWidth * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              width: screenWidth * 0.3,
                              height: screenHeight * 0.25,
                              child: Image.network(
                                snapshot.data!.fields.imageUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )),
                          SizedBox(width: screenWidth * 0.05),
                          Container(
                            alignment: Alignment.center,
                            width: screenWidth * 0.5,
                            height: screenHeight * 0.25,
                            child: Column(children: [
                              Text(
                                snapshot.data!.fields.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "Published By: ${resensi.fields.publishedBy}",
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                resensi.fields.resensi.length > 300
                                    ? "${resensi.fields.resensi.substring(0, 300)}..."
                                    : resensi.fields.resensi,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10,
                                ),
                              ),
                            ]),
                          )
                        ],
                      ),
                    ),
                  );
                }
              })),
    );
  }

  void showResensi(BuildContext context, request) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: screenHeight * 0.8,
          width: screenWidth * 0.8,
          padding: const EdgeInsets.all(10),
          child: Card(
            child: Column(
              children: [
                PreferredSize(
                  preferredSize: Size.fromHeight(
                      screenHeight * 0.1), // Define the height of the AppBar
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(
                          10.0), // Define the radius for the top left corner
                      topRight: Radius.circular(
                          10.0), // Define the radius for the top right corner
                    ),
                    child: AppBar(
                      title: const Text("Resensi"),
                      // Other AppBar properties
                    ),
                  ),
                ),
                FutureBuilder<Buku>(
                    future: fetchBuku(request),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else {
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    width: screenWidth * 0.2,
                                    height: screenHeight * 0.2,
                                    child: Image.network(
                                      snapshot.data!.fields.imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    )),
                                SizedBox(height: screenHeight * 0.02),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    snapshot.data!.fields.title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Published By: ${resensi.fields.publishedBy}",
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Container(
                                  alignment: Alignment.center,
                                  width: screenWidth * 0.8,
                                  height: screenHeight * 0.4,
                                  child: SingleChildScrollView(
                                    child: Text(
                                      resensi.fields.resensi,
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditResensiPage(
                                                          snapshot.data!,
                                                          resensi)),
                                            );
                                          },
                                          child: const Text("Edit")),
                                    ),
                                    SizedBox(
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            final response = await request.postJson(
                                                "https://literaloka.my.id/resensi/delete_resensi/",
                                                jsonEncode(<String, String>{
                                                  'resensi_id':
                                                      resensi.pk.toString(),
                                                }));
                                            if (response['status'] == true) {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const AllResensiPage()),
                                              );
                                            }
                                          },
                                          child: const Text("Delete")),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }),
              ],
            ),
          ),
        );
      },
    );
  }
}
