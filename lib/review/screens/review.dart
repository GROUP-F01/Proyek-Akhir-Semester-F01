import 'package:flutter/material.dart';
import 'package:literaloka/models/books.dart';
import 'package:literaloka/widgets/left_drawer.dart';
import 'package:literaloka/review/screens/review_book.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<Books> _books = [];
  List<int> _selectedRatings = [];

  @override
  void initState() {
    super.initState();
    fetchBook();
  }

  Future<void> fetchBook() async {
    var url = Uri.parse('http://127.0.0.1:8000/get-buku');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      _books = data.map((book) => Books.fromJson(book)).toList();
    });
  }

  Future<void> _handleRefresh() async {
    await fetchBook();
  }

  void _toggleRating(int rating) {
    setState(() {
      if (_selectedRatings.contains(rating)) {
        _selectedRatings.remove(rating);
      } else {
        _selectedRatings.add(rating);
      }
    });
  }

  void _showRatingFilterBottomSheet(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return RatingFilterBottomSheet(
          selectedRatings: _selectedRatings,
          onRatingChanged: (int rating) {
            _toggleRating(rating);
          },
          screenWidth: screenWidth,
        );
      },
    );
  }

  bool _shouldDisplayBook(Books book) {
    if (_selectedRatings.isEmpty) {
      return true;
    } else {
      return _selectedRatings.contains(book.fields.rating.floor());
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Books> filteredBooks =
        _books.where((book) => _shouldDisplayBook(book)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Literaloka'),
        backgroundColor: const Color.fromRGBO(78,217,148,1),
        foregroundColor: Colors.black,
      ),
      drawer: const LeftDrawer(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 22.0, bottom: 22.0),
                      child: Text(
                        'Review Page',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showRatingFilterBottomSheet(context);
                      },
                      child: const Text('Filter Rating'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.2 / 2.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  String title = filteredBooks[index].fields.title;
                  String truncatedTitle = title.length > 24
                      ? '${title.substring(0, 17)}...'
                      : title;
                  double rating = filteredBooks[index].fields.rating;
                  return InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ReviewBookPage(book: filteredBooks[index]),
                        ),
                      );
                      if (result != null && result == true) {
                        await _handleRefresh();
                      }
                    },
                    child: Card(
                      elevation: 3,
                      margin: const EdgeInsets.all(8),
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(top: 16.0),
                                child: Image.network(
                                  filteredBooks[index].fields.imageUrl,
                                  width: double.infinity,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    truncatedTitle,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    children: [
                                      Text("$rating"),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow[700],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: filteredBooks.length,
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class RatingFilterBottomSheet extends StatefulWidget {
  final List<int> selectedRatings;
  final Function(int) onRatingChanged;
  final double screenWidth;

  const RatingFilterBottomSheet({
    super.key,
    required this.selectedRatings,
    required this.onRatingChanged,
    required this.screenWidth,
  });

  @override
  _RatingFilterBottomSheetState createState() =>
      _RatingFilterBottomSheetState();
}

class _RatingFilterBottomSheetState extends State<RatingFilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.screenWidth,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            int rating = index + 1;
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.20 / 5,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow[700],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '$rating',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Checkbox(
                        value: widget.selectedRatings.contains(rating),
                        onChanged: (bool? value) {
                          setState(() {
                            widget.onRatingChanged(rating);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                if (index < 4) const Divider(),
              ],
            );
          }),
        ),
      ),
    );
  }
}
