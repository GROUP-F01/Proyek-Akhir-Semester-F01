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
  List<String> selectedLanguages = [];
  TextEditingController searchController = TextEditingController();
  String bookSearched = "";

  Future<List<Books>> fetchProduct() async {
    var url = Uri.parse('https://literaloka.my.id/json/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

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
          'LiteraLoka',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(78, 217, 148, 1),
        foregroundColor: Colors.black,
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text('Filter by language: '),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        children: [
                          buildFilterCheckbox('English'),
                          buildFilterCheckbox('Tagalog'),
                          buildFilterCheckbox('Indonesia'),
                          buildFilterCheckbox('Korea'),
                          buildFilterCheckbox('Brazilian Portuguese'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Daftar Buku: ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder(
              future: fetchProduct(),
              builder: (context, AsyncSnapshot<List<Books>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "Tidak ada buku yang tersedia",
                      style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                    ),
                  );
                } else {
                  var filteredList = snapshot.data!
                      .where((book) =>
                          (selectedLanguages.isEmpty || selectedLanguages.contains(book.fields.lang)) &&
                          (bookSearched.isEmpty || book.fields.title.toLowerCase().contains(bookSearched.toLowerCase())))
                      .toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredList.length,
                    itemBuilder: (_, index) => Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Column(
                          children: [
                            Image.network(
                              filteredList[index].fields.imageUrl,
                              width: 200.0,
                              height: 200.0,
                              errorBuilder: (context, error, stackTrace) {
                                return const Text('(No Image)');
                              },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              filteredList[index].fields.title,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Author: ${filteredList[index].fields.author}",
                              textAlign: TextAlign.center, // Center the text
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Language: ${filteredList[index].fields.lang}",
                              textAlign: TextAlign.center, // Center the text
                            ),
                          ],
                        ),
                        subtitle: Column(
                          children: [
                            const SizedBox(height: 8),
                            Text(filteredList[index].fields.description),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
