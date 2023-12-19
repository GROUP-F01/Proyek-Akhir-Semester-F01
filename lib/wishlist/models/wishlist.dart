// To parse this JSON data, do
//
//     final wishlist = wishlistFromJson(jsonString);

import 'dart:convert';

List<Wishlist> wishlistFromJson(String str) => List<Wishlist>.from(json.decode(str).map((x) => Wishlist.fromJson(x)));

String wishlistToJson(List<Wishlist> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Wishlist {
    int id;
    int bookId;
    String bookTitle;
    String bookImageUrl;
    String bookCategory;
    String reason;

    Wishlist({
        required this.id,
        required this.bookId,
        required this.bookTitle,
        required this.bookImageUrl,
        required this.bookCategory,
        required this.reason,
    });

    factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
        id: json["id"],
        bookId: json["book__id"],
        bookTitle: json["book__title"],
        bookImageUrl: json["book__image_url"],
        bookCategory: json["book__category"],
        reason: json["reason"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "book__id": bookId,
        "book__title": bookTitle,
        "book__image_url": bookImageUrl,
        "book__category": bookCategory,
        "reason": reason,
    };
}
