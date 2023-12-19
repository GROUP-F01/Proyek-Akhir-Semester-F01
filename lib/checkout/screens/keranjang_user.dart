// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:literaloka/checkout/widgets/checkout.dart';
import 'package:literaloka/jual_buku/screens/katalog.dart';
import 'package:literaloka/widgets/left_drawer.dart';
import 'package:literaloka/models/beli_buku.dart';
import 'package:literaloka/models/buku.dart';
import 'package:literaloka/models/keranjang.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class KeranjangUserPage extends StatefulWidget {
  const KeranjangUserPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _KeranjangUserPageState createState() => _KeranjangUserPageState();
}

class _KeranjangUserPageState extends State<KeranjangUserPage> {
  late Future<Keranjang> keranjang;

  Future<List<BeliBuku>> fetchKeranjangUser(request) async {
    var response = await request
        .get("https://literaloka.my.id/cart_checkout/show_keranjang/");

    List<BeliBuku> listBuku = [];
    for (var d in response) {
      if (d != null) {
        listBuku.add(BeliBuku.fromJson(d));
      }
    }
    return listBuku;
  }

  Future<Buku> fetchBuku(request, int pk) async {
    var response = await request.postJson(
        "https://literaloka.my.id/cart_checkout/ambil_buku/",
        jsonEncode(<String, String>{
          'pk': pk.toString(),
        }));

    return Buku.fromJson(response.first);
  }

  Future<Keranjang> fetchKeranjang(request) async {
    var response = await request.get(
      "https://literaloka.my.id/cart_checkout/list_keranjang/",
    );

    return Keranjang.fromJson(response.first);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    double width = MediaQuery.of(context).size.width;
    keranjang = fetchKeranjang(request);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Keranjang User',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        backgroundColor: const Color.fromRGBO(78,217,148,1),
        foregroundColor: Colors.black,
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: width * 0.05),
            SizedBox(
              width: 200.0,
              child: ElevatedButton(
                onPressed: () async {
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return const CheckoutDialog();
                    },
                  );
                },
                child: const Text("Checkout"),
              ),
            ),
            SizedBox(height: width * 0.02),
            FutureBuilder<Keranjang>(
              future: keranjang,
              builder: (BuildContext context, AsyncSnapshot<Keranjang> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Display a loading indicator while waiting for the future to complete
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // Handle the error case
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  // Handle the case when there's no data
                  return const Text('No data available');
                } else {
                  // When data is available, display the total price
                  return Text('Total Harga: ${snapshot.data!.fields.harga.toString()}');
                }
              },
            ),
            SizedBox(height: width * 0.02),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FutureBuilder<List<BeliBuku>>(
                future: fetchKeranjangUser(request),
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
                        return cardBeliBuku(
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

  Card cardBeliBuku(BuildContext context, request, BeliBuku beli) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 10.0,
      child: FutureBuilder<Buku>(
          future: fetchBuku(request, beli.fields.buku),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return InkWell(
                  onTap: () async {
                    showDetail(context, request, snapshot.data!);
                  },
                  child: Padding(
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
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Container(
                                      height: screenHeight * 0.20,
                                      alignment: Alignment.center,
                                      child: Text(
                                        snapshot.data!.fields.title.length > 40
                                            ? "${snapshot.data!.fields.title.substring(0, 40)}..."
                                            : snapshot.data!.fields.title,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            final response = await request.postJson(
                                                "https://literaloka.my.id/cart_checkout/delete_buku/",
                                                jsonEncode(<String, String>{
                                                  'beli_id': beli.pk.toString(),
                                                }));
                                            if (response['status'] == true) {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const KeranjangUserPage()),
                                              );
                                            }
                                          },
                                          child: const Icon(Icons.delete),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                        width: 20,
                                        child:
                                            Text(beli.fields.jumlah.toString()),
                                      ),
                                      SizedBox(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            final response = await request.postJson(
                                                "https://literaloka.my.id/cart_checkout/tambah_keranjang/",
                                                jsonEncode(<String, String>{
                                                  'pk': snapshot.data!.pk
                                                      .toString(),
                                                }));
                                            if (response['status'] == true) {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const KeranjangUserPage()),
                                              );
                                            }
                                          },
                                          child: const Icon(Icons.add),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                          )
                        ],
                      ),
                    ),
                  ));
            }
          }),
    );
  }

  void showDetail(BuildContext context, request, Buku buku) {
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
                      title: const Text("Detail Buku"),
                      // Other AppBar properties
                    ),
                  ),
                ),
                FutureBuilder<Buku>(
                    future: fetchBuku(request, buku.pk),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else {
                        return Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                    "Written By: ${snapshot.data!.fields.author}",
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "ISBN: ${snapshot.data!.fields.isbn}",
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Publication Date: ${snapshot.data!.fields.publicationDate}",
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Category: ${snapshot.data!.fields.category}",
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Container(
                                  alignment: Alignment.topCenter,
                                  width: screenWidth * 0.8,
                                  height: screenHeight * 0.4,
                                  child: SingleChildScrollView(
                                    child: Text(
                                      snapshot.data!.fields.description,
                                      textAlign: TextAlign.justify,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
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
