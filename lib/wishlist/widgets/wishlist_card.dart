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
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(5, 5),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            bookImageUrl,
            width: double.infinity, // Make the image take the full width
            height: 200, // Set the desired height of the image
            fit: BoxFit.cover, // Ensure the image covers the entire space
          ),
          const SizedBox(height: 10),
          Text(
            "Category: $bookCategory",
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Title: $bookTitle",
            style: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Reason: $reason",
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}