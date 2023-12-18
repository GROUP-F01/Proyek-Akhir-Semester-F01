import 'package:flutter/material.dart';
import 'package:literaloka/models/books.dart';
import 'package:literaloka/widgets/left_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  List<String> selectedLanguages = []; // State variable for selected languages


  Future<List<Books>> fetchProduct() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse('http://127.0.0.1:8000/json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Books> listBuku = [];
    for (var d in data) {
      if (d != null) {
        listBuku.add(Books.fromJson(d));
      }
    }
    return listBuku;
  }

  Widget buildFilterCheckbox(String language) {
      String lang = "";
      if (language == "English") {
        lang = "en";
      } else if (language == "Tagalog") {
        lang = "ta";
      } else if (language == "Indonesia") {
        lang = "id";
      } else if (language == "Korea") {
        lang = "ko";
      } else {
        lang = "pt-BR";
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ChoiceChip(
          label: Text(language),
          selected: selectedLanguages.contains(lang),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                selectedLanguages.add(lang);
              } else {
                selectedLanguages.remove(lang);
              }
            });
          },
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Literaloka',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('Filter: '),
              Wrap(
                children: [
                  buildFilterCheckbox('English'),
                  buildFilterCheckbox('Tagalog'),
                  buildFilterCheckbox('Indonesia'),
                  buildFilterCheckbox('Korea'),
                  buildFilterCheckbox('Brazilian Portuguese'),
                  // Add more checkboxes for other languages as needed
                ],
              ),
            ],
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Daftar Buku: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: fetchProduct(),
              builder: (context, AsyncSnapshot<List<Books>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "Tidak ada data produk.",
                      style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                    ),
                  );
                } else {
                  // Filter the list based on selected languages
                  var filteredList = snapshot.data!
                      .where((book) =>
                          selectedLanguages.isEmpty ||
                          selectedLanguages.contains(book.fields.lang))
                      .toList();


                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (_, index) => Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(
                          "${filteredList[index].fields.title}",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text("Author: ${filteredList[index].fields.author}"),
                            const SizedBox(height: 8),
                            Text("Description: ${filteredList[index].fields.description}"),
                            const SizedBox(height: 8),
                            // Displaying Image from URL
                            Image.network(
                              snapshot.data![index].fields.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.fitHeight,
                              height: 75.0, // Adjust the height as needed
                              errorBuilder: (context, error, stackTrace) {
                                 return Text('(No Image)');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


