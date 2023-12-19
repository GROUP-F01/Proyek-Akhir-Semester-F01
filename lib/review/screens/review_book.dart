// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:literaloka/models/books.dart';
import 'package:literaloka/review/models/reviews.dart';
import 'package:literaloka/review/screens/write_review.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ReviewBookPage extends StatefulWidget {
  final Books book;

  const ReviewBookPage({Key? key, required this.book}) : super(key: key);

  @override
  _ReviewBookPageState createState() => _ReviewBookPageState();
}

class _ReviewBookPageState extends State<ReviewBookPage> {
  List<Review> _reviews = [];
  double _updatedRating = 0.0;

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    try {
      var url = Uri.parse('https://literaloka.my.id/get-review/${widget.book.pk}');
      var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        double totalRating = 0.0;
        for (var reviewData in data) {
          Review review = Review.fromJson(reviewData);
          totalRating += review.rating;
        }

        if (data.isNotEmpty) {
          _updatedRating = totalRating / data.length;
        }

        setState(() {
          _reviews = data.map((review) => Review.fromJson(review)).toList();
        });
      } else {
        print('Failed to fetch reviews. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
      }
    } catch (error) {
      print('Error fetching reviews: $error');
    }
  }

  Future<void> _handleRefresh() async {
    await fetchReviews();
  }

 @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Buku"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        backgroundColor: const Color.fromRGBO(78, 217, 148, 1),
        foregroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        right: 16.0,
                        top: 12.0,
                        bottom: 8.0,
                        left: 4.0,
                      ),
                      child: Image.network(
                        widget.book.fields.imageUrl,
                        fit: BoxFit.contain,
                        width: 175.0,
                        height: 175.0,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: Text(
                              widget.book.fields.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(widget.book.fields.author),
                          Row(
                            children: [
                              Text("Rating: ${_updatedRating.toStringAsFixed(2)}"),
                              Icon(
                                Icons.star,
                                color: Colors.yellow[700],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (request.loggedIn) {
                      final response = await request.postJson(
                        "https://literaloka.my.id/check-review/${widget.book.pk}",
                        jsonEncode(<String, String>{
                          'rating': 0.toString(),
                          'review': "",
                        }),
                      );
                      if (response['status'] == 'success') {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WriteReviewPage(
                              bookId: widget.book.pk,
                              book: widget.book,
                            ),
                          ),
                        );
                        if (result != null && result == true) {
                          await _handleRefresh();
                        }
                      } else if (response['status'] == 'duplicate') {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Peringatan"),
                              content: const Text(
                                  "Anda sudah pernah menulis review untuk buku ini."),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Peringatan"),
                            content: const Text(
                                "Anda belum login. Silakan login terlebih dahulu."),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(400, 20),
                  ),
                  child: const Text('Tulis Review'),
                ),
                const SizedBox(height: 16),
                const Divider(),
                _reviews.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _reviews.map((review) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.account_circle),
                                  const SizedBox(width: 3),
                                  Text(
                                    review.user.username,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: List.generate(
                                  review.rating,
                                  (index) => Icon(
                                    Icons.star,
                                    color: Colors.yellow[700],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(review.review),
                              const Divider(),
                            ],
                          );
                        }).toList(),
                      )
                    : const Text('Belum ada review :('),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
