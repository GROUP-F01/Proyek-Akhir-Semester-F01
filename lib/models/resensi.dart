// To parse this JSON data, do
//
//     final resensi = resensiFromJson(jsonString);

import 'dart:convert';

List<Resensi> resensiFromJson(String str) => List<Resensi>.from(json.decode(str).map((x) => Resensi.fromJson(x)));

String resensiToJson(List<Resensi> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Resensi {
    String model;
    int pk;
    Fields fields;

    Resensi({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Resensi.fromJson(Map<String, dynamic> json) => Resensi(
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
    int user;
    int book;
    String publishedBy;
    DateTime publishedDate;
    String resensi;

    Fields({
        required this.user,
        required this.book,
        required this.publishedBy,
        required this.publishedDate,
        required this.resensi,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        book: json["book"],
        publishedBy: json["published_by"],
        publishedDate: DateTime.parse(json["published_date"]),
        resensi: json["resensi"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "book": book,
        "published_by": publishedBy,
        "published_date": publishedDate.toIso8601String(),
        "resensi": resensi,
    };
}