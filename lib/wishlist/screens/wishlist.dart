import 'package:flutter/material.dart';
import 'package:literaloka/main/menu.dart';
import 'package:literaloka/widgets/left_drawer.dart';
import 'package:literaloka/wishlist/models/wishlist.dart';
import 'package:literaloka/wishlist/screens/wishlist_form.dart';
import 'package:literaloka/wishlist/widgets/wishlist_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class WishlistPage extends StatefulWidget {
  final CookieRequest request;

  const WishlistPage(this.request, {Key? key}) : super(key: key);

  @override
  _WishlistState createState() => _WishlistState(request);
}

class _WishlistState extends State<WishlistPage> {
  late Future<dynamic> wishlistItems;
  final CookieRequest request;

  _WishlistState(this.request);

  // void _addToWishlist(String bookTitle, String reason) {
  //   setState(() {
  //     wishlistItems.add(WishlistItem(bookTitle: bookTitle, reason: reason));
  //   });
  // }
  Future<dynamic> fetchProduct() async {
    final response =
        await request.get('http://127.0.0.1:8000/wishlist/get-wishlist/');

    List<Wishlist> listWishlist = [];

    for (var item in response['wishlist']) {
      listWishlist.add(Wishlist.fromJson(item));
    }

    return listWishlist;
  }

  @override
  void initState() {
    super.initState();
    wishlistItems = fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Book Wishlist'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyHomePage(),
                ),
              );
            },
          ),
        ),
        drawer: const LeftDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
           Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WishlistFormPage(request),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
        body: FutureBuilder(
            future: wishlistItems,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (!snapshot.hasData) {
                  return const Column(
                    children: [
                      Text(
                        "Tidak ada data produk.",
                        style:
                            TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (_, index) => WishlistCard(
                            bookImageUrl: snapshot.data![index].bookImageUrl,
                            bookCategory: snapshot.data![index].bookCategory,
                            bookTitle: snapshot.data![index].bookTitle,
                            reason: snapshot.data![index].reason,
                          ));
                }
              }
            }));
  }
}
