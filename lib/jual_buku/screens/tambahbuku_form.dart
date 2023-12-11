// ignore_for_file: use_build_context_synchronously, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:literaloka/jual_buku/screens/buku_user.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class TambahBukuFormPage extends StatefulWidget {
  const TambahBukuFormPage({super.key});

  @override
  State<TambahBukuFormPage> createState() => _TambahBukuFormPageState();
}

class _TambahBukuFormPageState extends State<TambahBukuFormPage> {
  final _formKey = GlobalKey<FormState>();
  String isbn = "";
  String title = "";
  String description = "";
  String author = "";
  String publisher = "";
  String publicationDate = "";
  int pageCount = 0;
  String category = "";
  String imageUrl = "";
  String lang = "";
  int price = 0;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 52, 235, 146),
        foregroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Add New Book',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Book Title",
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              title = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Title tidak boleh kosong!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "ISBN",
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              isbn = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "ISBN tidak boleh kosong!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Author",
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              author = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Author tidak boleh kosong!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Description",
                            alignLabelWithHint: true,
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              description = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Description tidak boleh kosong!";
                            }
                            return null;
                          },
                          maxLines: 6,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Publisher",
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              publisher = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Publisher tidak boleh kosong!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Publication Date",
                            hintText: "Year-Month-Date(XXXX-XX-XX)",
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              publicationDate = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Publication Date tidak boleh kosong!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Category",
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              category = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Category tidak boleh kosong!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Image URL",
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              imageUrl = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Image URL tidak boleh kosong!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Page Count",
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              pageCount = int.parse(value!);
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Page Count tidak boleh kosong!";
                            }
                            if (int.tryParse(value) == null) {
                              return "Page Count harus berupa angka!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Language",
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              lang = value!;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Language tidak boleh kosong!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Price",
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              price = int.parse(value!);
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Price tidak boleh kosong!";
                            }
                            if (int.tryParse(value) == null) {
                              return "Price harus berupa angka!";
                            }
                            return null;
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              child: const Text(
                                'Add Book',
                                style: TextStyle(
                                  fontSize: 18, // Font size
                                  fontWeight: FontWeight.bold, // Font weight
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final response = await request.postJson(
                                      "http://127.0.0.1:8000/jualbuku/create_buku_flutter/",
                                      jsonEncode(<String, String>{
                                        'isbn': isbn,
                                        'title': title,
                                        'description': description,
                                        'author': author,
                                        'publisher': publisher,
                                        'publication_date': publicationDate,
                                        'page_count': pageCount.toString(),
                                        'category': category,
                                        'image_url': imageUrl,
                                        'lang': lang,
                                        'price': price.toString(),
                                      }));
                                  if (response['status'] == true) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const BukuUserPage()),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
