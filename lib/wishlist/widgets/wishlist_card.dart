import 'package:flutter/material.dart';

class WishlistCard extends StatelessWidget {
  final String bookImageUrl;
  final String bookCategory;
  final String bookTitle;
  final String reason;

  WishlistCard({
    required this.bookImageUrl,
    required this.bookCategory,
    required this.bookTitle,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    print(bookImageUrl);
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: Colors.grey,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
            bookImageUrl,
            width: 175,
            height: 300,
            ),
            const SizedBox(height: 10),
            Text(
              "Category: $bookCategory",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Title: $bookTitle",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Reason: $reason",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}