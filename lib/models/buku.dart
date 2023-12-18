// To parse this JSON data, do
//
//     final buku = bukuFromJson(jsonString);

import 'dart:convert';

Buku bukuFromJson(String str) => Buku.fromJson(json.decode(str));

String bukuToJson(Buku data) => json.encode(data.toJson());

class Buku {
    String model;
    int pk;
    Fields fields;

    Buku({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Buku.fromJson(Map<String, dynamic> json) => Buku(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String isbn;
    String title;
    String description;
    String author;
    String publisher;
    String publicationDate;
    int pageCount;
    String category;
    String imageUrl;
    String lang;
    int price;

    Fields({
        required this.isbn,
        required this.title,
        required this.description,
        required this.author,
        required this.publisher,
        required this.publicationDate,
        required this.pageCount,
        required this.category,
        required this.imageUrl,
        required this.lang,
        required this.price,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        isbn: json["isbn"],
        title: json["title"],
        description: json["description"],
        author: json["author"],
        publisher: json["publisher"],
        publicationDate: json["publication_date"],
        pageCount: json["page_count"],
        category: json["category"],
        imageUrl: json["image_url"],
        lang: json["lang"],
        price: json["price"],
    );

    Map<String, dynamic> toJson() => {
        "isbn": isbn,
        "title": title,
        "description": description,
        "author": author,
        "publisher": publisher,
        "publication_date": "publicationDate",
        "page_count": pageCount,
        "category": category,
        "image_url": imageUrl,
        "lang": lang,
        "price": price,
    };
}