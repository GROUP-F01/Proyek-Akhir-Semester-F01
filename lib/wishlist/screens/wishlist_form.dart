import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:literaloka/models/books.dart';
import 'package:literaloka/widgets/left_drawer.dart';
import 'package:literaloka/wishlist/screens/wishlist.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
class WishlistFormPage extends StatefulWidget {
  final CookieRequest request;

  const WishlistFormPage(this.request, {Key? key}) : super(key: key);

  @override
  State<WishlistFormPage> createState() => _WishlistFormPageState(request);
}

class _WishlistFormPageState extends State<WishlistFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _reason = "";
  int _dropdownValue = -1;
  List<Books> lb = [];
  final CookieRequest request;

  _WishlistFormPageState(this.request);

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    try {
      List<Books> books = await fetchProduct();
      setState(() {
        lb = books;
      });
    } catch (e) {
      // Handle error, e.g., show an error message
      print("Error loading books: $e");
    }
  }

  Future<List<Books>> fetchProduct() async {
    var url = Uri.parse('https://literaloka.my.id/get-buku/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Books> listProduct = [];
    for (var d in data) {
      if (d != null) {
        listProduct.add(Books.fromJson(d));
      }
    }
    return listProduct;
  }

  // List<DropdownMenuItem<int>> getDropdownBooks(List<Books> books) {
  //   List<DropdownMenuItem<int>> dropDownBooks = [];
  //   for (int i = 0; i < books.length; i++) {
  //     var newBook = DropdownMenuItem<int>(
  //         value: books[i].pk, child: Text(books[i].fields.title));
  //     dropDownBooks.add(newBook);
  //   }
  //   return dropDownBooks;
  // }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'LiteraLoka',
          ),
        ),
        backgroundColor: const Color.fromRGBO(78,217,148,1),
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WishlistPage(request),
              ),
            );
          },
        ),
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  'Add Wishlist',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FutureBuilder(
            future: fetchProduct(),
            builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
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
                // _dropdownValue = snapshot.data[0];
                return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Choose your Favorite Book:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<int>(
                        onChanged: (value) {
                          setState(() {
                            _dropdownValue = value!;
                          });
                        },
                        items: [DropdownMenuItem<int>(
                            child: Text('-'),
                            value: -1,
                          ), ...lb.map(
                          (book) => DropdownMenuItem<int>(
                            child: Text(book.fields.title),
                            value: book.pk,
                          ),
                        ).toList()],
                        value: _dropdownValue,
                        iconEnabledColor: Colors.blue,
                        isExpanded: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Reason:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Reason",
                          labelText: "Reason",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onChanged: (String? value) {
                          setState(() {
                            _reason = value!;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a reason';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ElevatedButton(
                        onPressed: () async {
                            if (inputIsValid()) {
                               final response = await request.postJson(
                                "https://literaloka.my.id/wishlist/add-wishlist-ajax/",
                                jsonEncode(<String, dynamic>{
                                    'book_id' : _dropdownValue,
                                    'reason' : _reason,
                                }));
                               Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => WishlistPage(request)),
                              );
                            }
                          },
                        child: const Text("Add to Wishlist"),
                      ),
                    ),
                  ],
                ),
              );
              }
              }
            }),
            ],
          ),
        ),
      ),
    );
  }

  bool inputIsValid() {
    return _dropdownValue != -1 && _reason.isNotEmpty ;
  }
}
  
